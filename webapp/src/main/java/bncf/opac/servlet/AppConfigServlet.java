
package bncf.opac.servlet;

import bncf.opac.AppConfig;
import bncf.opac.Constants;

import java.util.Locale;

import javax.servlet.ServletConfig;
import javax.servlet.ServletException;

import static bncf.opac.servlet.InitServletBase.logger;


/**
 * AppConfigServlet.
 *
 */
    
public class AppConfigServlet   extends InitServletBase
{

   @Override
   public void init(ServletConfig config) throws ServletException
   {
      super.init(config);
      AppConfig appConfig = AppConfig.getInstance();
      initJdbcDriver(appConfig.getJdbcDriverClassname());

      
      
      
      String param = null;
      String appcfgkey = null;

      // InitParameter AppConfigKey
      // appcfgkey = servletconfig.getInitParameter(Constants.IPARAM_APPCONFIGKEY);
      appcfgkey = Constants.SKEY_APPCONFIG;
      if (appcfgkey == null)
      {
         log("InitParameter " + Constants.IPARAM_APPCONFIGKEY
             + " not found, AppConfig will not be available in Application Context.");
      }
      else
      {
         // mette l'AppConfig nel contesto dell'applicazione. //
         servletconfig.getServletContext().setAttribute(appcfgkey, appconfig);
      }

      loadConfigParameters(); // uses logger (Log4j) //

      // InitParameter  loadcontext  //
      // param = servletconfig.getInitParameter("loadcontext");
      param = servletconfig.getInitParameter(Constants.IPARAM_LOADCONTEXT);
      if (param != null)
      {
         param = param.toLowerCase();
         if (param.equals("yes") || param.equals("true") || param.equals("1"))
         {
            loadContextParameters();
         }
      }


    // Locale (default)
    param = servletconfig.getInitParameter(Constants.IPARAM_DEFAULTLOCALE);
    if (param != null)
    {
       String lang, country;
       String[] loc = param.split("_");
       if (loc.length > 0)
       {
          Locale locale = null;
          if (loc.length > 1)
            locale = new Locale(loc[0],loc[1]);
          else
            locale = new Locale(loc[0]);
          if (locale != null)
          {
            appconfig.put(Constants.CFG_LOCALE, locale);
            Locale.setDefault(locale);
          }
       }
    }


    //  DataSources
    param = servletconfig.getInitParameter(Constants.IPARAM_DATASOURCES);
    if (param != null)
    {
       String baseenv = Constants.BASEENV;
       String[] refs = param.split(",");
       for (int k = 0; k < refs.length; k++)
          appconfig.put(refs[k], getDataSource(baseenv,refs[k]));
    }


    // Message-ResourceBundle
    param = servletconfig.getInitParameter(Constants.IPARAM_MESSAGEFILE);
    if (param != null)
        appconfig.setResourceBundleName(param);
  }


    /**
     * Register JDBC Driver.
     * @param driverName
     * @throws ServletException 
     */
   private void initJdbcDriver(String driverName) throws ServletException
   {
      logger.info("Registering JDBC Driver: {}", driverName);
      try
      {
         Class.forName(driverName);
      }
      catch (ClassNotFoundException ex)
      {
         throw new ServletException("impossibile carricare il driver: " + driverName, ex);
      }
   }   

      
} //class//
