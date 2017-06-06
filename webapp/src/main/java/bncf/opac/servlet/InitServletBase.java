

package bncf.opac.servlet;

import bncf.opac.AppConfig;
import bncf.opac.Constants;

import java.io.InputStream;
import java.lang.reflect.Method;
import java.util.Enumeration;
import java.util.Properties;
import javax.naming.Context;
import javax.naming.InitialContext;

import javax.servlet.ServletConfig;
import javax.servlet.ServletContext;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.sql.DataSource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;



/**
 * <strong>InitServletBase</strong> inizializza l'istanza di AppConfig.
 * La classe mette a disposizione metodi di supporto per la individuazione
 * della DataSource tramite resource id e per la creazione di instanze
 * di una classe tramite il suo nome.
 *
 * @author ds
 * @version $Revision: 1.5 $ $Date: 2005-05-05 13:06:54 $
 */

public class InitServletBase   extends HttpServlet
{
  protected static Logger    logger = LoggerFactory.getLogger(InitServletBase.class);
  protected ServletConfig  servletconfig = null;
  protected AppConfig      appconfig = null;


   /**
    * Inizializzazoine della Servlet.
    *
    * @exception ServletException on configuration error.
    */
   @Override
   public void init(ServletConfig config) throws ServletException
   {
      super.init(config);
      servletconfig = config;
      appconfig = AppConfig.getInstance();
   }


   /**
    * Loads ServletConfig init-parameters into AppConfig.
    * Carica tutti i parametri di inizializzazione della
    * servlet in AppConfig.
    *
    * @exception ServletException on configuration error.
    */
   public void loadConfigParameters() throws ServletException
   {
      // ServletConfig servletconfig = getServletConfig();

      for (Enumeration enm = servletconfig.getInitParameterNames();
	   enm.hasMoreElements();)
      {
	 String key = (String) enm.nextElement();

	 if (!Constants.IPARAM_LOADCONTEXT.equals(key))
	 {
	    String val = servletconfig.getInitParameter(key);
	    appconfig.put(key, val);
	    logger.debug("config-param : " + key + " = " + val);
	 }
      }
   }


   /**
    * Loads ServletContext parameters into AppConfig.
    * Carica tutti i parametri del servlet-context
    * in AppConfig se il init-parameter
    * <code>loadcontext</code> assume il valore <code>true</code> o
    * <code>yes</code>.
    *
    * @exception ServletException on configuration error.
    */
  public void loadContextParameters() throws ServletException
  {
    ServletContext servletcontext = servletconfig.getServletContext();

    for (Enumeration enm = servletcontext.getInitParameterNames();
                    enm.hasMoreElements(); )
    {
      String key = (String) enm.nextElement();
      String val = servletcontext.getInitParameter(key);
      appconfig.put(key, val);
      logger.debug("context-param: " + key + " = " + val);
    }
  }


   /**
    * Returns DataSource from ServletConfig.
    * Si ottiene il DataSource tramite il nome della risorsa
    * specificata nel context dell'applicazione.
    *
    * @param baseEnv string identifying the Base Context.
    * @param resourceId string idenifying the Resource.
    * @return DataSource identified by the 2 args.
    * @exception ServletException on configuration error.
    */
   protected DataSource getDataSource(String basectx, String resource)
       throws ServletException
   {
      if ((basectx == null) || (resource == null))
      {
	 String err = "parametri non validi: (basectx=" + basectx
		      + "; resource=" + resource + ").";
	 log(err);
	 throw new ServletException(err);
      }

      DataSource ds = null;
      try
      {
	 Context ictx = new InitialContext();
	 Context ectx = (Context) ictx.lookup(basectx);
	 ds = (DataSource) ectx.lookup(resource);
      }
      catch (Exception ex)
      {
	 String err = "datasource " + basectx + "/" + resource + " not available: ";
	 log(err + ex);
	 throw new ServletException(err + ex);
      }
      if (ds == null)
      {
	 String err = "datasource " + basectx + "/" + resource + " not available.";
	 log(err);
	 throw new ServletException(err);
      }

      logger.info("datasource: " + basectx + "/" + resource);

      return ds;
   }



   protected DataSource findDataSource( String baseEnv,String resourceId )
                                throws ServletException
   {
      return getDataSource(servletconfig.getInitParameter(baseEnv),
			   servletconfig.getInitParameter(resourceId));
   }


   /** Returns instance of class specified by argument.
    * The argument contains the fully qualifyed classname, the
    * type of the object to be instantiated.
    *
    * @param clname full qualifyed classname.
    * @return newly instantiated object.
    * @exception WebEngineException on any error.
    */
  /*
  protected Object instantiateClass( String clname )  throws Exception // WebEngineException
  {
    // if (clname == null)
    //   throw new WebEngineException("No classname specified.");

    Class cl = null;
    try
    {
      cl = Class.forName(clname);
    }
    catch(ClassNotFoundException ex)
    {
      // throw new WebEngineException("Invalid classname: " + clname, ex );
      throw new Exception("Invalid classname: " + clname, ex );
    }

    if (cl != null)
    {
      try
      {
        Method m = cl.getMethod("getInstance",(Class)null);
        if (m != null)
        {
          if (logger.isInfoEnabled())
            logger.info("Metod clone() called for class " + cl.getName());
          return m.invoke(null,(Object)null);
        }
      }
      catch (Exception ex)
      {
        // NoSuchMethodException
        // IllegalAccessException, IllegalArgumentException, InvocationTargetException
        // throw new WebEngineException("Invalid class or interface: " + clname, ex );
        throw new Exception("Invalid class or interface: " + clname, ex );
      }
    }
    return null;
  }
  */


    ////////  setup log4j  ////////
    /**
    * Configurazione del Logger (Log4j)
    * <P>
    * Configura il PropertyConfigurator con la configurazione contenuta
    * nel file specificata nel parametro <code>log4j-properties</code>.
    * Se il nome del file indica un path assoluto viene effettuato un
    * accesso diretto al filesystem, altrimenti si considera il path
    * relativo alla directory <code>WEB-INF</code> dell'applicazione.
    * La mancata apertura del file non compromette l'applicazione.
    * <P>
    * Questa servlet esegue le seguenti operazioni:
    * <ul><li>inizializza il logger log4j</li>
    *     <li>istanzia la classe <code>AppConfig</code>
    *         e la mette nel application-context con il nome specificato
    *         in Constants.IPARAM_APPCONFIGKEY</li>
    */
  protected void setupLog4j(ServletConfig config)
  {
     String log4jconfigfile = config.getInitParameter(Constants.IPARAM_LOG4JPROPERTIES);
     if (log4jconfigfile == null)
     {
        log("Log4j-config file non e' definito (" + Constants.IPARAM_LOG4JPROPERTIES + ")");
        return;
     }

     // look up init parameter  log4j-watch (boolean)
     // enables watching of configuration file for changes.

     boolean watchflag = false;

     String watch = config.getInitParameter(Constants.IPARAM_LOG4JWATCH);
     if (watch != null)
     {
         watch = watch.toLowerCase();
         watchflag = ( watch.equals("true") || watch.equals("yes") || watch.equals("1") );
     }

     // find configuration resource //
     String propspath = null;

     if ( (log4jconfigfile.charAt(0) == '/') || (log4jconfigfile.charAt(0) == '\\')
                       || (log4jconfigfile.charAt(1) == ':') ) // dos drive spec.
     {
          // store absolute path //
          propspath = log4jconfigfile;
     }
     else  // not an absolute path //
     {
         propspath = getServletContext().getRealPath("/");
         log("RealPath = " + propspath);

         if ((propspath == null) || propspath.equals("") )
         {
           // case of war file //
           // open it as stream resource //
           watchflag = false; // non possibile, non accessibile come file //
           String pp = "WEB-INF/" + log4jconfigfile;
           log("Log4j configuration, using stream: " + pp);
           InputStream inps = getServletContext().getResourceAsStream(pp);
           if (inps == null)
           {
              log("Errore: impossibile leggere la configurazione di Log4j");
           }
           else
           {
              try
              {
                 Properties props = new Properties();
                 props.load(inps);
                 // PropertyConfigurator.configure(props);
              }
              catch (Exception ex)
              {
                log("Errore: impossibile caricare le properties per Log4j dal file \""
                    + pp + "\": " + ex.getMessage() + " : " + ex.getClass().getName());
              }
           }
         } // propspath == null //
         else // file accessible tramite file system //
         {
           propspath += "WEB-INF/" + log4jconfigfile;
         }
     }

     // propspath e' null o path assoluto (accesso a file system) //
     if (propspath != null)
     {
         log("Log4j properties file: " + propspath);
         // read log4j properties from file & eventually watch for changes //
         //if (watchflag)
         //  PropertyConfigurator.configureAndWatch(propspath);
         //else
         //  PropertyConfigurator.configure(propspath);
     }

     // once configured, we can start using the Loger now
     logger = LoggerFactory.getLogger(InitServletBase.class);
     logger.debug("Logger initialized.");
  }



}//class//

