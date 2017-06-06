
package bncf.opac.indexing;


import java.io.IOException;
import java.io.InputStream;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.PrintWriter;
import java.util.Collection;
import java.util.Iterator;
import java.util.HashMap;
import java.util.Properties;


/**
 * Utilty per il caricamento dei records estratti
 * dal file XML(unimarcslim) nel database opac.
 */
public class OpacIndexer
{
  private static final String PROPS_FILE = "opacindexer.properties";
 
                                                                                                
 private static void usage(String msg)
 {
   System.err.println(msg);
   usage();
 }
                                                                                                
 private static void usage()
 {
   String help = "Usage: " + OpacIndexer.class
               + " -p <properties-file> [-options] <input-file.xml>\n"
               + "        -dbhost host-name  \n"
               + "        -dbname database-name  \n"
               + "        -dbuser username-password  \n"
               + "        -unimarcindex unimarc-index  \n"
               + "        -usage or -help = this message\n" ;
   System.err.println(help);
   System.exit(1);
 }
                                                                                                

 public static void main(String args[])
 {
    String   inputfile     = null;
    String   logfile       = null;
    String   indexfile     = null;
    String   dbhost        = null;
    String   dbname        = null;
    String   dbuser        = null;
    String   dbpass        = null;
    String   notiziaindex  = null;
    String   unimarcindex  = null;
    boolean  dummyrun      = false;
    boolean  createindex   = false;
    String  propertiesfile = null;
    Properties appProps = new Properties();

    //long start = System.currentTimeMillis();
                                                                                                
    for (int i = 0; i < args.length; i++)
    {
      if (args[i].equals("-l"))
      {
        if (i == args.length - 1)
           usage("argomento mancante per l'opzione -l");
        logfile = args[++i].trim();
      }
      else if (args[i].equals("-f"))
      {
        if (i == args.length - 1)
           usage("argomento mancante per l'opzione -i");
        indexfile = args[++i].trim();
      }
      else if (args[i].equals("-dbhost"))
      {
        if (i == args.length - 1)
           usage("argomento mancante per l'opzione -dbhost");
        dbhost = args[++i].trim();
      }
      else if (args[i].equals("-dbname"))
      {
        if (i == args.length - 1)
           usage("argomento mancante per l'opzione -dbname");
        dbname = args[++i].trim();
      }
      else if (args[i].equals("-dbuser"))
      {
        if (i == args.length - 1)
           usage("argomento mancante per l'opzione -dbuser");
        String[] userpass = args[++i].trim().split(",");
        if (userpass.length < 2)
           usage("formato dell'username sbagliato");
        dbuser = userpass[0];
        dbpass = userpass[1];
      }
      else if (args[i].equals("-notiziaindex"))
      {
        if (i == args.length - 1)
           usage("argomento mancante per l'opzione -notiziaindex");
        notiziaindex = args[++i].trim();
      }
      else if (args[i].equals("-unimarcindex"))
      {
        if (i == args.length - 1)
           usage("argomento mancante per l'opzione -unimarcindex");
        unimarcindex = args[++i].trim();
      }
      else if (args[i].equals("-p"))
      {
        if (i == args.length - 1)
           usage("argomento mancante per l'opzione -p");
        propertiesfile = args[++i].trim();
      }
      else if (args[i].equals("-c"))
      {
        createindex   = true;
      }
      else if (args[i].equals("-n"))
      {
        dummyrun   = true;
      }
      else if (args[i].equals("-usage"))
      {
        usage();
      }
      else if (args[i].equals("-help"))
      {
        usage();
      }
      else	// inputfile file must be last arg //
      {
        inputfile = args[i].trim();
                                                                                                
        if (i != args.length - 1)
        {
           usage("file di input mancante");
        }
      }
    }
    if (inputfile == null)
            usage("file di input mancante" );
  
    if (propertiesfile == null)
    {
       System.err.println("Error: file delle properties non specificato (-p).");
       return;
    }

    // load application properties from file //
    try {
          FileInputStream inp = new FileInputStream(propertiesfile);   
          appProps.load(inp);
          inp.close();
    }
    catch (java.io.FileNotFoundException ex)
    {
       System.err.println("Warning: file " + propertiesfile + " non trovato.");
    }
    catch (java.io.IOException ex)
    {
       System.err.println("Error durante la lettura del file " + propertiesfile);
    }

    appProps.put("notizia.create", Boolean.toString(createindex));

    // argomenti specificati sulla riga commando prevalgono
    if (dbhost != null) appProps.put("dbhost", dbhost);
    if (dbname != null) appProps.put("dbname", dbname);
    if (dbuser != null) appProps.put("dbuser", dbuser);
    if (dbpass != null) appProps.put("dbpass", dbpass);
    if (unimarcindex != null) appProps.put("unimarcindex", unimarcindex);
    if (notiziaindex != null) appProps.put("notizia.path", notiziaindex);

    InputStream inps;
    try
    {
      inps = new FileInputStream(inputfile);
    }
    catch (FileNotFoundException ex)
    {
      System.err.println( "Errore nell'apertura del file " + inputfile 
                          + "\n\t" + ex.getMessage() );
      return;
    }

      OpacIndexWriter indexwriter = null;
      try
      {
        indexwriter = new OpacIndexWriter();
        indexwriter.init(appProps);

        OpacIndexReader indexreader = new OpacIndexReader(inps);
        indexreader.load(indexwriter);
      }
      catch (Exception ex)
      {
        System.err.println("Errore: " + ex.getMessage() );
        return;
      }
      finally
      {
         if (indexwriter != null)
         {
            indexwriter.close();
         }
      }
 } //main//

 
} // class //


