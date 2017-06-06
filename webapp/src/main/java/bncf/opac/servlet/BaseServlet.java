
package bncf.opac.servlet;

import bncf.opac.AppConfig;
import bncf.opac.Constants;
import bncf.opac.beans.OpacUser;
import bncf.opac.db.OpacDb;
import bncf.opac.db.OpacListDb;
import bncf.opac.db.OpacUserDb;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Enumeration;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import javax.servlet.ServletConfig;
import javax.servlet.ServletContext;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;


public abstract class BaseServlet extends HttpServlet
{
   private static final Logger logger = LoggerFactory.getLogger(BaseServlet.class);
   private static final Pattern querystringPattern = Pattern.compile("&?([^=]+)=[^&]*");
   //private static final String OPACDB_PROPS      = "/webapp.properties";
   
   protected SimpleDateFormat dateformatter = new SimpleDateFormat("dd-MM-yy HH:mm:ss.S");

   protected String         realpath = null;
   protected ServletContext servletContext  = null;
   protected ServletConfig  servletConfig   = null;
   protected AppConfig appConfig;

   protected OpacListDb listDb;
   protected OpacUserDb userDb;

   
   //Properties opacDbProperties = null;
   // protected DataSource   dataSource = null;
   // protected AppConfig     appconfig = null;
   // protected String   datasourcename = null;

   
   protected abstract void processRequest(HttpServletRequest request, HttpServletResponse response)
                                   throws ServletException, IOException;


   public BaseServlet()
   {
   }


   @Override
   public void init(ServletConfig config) throws ServletException
   {
      super.init(config);
      servletConfig = config;
      servletContext = servletConfig.getServletContext();
      realpath = servletContext.getRealPath("/");
      logger.debug("RealPath = " + realpath);

      appConfig = AppConfig.getInstance();
      listDb = appConfig.getOpacListDb();
      userDb = appConfig.getOpacUserDb();

      //opacDbProperties = loadProperties();
      //logger.info("Properties loaded from file {}", OPACDB_PROPS);

      /*
      String cfgkey = it.webdev.webengine.core.Constants.APPCONFIG_KEY;
      logger.debug("APPCONFIG_KEY = " + cfgkey);
      appconfig = (AppConfig) servletContext.getAttribute(cfgkey);
      if (appconfig == null)
      {
         logger.debug("NO AppConfig");
         return;
      }
      */
   }

   /*
   protected Properties loadProperties() throws ServletException
   {
      Properties props = new Properties();
      try
      {
         InputStream inp = this.getClass().getResourceAsStream(OPACDB_PROPS);
         props.load(inp);
         inp.close();
      }
      catch (IOException ex)
      {
         throw new ServletException("Could not load properties from " + OPACDB_PROPS, ex);
      }
      return props;
   }
   * */
   

   
  /**
   * Get the Solr location from the web.xml.
   *
   * @throws ServletException
   */
  protected void initDataSource() throws ServletException
  {
      //String dataSourceName = servletConfig.getInitParameter(Constants.IPARAM_DATASOURCE);
      //logger.info("DataSource name: {}", dataSourceName);
      //dataSource = (DataSource) AppConfig.getInstance().get(dataSourceName);
  }




 // - initDataSource --
/*
 public void initDataSource()  throws ServletException
 {
    if (dataSource == null)
    {
      try
      {
        datasourcename = getInitParameter(Constants.INITPARAM_DATASOURCE);
        if (datasourcename == null)
        {
           logger.error("DataSourceName non definito");
           throw new ServletException("DataSourceName non definito");
        }
        Context env = (Context) new InitialContext().lookup("java:comp/env");
        dataSource = (DataSource) env.lookup(datasourcename);

        if (dataSource == null)
        {
           logger.error( "DataSourceName non diponibilie: " + datasourcename );
           throw new ServletException("DataSource non disponibile: " + datasourcename);
        }
      }
      catch (NamingException ex)
      {
         logger.error( ex.getMessage() );
         throw new ServletException(ex);
      }
    }
 }
*/

   /**
    * Call {@link #doGet(javax.servlet.http.HttpServletRequest, javax.servlet.http.HttpServletResponse)}
    */
   @Override
   protected void doPost(HttpServletRequest httpServletRequest,
			 HttpServletResponse httpServletResponse)
       throws ServletException, IOException
   {
      doGet(httpServletRequest, httpServletResponse);
   }


  /**
   * Process the incoming requests, based on the "type" passed in as a hidden field on most pages.
   *
   * @param request
   * @param response
   * @throws ServletException
   * @throws IOException
   */
   @Override
  protected void doGet(HttpServletRequest request, HttpServletResponse response)
                          throws ServletException, IOException
  {
     String lang = request.getParameter("lang");
     if (lang != null)
        getOpacUser(request).setLocale(lang);
     processRequest(request, response);
  }




   protected void redirect(HttpServletResponse resp, String url) throws IOException
   {
      String enc = resp.encodeRedirectURL(url);
      resp.sendRedirect(enc);
   }



    /**
     * Restituisce OpacUser in sessione.
     *
     * nel caso di una sessione nuova viene creato una nuova istanza
     * e inserita nella sessione.
     *
     * @param request servlet request
     * @return OpacUser utente in sessione
     */
    protected OpacUser getOpacUser(HttpServletRequest request)
    {
        HttpSession session = request.getSession(true);
        OpacUser opacUser = null;

        if (!session.isNew())
           opacUser = (OpacUser) session.getAttribute(Constants.SKEY_OPACUSER);

        if (opacUser == null)
        {
           opacUser = new OpacUser();
           session.setAttribute(Constants.SKEY_OPACUSER, opacUser);
        }
        return opacUser;
    }





  ///////////////////////////////// utilita ////////////////////////////////////


  /**
   * Restituisce String array dei nomi dei request parameters.
   *
   * @param request servlet request
   * @return String array
   */
  protected String[] extractParameterNames(HttpServletRequest request)
  {
     ArrayList<String> pnames = new ArrayList<String>();
     String qs = request.getQueryString();
     if (qs != null)
     {
        Matcher m = querystringPattern.matcher(request.getQueryString());
        while (m.find())
        {
           if (pnames == null)
              pnames = new ArrayList<String>();
           pnames.add(m.group(1));
        }
     }
     return pnames.toArray(new String[0]);
  }


  protected boolean isAbsolutePath(String path)
  {
    if (path == null)
       return false;

    return ( (path.charAt(0) == '/') || (path.charAt(0) == '\\')
            || (path.charAt(1) == ':') ); // dos drive spec.
  }


  protected void logAttributes(Enumeration enumeration)
  {
     if (enumeration == null)
       return;

     while (enumeration.hasMoreElements())
     {
         logger.debug( "Context-Attribute: " + enumeration.nextElement() );
     }
  }

  // ----------------------------- init parameters -------------------------------

   protected String getInitParameterAsString(String paramname)  throws ServletException
   {
      return getInitParameterAsString(paramname, null);
   }


   protected String getInitParameterAsString(String paramname,
					     String defaultvalue)
       throws ServletException
   {
      String initparam = getInitParameter(paramname);
      if (initparam == null)
	 initparam = defaultvalue;
      if (initparam == null)
	 throw new ServletException("parameter '" + paramname + "' not defined");
      return initparam;
   }


   protected int getInitParameter(String paramname, int defaultvalue)
                           throws ServletException
   {
      int value = defaultvalue;
      String initparam = getInitParameter(paramname);
      if (initparam == null)
         return value;

      try
      {
         value = Integer.parseInt(initparam);
      }
      catch (NumberFormatException ex)
      {
         throw new ServletException(
               "parameter '" + paramname + "' not valid: " + initparam);
      }
      return value;
   }


   protected int getInitParameterAsInt(String paramname) throws ServletException
   {
      String initparam = getInitParameter(paramname);
      if (initparam == null)
         throw new ServletException("parameter '" + paramname + "' not defined");

      int value = 0;
      try
      {
         value = Integer.parseInt(initparam);
      }
      catch (NumberFormatException ex)
      {
         throw new ServletException(
               "parameter '" + paramname + "' not valid: " + initparam);
      }
      return value;
   }


  // ----------------------------- request parameters -------------------------------

   // return only one single value if present.

   protected String getRequestParameter(HttpServletRequest request, String param, String defaultvalue)
   {
      String value = request.getParameter(param);
      if (value == null)
          return defaultvalue;
      value = value.trim();
      return (value.equals("")) ? defaultvalue : value;
   }

   // return only one single value if present.
   protected String getRequestParameter(HttpServletRequest request, String param)
   {
      return getRequestParameter(request, param, null);
   }


   // return all values if present.
   protected String[] getRequestParameters(HttpServletRequest request, String param)
   {
      return request.getParameterValues(param);
   }


   // boolean
   protected boolean getRequestParameter(HttpServletRequest request, String param, boolean def)
   {
      String val = request.getParameter(param);
      return (val == null) ? def : (val.equals("true") || val.equals("yes") || val.equals("1"));
   }



   // return only one single value if present.
   protected int getRequestIntParameter(HttpServletRequest request, String param, int defaultvalue)
   {
      String value = request.getParameter(param);
      if (value == null)
          return defaultvalue;
      try
      {
        return Integer.parseInt(value);
      }
      catch(NumberFormatException ex)
      {
          return  defaultvalue;
      }
   }

   // return only one single value if present.
   protected float getRequestFloatParameter(HttpServletRequest request,
					    String param, float defaultvalue)
   {
      String value = request.getParameter(param);
      if (value == null)
	 return defaultvalue;

      try
      {
	 return Float.parseFloat(value);
      }
      catch (NumberFormatException ex)
      {
	 return defaultvalue;
      }
   }



} //class//




