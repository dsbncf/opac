
package bncf.opac.servlet;

import bncf.opac.beans.OpacUser;

import java.io.IOException;

import javax.servlet.ServletConfig;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;



/**
 * The ControllerServlet is responsible for taking in commands,
 * run queries to Solr and prepare data for output through JSP.
 *
 */


public class ControllerServlet extends BaseServlet
{
    private final static String INDEX_JSP  = "/index.jsp";

   /**
    * Initializes the controller servlet.
    *
    * @param servletConfig
    * @throws ServletException
    */
   @Override
    public void init(ServletConfig servletConfig) throws ServletException
    {
       super.init(servletConfig);
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
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
                           throws ServletException, IOException
    {
        String param;
        String contextPath = request.getContextPath();
        String servletPath = request.getServletPath();
        String pathInfo    = request.getPathInfo();
        String lang = request.getParameter("lang");

        // logger.debug("context-path = " + contextPath); // "/opac2"
        // logger.debug("servlet-path = " + servletPath); // "/setLang || /??? ..."
        // logger.debug("path info    = " + pathInfo);   // "/en "
        // logger.debug("lang        = " + lang);

        if ((lang != null) && (lang.equals("it") || lang.equals("en")))
        {
           OpacUser opacUser = getOpacUser(request);
           opacUser.setLocale(lang);
        }
        request.getRequestDispatcher(INDEX_JSP).forward(request, response);
    }


} //class//

