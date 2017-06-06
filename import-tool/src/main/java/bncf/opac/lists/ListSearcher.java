

package bncf.opac.lists;


import org.apache.lucene.index.IndexReader;

import org.apache.lucene.store.Directory;

import java.io.BufferedReader;
import java.io.File;
import java.io.InputStreamReader;
import java.io.IOException;


public class ListSearcher
{
    private final String indexDirName;
    // private Directory spellIndex   = null;

    public ListSearcher(String indexDirName) throws IOException
    {
       this.indexDirName = indexDirName;
    }
   
    public String[] getSuggestions(String misspelled) throws IOException
    {
       return null;
    }

    public void printSimili(String word) throws IOException
    {
       String[] simili = getSuggestions(word);
       for(String simil: simili)
       {
          System.out.println(simil);
       }
    }

  public static void usage()
  {
       System.out.println( "usage:  ListSearcher  mis-spelled-word  index");
  }


  public static void main( String[] args )
  {
    if (args.length < 1)
    {
       usage();
       System.exit(1);
    }

    ListSearcher searcher = null;
    try
    {
       searcher = new ListSearcher(args[0]);
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


} //class//
