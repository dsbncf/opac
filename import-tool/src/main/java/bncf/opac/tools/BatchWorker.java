
package bncf.opac.tools;


import bncf.opac.utils.FileZipper;
import bncf.opac.utils.RelazioniSoggetti;
import bncf.opac.utils.SystemCommandExecutor;
import bncf.opac.utils.UnimarcslimToSolrConverterImpl;
import bncf.solr.SolrClient;
import bncf.solr.SolrDeletionFeed;

import org.apache.commons.io.FileUtils;
import org.apache.commons.io.FilenameUtils;
import org.apache.commons.lang3.StringUtils;
import org.apache.solr.common.util.StrUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.xml.sax.SAXException;

import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;

import javax.xml.transform.Source;
import javax.xml.transform.stream.StreamSource;
import javax.xml.validation.Schema;
import javax.xml.validation.SchemaFactory;
import javax.xml.validation.Validator;


public class BatchWorker
{
   private static final Logger logger = LoggerFactory.getLogger(BatchWorker.class);
   private static final SimpleDateFormat sdfwd = new SimpleDateFormat("yyyyMMdd-HHmmssSSS");
   private static final String UNIMARCSLIM_XSD = "/unimarcslim.xsd";
   private static final String UNIMARC_FILE_EXT = ".mrc";
   private static final String SOLR_ADD_XSL = "xsl/umcslim2solradd.xsl";
   private static final String SOLR_DEL_XSL = "xsl/umcslim2solrdel.xsl";
   private static final String SOLR_ADD_XML = "solradd-%s.xml";
   private static final String SOLR_DEL_XML = "solrdel-%s.xml";
   private static final String DEFAULT_UNIMARCSLIM_EXTRACTOR = "bin/extractISO2709";
   private static final String DEFAULT_SOLR_SERVER_URL = "http://localhost:8080/solr";
   private static final String SCART_FILENAME = "scartati.txt";
   private static final String DELETED_FILENAME = "bids_to_delete.txt";


   private final Config config;

   private boolean cleanupEnabled = false; // don't remove workdir
   private File workDir = null;
   private File workdirBase = null;
   private final File bidsToDeleteFile;
   private final File scartFile;
   private final String solrServerUrl;
   private final String unimarcslimExtractorPath;



   /**
    * Default Constructor.
    * @param config
    */
   public BatchWorker(Config config)
   {
      this.config = config;
      setWorkdirBase(config.getWorkDir(), sdfwd.format(new Date().getTime()));
      String s = config.getSolrServerURL();
      solrServerUrl = (s == null) ? DEFAULT_SOLR_SERVER_URL : s;
      s = config.getUnimarcslimExtractorPath();
      unimarcslimExtractorPath = (s == null) ? DEFAULT_UNIMARCSLIM_EXTRACTOR : s;
      bidsToDeleteFile = new File(workDir, DELETED_FILENAME);
      scartFile = new File(workDir, SCART_FILENAME);
   }


   public File getWorkdir()
   {
      return workDir;
   }


   public boolean isCleanupEnabled()
   {
      return cleanupEnabled;
   }


   public void setCleanupEnabled(boolean cleanupEnabled)
   {
      this.cleanupEnabled = cleanupEnabled;
   }


   public void cleanup()
   {
      if (workDir != null) {
         workDir.delete();
      }
   }


   /**
    * Esegue il batch nella work-dir utilizzando il file zip passato.
    * Il file zip puo essere esterno alla workdir.
    * @param zipFile file zip da utilizzare per l'elaborazione.
    * @throws IOException
    */
   public void loadCompressedMarc(File zipFile) throws IOException
   {
      String filename = zipFile.getName();

      // copy zip file into work dir, delete original
      File cpyTo = new File(workDir, filename);
      FileUtils.copyFile(zipFile, cpyTo);
      ArrayList<File> unimarcFiles = extractZipfile(zipFile, UNIMARC_FILE_EXT);

      for (File file : unimarcFiles)
      {
         try
         {
            File umcslimFile = convertUnimarcToUnimarcslim(file);
            loadUnimarcslim(umcslimFile);
         }
         catch (Exception ex)
         {
            logger.error("Failed to load unimarc: {}", workDir.getPath(), ex);
         }
      }
      if (cleanupEnabled)
      {
         cleanup();
      }
   }


   public void loadUnimarcslim(File umcslimFile) throws Exception
   {
      if (config.isValidationRequired())
      {
         logger.info("validating unimarcslim: {}", umcslimFile.getPath());
         validateUnimarcslim(umcslimFile);
      }
      /// unimarcslim -> solr input,filename with timestamp
      String dateIdent = sdfwd.format(new Date().getTime());
      File solrAddXml = new File(workDir, String.format(SOLR_ADD_XML, dateIdent));
      logger.info("generating Solr add feed: {}", solrAddXml.getPath());
      convertUnimarcslimToSolrInput(umcslimFile, solrAddXml);

      /// update solr using stream update, optimize (delete duplicates)
      SolrClient solr = new SolrClient(solrServerUrl);
      // handle deleted records
      File solrDelXml = buildSolrDelFeed(dateIdent, bidsToDeleteFile);
      if (solrDelXml != null)
      {
         logger.info("uploading delete-feed to Solr: {}", solrDelXml.getPath());
         solr.streamUpdate(solrDelXml);
      }
      logger.info("uploading update-feed to Solr: {}", solrAddXml.getPath());
      solr.streamUpdate(solrAddXml);
      solr.optimize();
   }
   
   protected final void setWorkdirBase(File workdirBase, String dateIdent)
   {
      this.workdirBase = workdirBase;
      workDir = new File(workdirBase, dateIdent);
      logger.info("workDir: {}", workDir.getPath());
      workDir.mkdirs();
   }

   
   protected File buildSolrDelFeed(String dateIdent, File source) throws IOException
   {
      if (!source.exists())
      {
         logger.debug("No bids to delete, file not present: {}", source.getPath());
         return null; 
      }
      File feedFile = new File(workDir, String.format(SOLR_DEL_XML, dateIdent));
      logger.debug("loading bids to delete from file: {}", source.getPath());
      logger.debug("writing Solr deletion feed: {}", feedFile.getPath());
      SolrDeletionFeed feed = new SolrDeletionFeed(feedFile);
      return feed.buildFeed(source);
   }


   protected void convertUnimarcslimToSolrInput(File umcslimFile, File solrAddXml) throws Exception
   {
      UnimarcslimToSolrConverterImpl converter = new UnimarcslimToSolrConverterImpl();
      InputStream addRes = ClassLoader.getSystemResourceAsStream(SOLR_ADD_XSL);
      if (addRes == null) {
         throw new  IOException("Resource not found: " + SOLR_ADD_XSL);
      }
      converter.setXsltForAdd(addRes);
      converter.setOutputAdd(solrAddXml);
      RelazioniSoggetti relSogg = new RelazioniSoggetti(config.getSubjectRelationsFile());
      converter.setRelazioniSoggetti(relSogg);
      long transformstart = System.currentTimeMillis();
      try
      {
         converter.transform(umcslimFile);
      }
      catch (Exception ex)
      {
         logger.error("input: {}", umcslimFile.getPath(), ex);
      }
      long finish = System.currentTimeMillis();
      long duration = (finish - transformstart) / 1000;
      logger.info("durata: " + duration + " sec.\n");
      logger.info("records for add: " + converter.getCountAdded());
   }


   protected boolean validateUnimarcslim(File file) throws SAXException
   {
      // 1. Lookup a factory for the W3C XML Schema language
      SchemaFactory factory = SchemaFactory.newInstance("http://www.w3.org/2001/XMLSchema");
      // 2. Compile the schema.
      InputStream res = getClass().getResourceAsStream(UNIMARCSLIM_XSD);
      // if (res == null) throw new Exception("resource not found: " + UNIMARCSLIM_XSD);
      StreamSource xsd = new StreamSource(res);
      Schema schema = factory.newSchema(xsd);
      // 3. Get a validator from the schema.
      Validator validator = schema.newValidator();
      // 4. Parse the document you want to check.
      logger.debug("validating file {}", file.getPath());
      Source source = new StreamSource(file);
      // 5. Check the document
      try
      {
         validator.validate(source);
         logger.debug("document is valid: {}", file.getName());
         return true;
      }
      catch (IOException ex)
      {
         logger.error("Validation of {}", file.getPath(), ex);
      }
      return false;
   }

   
   protected File convertUnimarcToUnimarcslim(File file) throws Exception
   {
       File umcslimFile = new File(workDir, FilenameUtils.getBaseName(file.getName()) + ".xml");

       String[] args = { unimarcslimExtractorPath, "-x",
                         "-s", scartFile.getPath(),
                         "-d", bidsToDeleteFile.getPath(),
                         file.getPath(),
                         umcslimFile.getPath()
                       };

       logger.debug("extract Unimarcslim args: {}", StringUtils.join(args, ", "));
       SystemCommandExecutor cmd = new SystemCommandExecutor();
       cmd.executeCommand(args);
       
       String stdout = cmd.getOutput();
       if ((stdout != null) && !stdout.isEmpty()) {
          logger.info("extractUnimarcslim stdout: {}", stdout);
       }

       String stderr = cmd.getErrorOutput();
       if ((stderr != null) && !stderr.isEmpty()) {
          logger.info("extractUnimarcslim stderr: {}", stderr);
       }

       return umcslimFile;
   }


   /**
    * extract files from zip file.
    * Restituisce la lista dei files estratti.
    *
    * @param zipFile  file from which files wil be extracted
    * @param extension if not null extracts only files with that extension.
    *
    * @return  The list of extracted files (only files, no directories)
    */
   protected ArrayList<File> extractZipfile(File zipFile, String extension)
   {
      FileZipper zipper = new FileZipper();
      return zipper.unzip(zipFile, workDir);
   }


} //class//
