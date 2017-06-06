
package bncf.opac.utils;


import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.util.zip.ZipEntry;
import java.util.zip.ZipInputStream;


import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.util.ArrayList;



/**
 * Usage:
 * <pre>
 *     FileZipper.unzip(zipFile, outputFolder);
 * </pre>
 */
public class FileZipper
{
   private static final Logger logger = LoggerFactory.getLogger(FileZipper.class);

   public FileZipper()
   {
      //
   }


   /**
    * Unzip a zip file.
    *
    * @param zipFile      input zip file
    * @param outputFolder zip file output folder
    */
   public void unzip(String zipFile, String outputFolder)
   {
       unzip(new File(zipFile), new File(outputFolder));
   }

   /**
    * Unzip a zip file.
    *
    * @param zipFile      input zip file
    * @param outputFolder zip file output folder
    */
   public ArrayList<File> unzip(File zipFile, File outputFolder)
   {
      return unzip(zipFile, outputFolder, null);
   }

   /**
    * Unzip a zip file (recursive).
    * Directory structure is maintained.
    *
    * @param zipFile      input zip file
    * @param outputFolder zip file output folder
    * @param fileExtension if specified (not null) only files with that extension will be extracted.
    * @return  The list of files that have been extracted, only files, not directories
    */
   public ArrayList<File> unzip(File zipFile, File outputFolder, String fileExtension)
   {
      ArrayList<File> extractedFiles = new ArrayList<>();
      try
      {
         //create output directory is not exists
         outputFolder.mkdirs();

         //get the zip file content
         ZipInputStream zis = new ZipInputStream(new FileInputStream(zipFile));
         //get the zipped file list entry
         ZipEntry ze = zis.getNextEntry();
         while (ze != null)
         {
            String fileName = ze.getName();
            File newFile = new File(outputFolder.getPath() + File.separator + fileName);
            logger.info("file unzip : " + newFile.getAbsoluteFile());
            // reate folder or write file
            if (ze.isDirectory())
            {
               newFile.mkdirs();
            }
            else
            {
               if ((fileExtension == null) || newFile.getName().endsWith(fileExtension))
               {
                  writeFile(newFile, zis);
                  extractedFiles.add(newFile);
               }
            }
            ze = zis.getNextEntry();
         }
         zis.closeEntry();
         zis.close();
      }
      catch (IOException ex)
      {
         logger.error("zip file: {}", zipFile, ex);
      }
      return extractedFiles;
   }


   private void writeFile(File newFile, ZipInputStream zis) throws IOException
   {
      byte[] buffer = new byte[1024];
      FileOutputStream fos = new FileOutputStream(newFile);
      int len;
      while ((len = zis.read(buffer)) > 0)
      {
         fos.write(buffer, 0, len);
      }
      fos.close();
   }


} //class//
