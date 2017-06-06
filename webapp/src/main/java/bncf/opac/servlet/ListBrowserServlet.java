
package bncf.opac.servlet;

import bncf.opac.db.OpacListDb;
import bncf.opac.db.OpacListResult;
import bncf.opac.handler.ListBrowserHandler;
import bncf.opac.handler.SearchHandlerException;
import bncf.opac.util.ListItem;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.io.IOException;
import java.util.ArrayList;

import javax.servlet.ServletConfig;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;




/**
 * The ListBrowserServlet recupera il record bibliografico per la visualizzazione.
 *
 */


public class ListBrowserServlet extends BaseServlet
{
   private static final long serialVersionUID = 1L;
   private static final Logger logger = LoggerFactory.getLogger(ListBrowserServlet.class);
   private static final String DEFAULT_LIST = "titolo";
   private static final String SHOW_LIST_JSP = "/listbrowser.jsp";
   private static final String SHOW_FULLTEXT_JSP = "/fulltextbrowser.jsp";

   
   @Override
   public void init(ServletConfig servletConfig) throws ServletException
   {
      super.init(servletConfig);
   }

   
   @Override
   protected void processRequest(HttpServletRequest request, HttpServletResponse response)
       throws IOException, ServletException
   {
      try
      {
         processSearch(request, response);
      }
      catch (SearchHandlerException ex)
      {
         throw new ServletException(ex);
      }
   }

   protected void processSearch(HttpServletRequest request, HttpServletResponse response)
         throws IOException, ServletException, SearchHandlerException
   {
      String param;
      String contextPath = request.getContextPath();
      String servletPath = request.getServletPath();
      String pathInfo = request.getPathInfo();

      logger.debug("context-path = " + contextPath); // "/opac2"
      logger.debug("servlet-path = " + servletPath); // "/list/*"
      logger.debug("path-info = " + pathInfo);    // "/descrittore/abu"

      // controlla corretezza servlet-path
      if ((servletPath == null) || !servletPath.equals("/list"))
      {
         logger.info("invalid request:  servlet-path=" + contextPath
                     + "  path-info=" + pathInfo);
         return;
      }

      // controlla parametri
      String fld;
      String key;
      if ((pathInfo == null) || pathInfo.equals("/")) // passaggio di parametri
      {
         fld = request.getParameter("fld");
         key = request.getParameter("key");
      }
      else // estrazione info contenuta nel path
      {
         String[] elem = pathInfo.substring(1).toLowerCase().split("/");
         fld = elem[0];
         key = elem.length > 1 ? elem[1] : request.getParameter("key");
      }
      if (fld == null) {
         fld = DEFAULT_LIST;
      }
      logger.debug("lista = " + fld);
      logger.debug("key   = " + key);
      request.setAttribute("fld", fld);
      request.setAttribute("key", key);

      int start = getRequestIntParameter(request, "start", 0);
      logger.debug("start = " + start);
      int fulltext = getRequestIntParameter(request, "ft", 0);
      // ListBrowserHandler handler = new ListBrowserHandler(new OpacListDb(opacDbProperties));
      ListBrowserHandler handler = new ListBrowserHandler(listDb);
      OpacListResult res = handler.runSearch(fld, key, fulltext, start);
      handler.close();
      ArrayList<ListItem> list = res.getList();
      if (list == null)
      {
         logger.debug("lista non diponibile: {}", key);
      }
      else
      {
         request.setAttribute("list", list);
         request.setAttribute("totale", res.getTotale());
         request.setAttribute("start", start);
      }
      String forwardTo = (fulltext > 0) ? SHOW_FULLTEXT_JSP : SHOW_LIST_JSP;
      request.getRequestDispatcher(forwardTo).forward(request, response);
   }
}
//class//

