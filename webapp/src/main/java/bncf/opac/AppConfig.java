

package bncf.opac;

import bncf.opac.db.OpacListDb;
import bncf.opac.db.OpacUserDb;
import bncf.opac.servlet.SearchServlet;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.io.IOException;
import java.io.InputStream;
import java.util.Locale;
import java.util.Properties;
import java.util.ResourceBundle;


 /**
  * Runtime configuration Dictionary.
  * Implements the model of a Singleton class; only one instance is available.
  */

public final class AppConfig extends Properties
{
   private final static Logger logger = LoggerFactory.getLogger(SearchServlet.class);
   
   private static final String PROPERTIES_RESOURCE = "/webapp.properties";   
   private static final String CFG_SOLR_LOCATION = "solr.location";   

   public static final String PROP_JDBC_DRIVER = "jdbc.driver";

   public static final String PROP_USERDB_PATH  = "userdb.path";
   public static final String PROP_USERDB_USER  = "userdb.user";
   public static final String PROP_USERDB_PASS  = "userdb.pass";
   
   public static final String PROP_LISTDB_PATH  = "listdb.path";
   public static final String PROP_LISTDB_USER  = "listdb.user";
   public static final String PROP_LISTDB_PASS  = "listdb.pass";
   public static final String PROP_LISTDB_PAGESIZE = "listdb.pagesize";

   public static final String PROP_MAX_EXPORT = "export.max"; // int
   public static final String PROP_SOLR_MAXROWS = "solr.rows.max"; //int
   public static final String PROP_DEWEYTREE_DATAFILE = "dewey.tree.datafile";


   // TODO:       logger.debug("System:file.encoding= {}", System.getProperty("file.encoding"));

   private static AppConfig instance = null;
   private String resourcebundlename = null;

   
   
   
   public int getSolrResultMaxRows()
   {
      return getInt(PROP_MAX_EXPORT);
   }
   

   public int getMaxExport()
   {
      return getInt(PROP_MAX_EXPORT);
   }

   public String getDeweytreeDatafile()
   {
      return getProperty(PROP_DEWEYTREE_DATAFILE);
   }


   
  /** 
   * Class method for obtaining a reference to the static AppConfig instance.
   */
  public static synchronized AppConfig getInstance ()
  {
    if (instance == null)
    {
      instance = new AppConfig();
      instance.loadProperties();
      
    }
    return instance;
  }

  
   private AppConfig()
   {
      super();
   }

   
   private void loadProperties()
   {
      try
      {
         InputStream inp = this.getClass().getResourceAsStream(PROPERTIES_RESOURCE);
         this.load(inp);
         inp.close();
      }
      catch (IOException ex)
      {
         logger.error("Could not load properties from {}", PROPERTIES_RESOURCE, ex);
         throw new RuntimeException(ex);
      }
   }
   
   
   private int getInt(String key)
   {
      return Integer.parseInt(getProperty(PROP_LISTDB_PAGESIZE));
   }
   
   
   
   // ---------------------- public ----------------------------------------------
  
   
   
   public OpacListDb getOpacListDb()
   {
      return new OpacListDb(getProperty(PROP_LISTDB_PATH), getProperty(PROP_LISTDB_USER),
                            getProperty(PROP_LISTDB_PASS), getInt(PROP_LISTDB_PAGESIZE));
   }

   
   public OpacUserDb getOpacUserDb()
   {
      return new OpacUserDb(getProperty(PROP_USERDB_PATH), getProperty(PROP_USERDB_USER),
                            getProperty(PROP_USERDB_PASS));
   }


   public String getJdbcDriverClassname()
   {
      return getProperty(PROP_JDBC_DRIVER);
   }
   

   public String getSolrLocation()
   {
      return getProperty(CFG_SOLR_LOCATION);
   }


   /**
    * Ritorna il basename del <code>ResourceBundle</code>.
    */
   public String getResourceBundleName()
   {
      return this.resourcebundlename;
   }


   /**
    * Assegna il basename del <code>ResourceBundle</code>.
    */
   public void setResourceBundleName(String basename)
   {
      this.resourcebundlename = basename;
   }


   /**
    * Ritorna il <code>ResourcBundle</code> per una specifica Locale.
    */
   public ResourceBundle getResourceBundle(Locale locale)
   {
      return ResourceBundle.getBundle(resourcebundlename, locale);
   }


   /**
    * Ritorna il <code>ResourcBundle</code> per una specifica lingua.
    */
   public ResourceBundle getResourceBundle(String language)
   {
      return this.getResourceBundle(new Locale(language));
   }


   /**
    * Ritorna il <code>ResourcBundle</code> per una specifica lingua e un paese.
    */
   public ResourceBundle getResourceBundle(String language, String country)
   {
      return this.getResourceBundle(new Locale(language, country));
   }


} //class//
