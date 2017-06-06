
package bncf.opac.lucene;


import java.io.IOException;
import java.io.InputStream;
import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.util.Properties;


/**
 * Utilty per il caricamento dei records estratti dal file XML(unimarcslim) nel database opac.
 */


public class OpacBidRemover
{
  //private static Logger _logger = Logger.getLogger("OpacBidRemover");

 // command line args prevalgono sulle definizioni
 // nel properties file.

 private static void usage()
 {
   String help = "Usage:  " + OpacBidRemover.class + " [-options] inputfile\n"
               + "options:\n"
               + "        -i   dir     : indice principale notizia (lucene)\n"
               + "        -u   dir     : indice unimarc (lucene)\n"
               + "        -p   file    : properties file\n"
               + "        -nidx        : do not update index\n"
               + "        -ndb         : do not update database\n"
               + "        -? or --help : this message\n"
               ;
   System.err.println(help);
   System.exit(1);
 }

 public static void main(String args[])
 {
    String     inputfile        = null;
    String     logfile          = null;
    String     properties_file  = null;
    String     notizia_index    = null;
    String     unimarc_index    = null;
    String     dbname           = null;
    String     dbhost           = null;
    String     dbuser           = null;
    String     dbdriver         = "jdbc:sapdb://";
    boolean    updateDB         = true;
    boolean    updateIDX        = true;
    boolean    verbose          = false;
    Properties appProperties    = new Properties();

    // long start = System.currentTimeMillis(); // per il log del tempo impiegato

    //  process command line arguments

    for (int i = 0; i < args.length; i++)
    {
      if (args[i].equals("-l"))
      {
        if (i == args.length - 1)
           usage();
        logfile = args[++i].trim();
      }
      else if (args[i].equals("-i"))
      {
        if (i == args.length - 1)
           usage();
        notizia_index = args[++i].trim();
      }
      else if (args[i].equals("-u"))
      {
        if (i == args.length - 1)
           usage();
        unimarc_index = args[++i].trim();
      }
      else if (args[i].equals("-p"))
      {
        if (i == args.length - 1)
           usage();
        properties_file = args[++i].trim();
      }
      else if (args[i].equals("-nidx"))
      {
        updateIDX  = false;
      }
      else if (args[i].equals("-ndb"))
      {
        updateDB  = false;
      }
      else if (args[i].equals("-dbname"))
      {
        if (i == args.length - 1)
           usage();
        dbname = args[++i].trim();
      }
      else if (args[i].equals("-dbhost"))
      {
        if (i == args.length - 1)
           usage();
        dbhost = args[++i].trim();
      }
      else if (args[i].equals("-dbuser"))
      {
        if (i == args.length - 1)
           usage();
        dbuser = args[++i].trim();
      }
      else if (args[i].equals("-?"))
      {
        usage();
      }
      else if (args[i].equals("--help"))
      {
        usage();
      }
      else	// inputfile file must be last arg //
      {
        inputfile = args[i].trim();

        if (i != args.length - 1)
        {
           usage();
        }
      }
    } // for .. args //
    if (inputfile == null)
            usage();



    // load application properties from file properties_file //
    if (properties_file == null)
    {
       appProperties = new Properties();
    }
    else
    {
       try {
             FileInputStream inp = new FileInputStream(properties_file);   
             appProperties.load(inp);
             inp.close();
       }
       catch (java.io.FileNotFoundException ex)
       {
          System.err.println("Error: file " + properties_file + " non trovato.");
          System.exit(1);
       }
       catch (java.io.IOException ex)
       {
          System.err.println("Errore durante la lettura del file " + properties_file);
          System.exit(1);
       }
    }
   



    // get index files from properties if not specified on command line. //
    if (notizia_index != null)
       appProperties.put("notizia.index", notizia_index);

    if (unimarc_index != null)
       appProperties.put("unimarc.index", unimarc_index);



    // open input stream (notiziaindex.xml) //
    InputStream inps = null;
    try
    {
      inps = new FileInputStream(inputfile);
    }
    catch (FileNotFoundException ex)
    {
      System.err.println( "Errore nell'apertura del file " + inputfile 
                          + "\n\t" + ex.getMessage() );
      System.exit(1);
    }

    if (!updateIDX)
       System.err.println("Esecuzione senza aggiornamento effettivo dell'indice");
    if (!updateDB)
       System.err.println("Esecuzione senza aggiornamento effettivo del database");

    // open indexes (for deletion) //

    OpacIndexRemover indexremover = null;
    try
    {
        indexremover = new OpacIndexRemover(appProperties);
        indexremover.setReadonly(!updateIDX);
    }
    catch (Exception ex)
    {
        System.err.println("Errore: " + ex.getMessage() );
        ex.printStackTrace();
        System.exit(1);
    }

    OpacDbRemover dbremover = null;
    if (updateDB)
    {
       try
       {
          dbremover = new OpacDbRemover();
          boolean err = ( (dbdriver == null) || (dbhost == null)
                         || (dbname == null) || (dbuser == null) );
          if (err)
             System.err.println("Errore: parametri di connessione al DB mancanti:" );
    
          if (err || verbose)
          {
             System.err.println( "Connection parameters: ");
             System.err.println( "                 host: " + dbremover.getDbHost() );
             System.err.println( "             database: " + dbremover.getDbName() );
             System.err.println( "                 user: " + dbremover.getDbUser() );
             System.err.println( "                dburl: " + dbremover.getDbUrl() );
          }
          if (err)
            System.exit(1);
          dbremover.connect( dbdriver, dbhost, dbname, dbuser );
          dbremover.setReadonly(!updateDB);
       }
       catch (Exception ex)
       {
           System.err.println("Errore: " + ex.getMessage() );
           ex.printStackTrace();
           System.exit(1);
       }
    }


    // start reading data //
    if (inps != null)
    {
       BufferedReader filereader =  new BufferedReader( new InputStreamReader(inps) );

       String line;
       try
       {
          while ((line = filereader.readLine()) != null)
          {
             String[] ls = line.split("\\s",2);
             String bid = ls[0];
             if (bid.equals(""))
                 System.err.println("empty bid: " + line);
             else
             {
                 String bidlc = bid.toLowerCase();
                 if (indexremover.deleteIdn(bidlc))
                    System.out.println(bid + " deleted (lucene)");
                 if ( (dbremover != null) && dbremover.deleteIdn(bidlc) )
                    System.out.println(bid + " deleted (maxdb)");
             }
          }
       }
       catch (IOException ex)
       {
         ex.printStackTrace();
       }
    }

    try
    {
        indexremover.close();
        if (dbremover != null)
           dbremover.close();
    }
    catch (Exception ex)
    {
        ex.printStackTrace();
        System.exit(1);
    }

 }

} // class //

