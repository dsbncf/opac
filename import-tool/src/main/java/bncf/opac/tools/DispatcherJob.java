
package bncf.opac.tools;


import org.quartz.Job;
import org.quartz.JobExecutionContext;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.io.File;
import java.io.IOException;
import java.nio.file.Files;
import java.text.SimpleDateFormat;
import java.util.Date;

import static java.nio.file.StandardCopyOption.REPLACE_EXISTING;


public class DispatcherJob implements Job
{
   private static final Logger logger = LoggerFactory.getLogger(DispatcherJob.class);
   private static final SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");

   private static final String MARC_FILE_EXTENSION = ".mrc";
   private static final String ZIP_FILE_EXTENSION = ".zip";
   private static final String XML_FILE_EXTENSION = ".xml";

   // Todo: spostare properties in classe Config
   // private static final String PROP_CLEAN_WORKDIR = "work.dir.cleanup";
   // private static final String PROP_WORKDIR       = "archive.dir";
   // private File uploadDir = null;
   // private File workDirBase = new File(System.getProperty("java.io.tmpdir"));
   private long minModifiedAge = 30;  // seconds
   private Config config = null;


   /**
    * Construttore con inizializzazione della directory da osservare.
    *
    * @throws IOException
    */
   public DispatcherJob() throws IOException
   {
      config = Config.getInstance();
   }

   @Override
   public void execute(JobExecutionContext context)
   {
      //JobDataMap data = context.getMergedJobDataMap();
      //logger.info("someProp = " + data.getString("someProp"));
      logger.debug(sdf.format(new Date()));
      File uploadDir = config.getUploadDir();
      if (uploadDir == null) {
         logger.error("UploadDir non configurata");
         return;
      }
      processFiles(uploadDir);
   }

   private void processFiles(File folder)
   {
      for (final File file : folder.listFiles())
      {
         if (file.isDirectory()) {
            continue;
         }

         String fileName = file.getName();
         boolean isZipfile = fileName.endsWith(ZIP_FILE_EXTENSION);
         if (!isZipfile && !fileName.endsWith(XML_FILE_EXTENSION))
         {
            logger.info("Not a zip or xml file: {}", fileName);
            continue;
         }

         // controlla che il file non sia stato modificato negli utltimi `minModifiedAge` secondi.
         long modificationTimeLimit = new Date().getTime() - (minModifiedAge * 1000);
         if (file.lastModified() > modificationTimeLimit)
         {
            logger.info("last modified: {} - modificationTimeLimit: {}", file.lastModified(), modificationTimeLimit);
            continue;
         }

         logger.info("File da elaborare: {}", fileName);
         BatchWorker worker = new BatchWorker(config);
         try
         {
            if (isZipfile) {
               worker.loadCompressedMarc(file);
               file.delete(); // remove original zip file
            }
            else {
               worker.loadUnimarcslim(file);
               File target = new File(worker.getWorkdir(), file.getName());
               Files.move(file.toPath(), target.toPath(), REPLACE_EXISTING);
            }
         }
         catch (Exception ex)
         {
            logger.error("Elaborazione file {}", fileName, ex);
         }
      }
   }



} //class//

