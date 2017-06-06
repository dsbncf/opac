
package bncf.opac.util;

import org.apache.lucene.store.Directory;
import org.apache.lucene.store.SimpleFSDirectory;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.io.File;
import java.io.IOException;


public class SpellChecker
{
   private static final Logger logger = LoggerFactory.getLogger(SpellChecker.class);


   public SpellChecker()
   {
      //
   }
   
   public SpellChecker(Directory fsdir)
   {
      //
   }

   public void setAccuracy(float didyoumeanAccuracy)
   {
   }

   public String[] suggestSimilar(String word, int maxTermCount) throws IOException
   {
      return new String[] {};
   }

} //class//
