
package bncf.opac.lucene;


import java.io.InputStream;
import java.io.FileInputStream;
import java.io.FileNotFoundException;


/**
 * Utilty per il caricamento dei records estratti dal file XML(unimarcslim) in indice lucene.
 */


public class LuceneLoadUnimarcXml
{

 public static void main(String args[])
 {
    String  input     = null;
    String  indexpath = null;

    boolean  overwrite = false;  // aggiorna un indice se gia' esistente (no replace)  
    boolean  verbose   = false;  // verbosity disabled 
    boolean  rw        = true;  // flag per attivare la scittura effettiva sul DB 
                                                                                                
    // long start = System.currentTimeMillis(); // per il log del tempo impiegato
                                                                                                
    for (int i = 0; i < args.length; i++)
    {
      if (args[i].equals("-c")) // crea nuovo indice 
      {
        overwrite  = true;
      }
      else if (args[i].equals("-i")) // index path 
      {
        if (i == (args.length - 1))
           usage();
        indexpath = args[++i].trim();
      }
      else if (args[i].equals("-n")) // simula esecuzione, no write 
      {
        rw = false;
      }
      else if (args[i].equals("-v")) // verbose 
      {
        verbose = true;
      }
      else if ( args[i].equals("--help") || args[i].equals("-?") )
      {
        usage();
      }
      else	// input file must be last arg 
      {
        input = args[i].trim();
        if (i != args.length - 1)
           usage();
      }
    } // for .. args 

    if (verbose) System.out.println( "input file " + input );
    if (verbose) System.out.println( "index path " + indexpath + "\n" );

    if ( (input == null) || (indexpath == null) )
    {
       usage();
       return;
    }

    InputStream inps = null;
    try
    {
      inps = new FileInputStream(input);
    }
    catch (FileNotFoundException ex)
    {
      System.err.println( "Errore nell'apertura del file " + input 
                          + "\n\t" + ex.getMessage() );
      return;
    }

    if (inps != null)
    {
      boolean indexopened = false;
      try
      {
        UnimarcXmlLuceneLoader lucene = new UnimarcXmlLuceneLoader();

        if (rw)
        {
          lucene.openIndex( indexpath, overwrite );
          indexopened = true;
          lucene.loadFromStream(inps,true);
          lucene.closeIndex(true); // flag optimizes index 
        }
      }
      catch (Exception ex)
      {
        if (indexopened)
            System.err.println( "Errore durante la lettura del file " + input 
                               + "\n\t" + ex.getMessage() );
        else
            System.err.println( "Errore durante l'apertura del indice " + indexpath 
                               + "\n\t" + ex.getMessage() );
        return;
      }
    }

 }

                                                                                                
private static void usage()
 {
   String help = "Usage: " + LuceneLoadUnimarcXml.class + " [-options] <file.xml>\n"
               + "        --help : questo messaggio\n" 
               + "        -i     : index path\n" 
               + "        -c     : crea un nuovo indice (cancella indice esistente)\n"
               + "        -v     : visualizza informazioni su stdout\n" ;
   System.err.println(help);
   System.exit(1);
 }
                                                                                                

} // class //


