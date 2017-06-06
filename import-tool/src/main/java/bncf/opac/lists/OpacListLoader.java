
package bncf.opac.lists;

import bncf.opac.tools.Config;
import java.io.IOException;
import java.io.InvalidObjectException;
import java.sql.SQLException;
import java.util.ArrayList;

import java.util.List;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;


 /**
  * Programma principale per il caricamento dei Terms nel database.
  * 
  * Il database contiene le varie liste consultabili nell'opac (scorrimento e ricerca).
  * 
  * Per ciascuna lista iene eseguito l'accesso a solr e dopo la normalizzazione
  * i dati vengono caricati nel database.
  *
  */

public class OpacListLoader
{
   private static final Logger logger = LoggerFactory.getLogger(OpacListLoader.class);
   
   private static final String FIELD_AUTORE   = "autore_fc";
   private static final String FIELD_DESCR    = "descrittore_fc";
   private static final String FIELD_SOGGETTO = "soggetto_fc";
   private static final String FIELD_TITOLO   = "titolo_fc";
   private static final String FIELD_DEWEY    = "deweyall_fc";

      
   private final Config config;


   public OpacListLoader(Config config)
   {
      this.config = config;
   }


   protected void load(String field) throws SQLException
   {
      LukeTermsRequest req = new LukeTermsRequest(config.getLukeUrl(), field);
      List<LukeTerm> terms = req.getTerms();
      
      OpacTermsDb db = new OpacTermsDb(config);
      if (field.equals(FIELD_DEWEY))
      {
         db.setTables("DEWEY", "TEMP_DEWEY");
         db.loadDeweyTerms(terms);
      }
      else
      {
         if (field.equals(FIELD_AUTORE))
            db.setTables("AUTORE", "TEMP_AUTORE");
         if (field.equals(FIELD_DESCR))
            db.setTables("DESCRITTORE", "TEMP_DESCRITTORE");
         if (field.equals(FIELD_SOGGETTO))
            db.setTables("SOGGETTO", "TEMP_SOGGETTO");
         if (field.equals(FIELD_TITOLO))
            db.setTables("TITOLO", "TEMP_TITOLO");
         db.loadTerms(terms);
      }
      db.close();
   }
   

  public static void usage()
  {
      System.out.println( "usage:  TermsDbLoader -p properties-file [autore_fc|descrittore_fc|titolo_fc|soggetto_fc|dewey_fc]");
  }

  public static Config getConfig(String[] args) throws IOException
  {
     Config conf = null;
     
     for (int j = 0 ; j < args.length ; j++)
     {
         if (args[j].equals("-p"))
         {
            if (j+1 > args.length)
               throw new InvalidObjectException("Option '-p' without argument");
            conf = new Config(args[j+1]);
         }
      }
      return (conf == null) ? new Config() : conf;
  }


  public static ArrayList<String> getFields(String[] args) throws IOException
  {
     ArrayList<String> fields = new ArrayList<>();
     for (int j = 0 ; j < args.length ; j++)
     {
         if (args[j].equals("-p"))
         {
            j++;
            continue;
         }
         fields.add(args[j]);
      }
      return fields;
  }
  
   // Options:   replace/update, properties file
   // args:      field
   public static void main(String[] args) 
   {
      if (args.length < 1)
      {
         usage();
         System.exit(1);
      }

      Config config;
      boolean errors = false;
      try
      {
         config = getConfig(args);
         for (String field : getFields(args))
         {
           OpacListLoader loader = new OpacListLoader(config);
            try
            {
               loader.load(field);
            }
            catch (SQLException ex)
            {
               logger.error("Loading field {}", ex);
               errors = true;
               continue;
            }
         }
      }
      catch (IOException ex)
      {
         ex.printStackTrace(System.err);
         errors = true;
      }
      if (errors)
         System.exit(1);
  }

  
}//class//
