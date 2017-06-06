
package bncf.opac.tools;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.util.Properties;


public class Config
{
   private static final Logger logger = LoggerFactory.getLogger(Config.class);

   private static final long DEFAULT_MIN_UPLOAD_AGE  = 600; // seconds

   private static final String PROPERTIES_FILE      = "/opactools.properties";
   private static final String PROP_UPLOAD_DIR      = "upload.dir";
   private static final String PROP_MIN_UPLOAD_AGE  = "upload.min.file.age";
   private static final String PROP_WORKDIR         = "work.dir";
   private static final String PROP_REL_SOGG        = "soggetti.relazioni.file";
   private static final String PROP_SOLR_HOST       = "solr.host";
   private static final String PROP_SOLR_UPDATE_DIR = "solr.update.dir";
   private static final String PROP_SOLR_SERVER_URL = "solr.server.url";
   private static final String PROP_SOLR_LUKE_URL   = "solr.luke.url";
   private static final String PROP_DB_PATH         = "db.path";
   private static final String PROP_DB_USER         = "db.user";
   private static final String PROP_DB_PASS         = "db.pass";
   private static final String PROP_UNIMARCSLIM_EXTRACTOR = "path.unimarcslim.extractor";
   private static final String PROP_SCHEMA_VALIDATION = "unimarcslim.schema.validation";

   private static Config instance = null;
   private final Properties properties;

   // directory where zip files will be uploaded
   private File uploadDir = null;
   // Minimum file age for uploaded files
   private long minUploadAge = DEFAULT_MIN_UPLOAD_AGE;
   // working dir (base dir)
   private File workDir = new File(System.getProperty("java.io.tmpdir"));
   // File che contiene le relazioni fra soggetti
   private File subjectRelations = null;
   // host on which solr is runnint
   private String solrHost = null;
   // directory where to put xml file for solr update
   private String solrUpdateDir = null;
   // e' da eseguire la validazione contro lo schema unimarcslim 
   private boolean schemaValidation = true;


   /**
    * Singleton Constructor.
    * uses packages default properties (classpath).
    */
   public Config() throws IOException
   {
      properties = new Properties();
      InputStream res = getClass().getResourceAsStream(PROPERTIES_FILE);
      try
      {
         properties.load(res);
      }
      finally {
         res.close();
      }
      init();
   }


   /**
    * Constructor, initialized from external file.
    * uses packages default properties (classpath).
    * @param path Path to properties file
    * @throws IOException
    */
   public Config(String path) throws IOException
   {
      properties = new Properties();
      FileInputStream stream = new FileInputStream(path);
      try
      {
         properties.load(stream);
      }
      finally {
         stream.close();
      }
      init();
   }

   private void init() throws IOException
   {
       // Upload directory
      String dirname = properties.getProperty(PROP_UPLOAD_DIR);
      uploadDir = new File(dirname);
      //if (!uploadDir.isDirectory())
      //    throw new IOException("upload dir is not a directory: " + dirname);

      // Working directory
      dirname = properties.getProperty(PROP_WORKDIR);
      if (dirname == null)
         logger.warn("Property non definita: {}", PROP_WORKDIR);
      else
      {
         workDir = new File(dirname);
         workDir.mkdirs();
         //if (!workDir.isDirectory())
         //   throw new IOException("workdir is not a directory: " + dirname);
      }
      // Relazioni soggetti
      dirname = properties.getProperty(PROP_REL_SOGG);
      subjectRelations = new File(dirname);
      if (!subjectRelations.isFile())
          throw new IOException("rile relazioni soggetti non valido: " + dirname);

      solrHost = properties.getProperty(PROP_SOLR_HOST);
      solrUpdateDir = properties.getProperty(PROP_SOLR_UPDATE_DIR);


      // Minimum file age for uploaded files
      try
      {
         minUploadAge = Long.parseLong(properties.getProperty(PROP_MIN_UPLOAD_AGE));
      }
      catch (NumberFormatException ex)
      {
         logger.warn("Property non definita: {}", PROP_MIN_UPLOAD_AGE);
      }
      
      // schemaValidation, default is TRUE (property is null)
      String s = properties.getProperty(PROP_SCHEMA_VALIDATION);
      schemaValidation = ((s == null) || s.equalsIgnoreCase("true")  || s.equalsIgnoreCase("yes")
                          || s.equalsIgnoreCase("on") || s.equals("1") );
      logAttributes();
   }


   public static Config getInstance() throws IOException
   {
      if (instance == null)
         instance = new Config();
      return instance;
   }

   public File getWorkDir()
   {
      return workDir;
   }

   public File getUploadDir()
   {
      return uploadDir;
   }

   public long getMinUploadAge()
   {
      return minUploadAge;
   }


   public String getSolrHost()
   {
      return solrHost;
   }


   public String getSolrUpdateDir()
   {
      return solrUpdateDir;
   }

   public String getLukeUrl()
   {
      return properties.getProperty(PROP_SOLR_LUKE_URL);
   }

   public File getSubjectRelationsFile()
   {
        return new File(properties.getProperty(PROP_REL_SOGG));
   }

   public String getDbPath()
   {
      return properties.getProperty(PROP_DB_PATH);
   }

   public String getDbUser()
   {
      return properties.getProperty(PROP_DB_USER);
   }

   public String getDbPass()
   {
      return properties.getProperty(PROP_DB_PASS);
   }

   
   public boolean isValidationRequired()
   {
      return schemaValidation;
   }

   private void logAttributes()
   {
      logger.info("{} = {}", PROP_UPLOAD_DIR, uploadDir);
      logger.info("{} = {}", PROP_MIN_UPLOAD_AGE, minUploadAge);
      logger.info("{} = {}", PROP_WORKDIR, workDir);
      logger.info("{} = {}", PROP_REL_SOGG, subjectRelations);
      logger.info("{} = {}", PROP_SCHEMA_VALIDATION, schemaValidation);
   }

   String getSolrServerURL()
   {
      return properties.getProperty(PROP_SOLR_SERVER_URL);
   }

   String getUnimarcslimExtractorPath()
   {
      return properties.getProperty(PROP_UNIMARCSLIM_EXTRACTOR);
   }

} //class//
