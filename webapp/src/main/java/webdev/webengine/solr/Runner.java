
package webdev.webengine.solr;


import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.InputStream;
import java.util.Properties;



/**
 * Classe base per le implementazioni che lanciano le procedure).
 *
 *
 * @author  $Author: ds $
 * @version $Revision: $
 *
 */


public abstract class Runner
{
   private static final Logger logger = LoggerFactory.getLogger(Runner.class);


   // command line parameters
   protected String[] programArgs    = null;
   protected String   propertiesfile = null;

   // options
   protected boolean    debug       = false;
   protected boolean    verbose     = false;
   protected Properties properties  = null;
   protected Properties requestProperties  = new Properties();

  protected abstract void usage();
  protected abstract void parseArgs(String[] args);
  protected abstract void run() throws Exception;



 // ==============  protected  ==================================== //

 /**
  * Load properties from file and from request, initialize Log4J from properties.
  * @throws Exception
  */

 protected void init(String[] args) throws Exception
 {
     this.programArgs = args;
     parseArgs(programArgs);
     loadProperties();
     properties.putAll(requestProperties);
     debug = properties.containsKey("debug");
     // configure log4j
     //PropertyConfigurator.configure(properties);
 }



 /**
  * Read properties from file or classpath.
  */
 protected void loadProperties() throws Exception
 {
    if (propertiesfile == null)
       throw new Exception("Properties file non specificato.");

    properties = new Properties();
    FileInputStream inp = null;

    try
    {   // lettura da file in current directory
        inp = new FileInputStream(propertiesfile);
        if (verbose)
           System.err.println("using properties file '" + propertiesfile + "'");
    }
    catch (java.io.FileNotFoundException ex)
    {
        if (verbose)
           System.err.println("lettura del file '" + propertiesfile + "' da classpath");
       // load as resource from classpath
       InputStream inps = ClassLoader.getSystemClassLoader().getResourceAsStream(propertiesfile);
       if (inps == null)
          throw new FileNotFoundException("properties file not found in classpath: '" + propertiesfile + "'");
       properties.load(inps);
       inps.close();
    }
    if (inp != null)
    {
       try
       {
          this.properties.load(inp);
          inp.close();
       }
       catch (java.io.IOException ex)
       {
          throw new Exception( "Error durante la lettura del file " + propertiesfile, ex );
       }
    }
 }

}//class//
