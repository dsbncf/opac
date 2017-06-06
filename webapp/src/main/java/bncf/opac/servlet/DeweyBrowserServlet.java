

package bncf.opac.servlet;


import bncf.opac.handler.DeweyBrowserHandler;
import bncf.opac.handler.SearchHandlerException;
import bncf.opac.util.DeweyItem;

import java.io.IOException;
import java.util.ArrayList;

import javax.servlet.ServletConfig;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;




/**
 * DeweyBrowserServlet, navigazione Dewey
 *
 */


public class DeweyBrowserServlet extends BaseServlet
{
   private static final Logger logger = LoggerFactory.getLogger(DeweyBrowserServlet.class);
   private static final long serialVersionUID = 1L;

   
   private static final String OPACDB_PROPS      = "/opacdb.properties";

   private static final String SERVLET_PATH     = "/deweybrowser";
   private static final String DEWEYBROWSER_JSP = "/deweybrowser.jsp";


   @Override
   public void init(ServletConfig servletConfig) throws ServletException
   {
      super.init(servletConfig);
   }


   @Override
   protected void processRequest(HttpServletRequest request,
                                 HttpServletResponse response)
         throws IOException, ServletException
   {
      try
      {
         processDeweyBrowser(request, response);
      }
      //catch (DeweyBrowserHandlerException ex)
      catch (Exception ex)
      {
         throw new ServletException(ex);
      }
   }


   protected void processDeweyBrowser(HttpServletRequest request, HttpServletResponse response)
                       throws IOException, ServletException, SearchHandlerException
   {
        String param;
        String contextPath = request.getContextPath();
        String servletPath = request.getServletPath();
        String pathInfo    = request.getPathInfo();

        // logger.debug("context-path = " + contextPath); // "/opac2"
        // logger.debug("servlet-path = " + servletPath); // "/deweynav/*"
        logger.debug("path-info = "    + pathInfo);    // "/descrittore/abu"

        // controlla correttezza servlet-path
        if ( (servletPath == null) || !servletPath.equals(SERVLET_PATH) )
        {
           logger.info("invalid request:  servlet-path=" + contextPath
                        + "  path-info=" + pathInfo);
           return;
        }

        // controlla parametri
        String cod = null;

        if ((pathInfo == null) || pathInfo.equals("/")) // passaggio di parametri
        {
              cod = request.getParameter("cod");
        }
        else // estrazione info contenuta nel path
        {
              String[] elem = pathInfo.substring(1).toLowerCase().split("/");
              cod = elem.length > 0 ? elem[0] : request.getParameter("cod");
        }
        logger.debug("cod   = " + cod);
        request.setAttribute("cod",cod);

        if ((cod != null) && (cod.length() == 3))
        {
           // DeweyBrowserHandler handler = new DeweyBrowserHandler(dataSource);
           DeweyBrowserHandler handler = new DeweyBrowserHandler(listDb);
           int start    = getRequestIntParameter(request, "start", 0);
           int fulltext = getRequestIntParameter(request, "ft", 0);
           
           ArrayList<DeweyItem> list = handler.listSearch(cod,start);
           if (list != null)
           {
              request.setAttribute("deweyItems", list);
              request.setAttribute("totale", new Integer(handler.getTotale()));
              logger.debug("list rows: " + list.size());
              // request.setAttribute("start", new Integer(start));
           }
           else
              logger.debug("lista non diponibile: " + cod);
        }
        // String forwardTo = (fulltext > 0) ? SHOW_FULLTEXT_JSP : SHOW_LIST_JSP;
        String forwardTo =  DEWEYBROWSER_JSP;
        request.getRequestDispatcher(forwardTo).forward(request, response);
    }

   
} //class//

