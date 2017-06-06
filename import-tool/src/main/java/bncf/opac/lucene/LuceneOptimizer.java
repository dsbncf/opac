
package bncf.opac.lucene;

import java.io.File;
import java.io.IOException;

import org.apache.lucene.analysis.standard.StandardAnalyzer;
import org.apache.lucene.index.IndexWriter;
import org.apache.lucene.index.IndexWriterConfig;
import org.apache.lucene.store.Directory;
import org.apache.lucene.store.NIOFSDirectory;
import org.apache.lucene.util.Version;


/**
 * Ottimizza un indice Lucene.
 */

public class LuceneOptimizer
{

   private IndexWriter index = null;
   private String indexpath = null;

   public static void main(String args[])
   {
      if (args.length < 1)
      {
         usage();
      }
      String indexpath = args[0].trim();
      if ("".equals(indexpath))
          usage();
      try
      {
         LuceneOptimizer luc = new LuceneOptimizer(indexpath);
      }
      catch (Exception ex)
      {
         System.err.println(ex.getMessage() + ": " + indexpath);
      }
   }


   protected IndexWriter openIndex(String indexpath) throws IOException
   {
      Directory dir = new NIOFSDirectory(new File(indexpath));
      IndexWriterConfig conf = new IndexWriterConfig(Version.LUCENE_36, new StandardAnalyzer(Version.LUCENE_36));
      conf.setOpenMode(IndexWriterConfig.OpenMode.APPEND);
      return new IndexWriter(dir, conf);
   }


   private static void usage()
   {
      String help = "Usage: " + LuceneOptimizer.class + " index-path\n";
      System.err.println(help);
      System.exit(1);
   }

   public LuceneOptimizer(String indexpath) throws IOException
   {
      this.indexpath = indexpath;

      index = openIndex(indexpath);
      index.setUseCompoundFile(false);
      index.optimize();
      index.close();
   }

   public void optimize() throws IOException
   {
      index.optimize();
   }

   public void close(boolean optimize) throws IOException
   {
      index.close();
   }


} // class //

