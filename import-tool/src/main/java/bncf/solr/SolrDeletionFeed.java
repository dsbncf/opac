
package bncf.solr;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.FileReader;
import java.io.IOException;
import java.io.OutputStream;
import java.io.OutputStreamWriter;
import java.io.PrintWriter;
import java.io.UnsupportedEncodingException;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public class SolrDeletionFeed
{
   private static final Logger logger = LoggerFactory.getLogger(SolrDeletionFeed.class);
   private static final String FEED_ENCODING = "UTF-8";
   
   private final File deletionFeed;
   
   
   public SolrDeletionFeed(File deletionFeed)
   {
      this.deletionFeed = deletionFeed;
   }

   public File buildFeed(File source) throws IOException
   {
      PrintWriter writer = null;
      BufferedReader rd = null;
      try
      {
         rd = new BufferedReader(new FileReader(source));
         String line = rd.readLine();
         if (line == null)
            return null;
         // initialize
         writer = initFeedWriter(deletionFeed);
         initFeed(writer);
         // read ID's
         int lineCount = 0;
         while (line != null)
         {
            ++lineCount;
            writer.println(String.format("<id>%s</id>", line));
            line = rd.readLine();
         }
         // close
         closeFeed(writer);
         if (lineCount == 0)
         {
            deletionFeed.delete();
            return null;
         }
      }
      finally {
         if (rd != null)
         {
            rd.close();
         }
         if (writer != null)
         {
            writer.close();
         }
      }
      return deletionFeed;
   }

   
   private void initFeed(PrintWriter writer)
   {
      writer.println("<?xml version=\"1.0\" encoding=\"" + FEED_ENCODING + "\"?>");
      writer.println("<delete>");
   }
   
   private void closeFeed(PrintWriter writer)
   {
      writer.println("</delete>");
      writer.flush();
      writer.close();
   }   

   /**
    * Sets the output stream for printing documents to delete.
    *
    * @param outputfile
    *
    * @throws UnsupportedEncodingException
    * @throws FileNotFoundException
    */
   private PrintWriter initFeedWriter(File outputfile)
   throws UnsupportedEncodingException, FileNotFoundException
   {
      OutputStream ostream = (outputfile == null) ? System.out : new FileOutputStream(outputfile);
      java.io.Writer writer = new OutputStreamWriter(ostream, FEED_ENCODING);
      return new PrintWriter(writer);
   }
   
    
} //class//
