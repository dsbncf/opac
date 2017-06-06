

package bncf.opac.lists;


import org.apache.lucene.index.IndexReader;
import org.apache.lucene.index.Term;
import org.apache.lucene.index.TermEnum;
import org.apache.lucene.store.Directory;

import java.io.File;
import java.io.IOException;

 /**
  * Estrazione delle liste dall'indice principale e caricamento in un'indice a parte.
  *
  * Classe eseguibile (metodo main presente).
  *
  */


public class ListIndexer
{
    public static void createListIndex( Directory originalIndexDirectory, String field ) throws IOException
    {
        IndexReader indexReader = null;
        try
        {
            TermEnum termEnum = indexReader.terms(new Term(field,null));
            while (termEnum.next())
            {
              int docFreq = termEnum.docFreq();
              Term term = termEnum.term();
              System.out.println(term.text() + " : " + docFreq);
            }
        }
        finally
        {
            if (indexReader != null)
                indexReader.close();
        }
    }

  public static void usage()
  {
       System.out.println( "usage:  ListIndexer  originalIndex  originalField");
  }


  public static void main( String[] args )
  {
    if (args.length < 3)
    {
       usage();
       System.exit(1);
    }
    String origindex = args[0];
    String field     = args[1];

    System.out.println("original index: " + origindex);
    System.out.println("original field: " + field);

    try
    {
       Directory dirOrig  = null; // new SimpleFSDirectory(new File(origindex));
       createListIndex(dirOrig, field);
    }
    catch(Exception ex)
    {
       ex.printStackTrace();
    }
  }


}//class//
