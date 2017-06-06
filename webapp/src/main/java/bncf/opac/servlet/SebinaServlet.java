
package bncf.opac.servlet;

import bncf.opac.handler.SebinaHandler;

import java.io.IOException;
import java.io.PrintWriter;

import javax.servlet.ServletConfig;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;


import org.slf4j.Logger;
import org.slf4j.LoggerFactory;




/**
 * The SebinaServlet recupera le informazioni sull'abbonamento.
 *
 *  HOST = "sebina.bncf.lan";
 *  PORT = 80;
 *  URI  = "/sebina/fascicoli/F_BNCF_OPAC.do";
 */


public class SebinaServlet extends BaseServlet
{
   private static final long serialVersionUID = -3758746008980964422L;
   private static final Logger logger = LoggerFactory.getLogger(SebinaServlet.class);
   // servlet path's
   private static final String PATH_ABBONAMENTO = "/abbonamento";
   private static final String PATH_ANNATA = "/annata";
   // JSP to forward to
   private static final String JSP_ABBONAMENTO = "/sol/abbonamento.jsp";
   private static final String JSP_ANNATA = "/sol/annata.jsp";
   private static final String REQ_ATTR_DOCXML = "docxml";
   // init parameters
   private static final String IPAR_HOST = "sebina-host";
   private static final String IPAR_PORT = "sebina-port";
   private static final String IPAR_URI = "sebina-uri";
   private static final String IPAR_TIMEOUT = "sebina-timeout";
   // default connection timeout for http-client
   private static final int DEF_TIMEOUT = -1; // -1 := not defined
   private String sebinaHost = null;
   private String sebinaPort = null;
   private String sebinaURI = null;
   private int connectionTimeout = DEF_TIMEOUT;


   /**
    * Servlet initialization.
    *
    * @param servletConfig
    * @throws ServletException
    */
   @Override
   public void init(ServletConfig servletConfig) throws ServletException
   {
      super.init(servletConfig);
      sebinaHost = servletConfig.getInitParameter(IPAR_HOST);
      sebinaPort = servletConfig.getInitParameter(IPAR_PORT);
      sebinaURI  = servletConfig.getInitParameter(IPAR_URI);
      connectionTimeout = getInitParameter(IPAR_TIMEOUT, DEF_TIMEOUT);
      logger.info(IPAR_HOST + " = " + sebinaHost);
      logger.info(IPAR_PORT + " = " + sebinaPort);
      logger.info(IPAR_URI  + " = " + sebinaURI);
      if (connectionTimeout > -1)
         logger.info(IPAR_TIMEOUT + " = " + connectionTimeout);
   }


   /**
    * Processes the request.
    *
    * servlet-path: /abbonamento
    * path-info: /CF/L008432897
    *
    * servlet-path: /annata
    * path-info: /68566
    *
    * @param request
    * @param response
    * @throws ServletException
    */
   @Override
   protected void processRequest(HttpServletRequest request, HttpServletResponse response)
                          throws ServletException
   {
      String contextPath = request.getContextPath();
      String servletPath = request.getServletPath();
      String pathInfo = request.getPathInfo();

      logger.debug("context-path = " + contextPath); // "/opac2"
      logger.debug("servlet-path = " + servletPath); // "/bid"
      logger.debug("path-info    = " + pathInfo);    // "/cfi0747013"

      if ((pathInfo == null) || (pathInfo.length() < 4))
      {
         logger.info("invalid request: path-info = " + pathInfo);
         return;
      }

      String text = null;
      String jsp = null;
      if (servletPath.equals(PATH_ABBONAMENTO))
      {
         text = getAbbonamento(pathInfo);
         jsp = JSP_ABBONAMENTO;
      }
      else
      if (servletPath.equals(PATH_ANNATA))
      {
         text = getAnnata(pathInfo);
         jsp = JSP_ANNATA;
      }
      else
      {
         logger.info("invalid request: servlet-path = " + servletPath);
         return;
      }

      // output XML
      String fmt = getRequestParameter(request, "fmt");
      if ((fmt != null) && fmt.equals("xml"))
      {
         outputXml(response,text);
         return;
      }

      // forward to JSP
      request.setAttribute(REQ_ATTR_DOCXML, text);
      try
      {
        request.getRequestDispatcher(jsp).forward(request, response);
      }
      catch (IOException ex)
      {
         logger.error(ex.getMessage(),ex);
      }
   }


   private void outputXml(HttpServletResponse response, String text)
   {
      PrintWriter out = null;
      try
      {
         response.setContentType("text/xml; charset=utf-8");
         out = response.getWriter();
         out.print(text);
      }
      catch (IOException ex)
      {
        logger.error(null, ex);
      }
      finally
      {
         if (out != null)
            out.close();
      }
   }


   private String getAbbonamento(String pathInfo)
   {
      String[] infoArr = pathInfo.split("/");
      if (infoArr.length < 3)
      {
         logger.info("invalid request: path-info = " + pathInfo);
         return null;
      }
      String bibcod = infoArr[1];
      String idabbo = infoArr[2];
      logger.debug("biblioteca: " + bibcod + "  abbonamento: " + idabbo);
      SebinaHandler handler = new SebinaHandler(sebinaHost,sebinaPort,sebinaURI);
      if (connectionTimeout > -1)
         handler.setTimeout(connectionTimeout);
      return handler.getAbbonamento(bibcod,idabbo);
   }


   private String getAnnata(String pathInfo)
   {
      String[] infoArr = pathInfo.split("/");
      if (infoArr.length < 2)
      {
         logger.info("invalid request: path-info = " + pathInfo);
         return null;
      }
      String idannata = infoArr[1];
      logger.debug("id annata: " + idannata);
      SebinaHandler handler = new SebinaHandler(sebinaHost,sebinaPort,sebinaURI);
      if (connectionTimeout > -1)
         handler.setTimeout(connectionTimeout);
      return handler.getAnnata(idannata);
   }


} //class//

