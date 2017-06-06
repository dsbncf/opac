
package bncf.opac.utils;


import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;


/**
 * reads every thing from InputStream until it empty.
 */
public class StreamGobbler extends Thread
{
   private static final Logger logger = LoggerFactory.getLogger(StreamGobbler.class);

   private InputStream inputStream;
   private StringBuilder content = null;


   StreamGobbler(InputStream is)
   {
      this.inputStream = is;
   }


   public String getContent()
   {
      return (content == null) ? null : content.toString();
   }


   @Override
   public void run()
   {
      BufferedReader reader = null;
      content = new StringBuilder();
      try
      {
         reader = new BufferedReader(new InputStreamReader(inputStream));
         String line;
         while ((line = reader.readLine()) != null)
         {
            content.append(line).append("\n");
         }
      }
      catch (IOException ioe)
      {
         logger.error("",ioe);
      }
      finally
      {
         if (reader != null)
         {
            try { reader.close(); }
            catch (IOException ex) { logger.error("",ex); }
         }
      }
   }


} //class//
