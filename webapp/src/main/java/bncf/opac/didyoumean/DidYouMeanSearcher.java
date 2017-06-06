

package bncf.opac.didyoumean;


// import org.apache.lucene.search.spell.SpellChecker;
import bncf.opac.util.SpellChecker;

import org.apache.lucene.store.Directory;
import org.apache.lucene.store.SimpleFSDirectory;

import java.io.BufferedReader;
import java.io.File;
import java.io.InputStreamReader;
import java.io.IOException;


public class DidYouMeanSearcher
{
   private String indexDirName = null;
   private Directory spellIndex = null;
   private SpellChecker spellChecker = null;

   public DidYouMeanSearcher(String indexDirName) throws IOException
   {
      spellIndex = new SimpleFSDirectory(new File(indexDirName));
      spellChecker = new SpellChecker(spellIndex);
      this.indexDirName = indexDirName;
   }


   public String[] getSuggestions(String misspelled) throws IOException
   {
      return spellChecker.suggestSimilar(misspelled, 20);
   }


   public void printSimili(String word) throws IOException
   {
      String[] simili = getSuggestions(word);
      for (String simil : simili)
      {
         System.out.println(simil);
      }
   }




  public static void usage()
  {
       System.out.println( "usage:  DidYouMeanSearcher  mis-spelled-word  index");
  }


  public static void main( String[] args )
  {
    if (args.length < 1)
    {
       usage();
       System.exit(1);
    }

    DidYouMeanSearcher searcher = null;
    try
    {
       searcher = new DidYouMeanSearcher(args[0]);
       if (args.length > 1)
       {
          searcher.printSimili(args[1]);
          return;
       }
    }
    catch(Exception ex)
    {
       ex.printStackTrace();
    }

    try
    {
        BufferedReader in = new BufferedReader(new InputStreamReader(System.in));
        String s;
        System.out.print("parola? ");
        while ((s = in.readLine()) != null && s.length() != 0)
        {
           searcher.printSimili(s);
           System.out.println("-----------------------------------");
           System.out.print("\nparola? ");
        }
    }
    catch(Exception ex)
    {
       ex.printStackTrace();
    }

  }


}//class//
