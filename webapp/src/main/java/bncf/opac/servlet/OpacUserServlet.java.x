
package bncf.opac.servlet;

import bncf.opac.Constants;
import bncf.opac.beans.OpacUser;
import bncf.opac.handler.SuggestHandler;

import java.io.IOException;
import java.io.PrintWriter;

import javax.servlet.ServletConfig;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;


/**
 * Questa servlet imposta le opzioni dell'utente nella session.
 */


public class OpacUserServlet extends BaseServlet
{
   private final static String SHOW_OPACUSER_JSP = "/showOpacUser.jsp";


   /**
    * Process the incoming requests.
    *
    * @param request
    * @param response
    * @throws ServletException
    * @throws IOException
    */
   @Override
   public void init(ServletConfig config) throws ServletException
   {
      super.init(config);
      super.initDataSource(); //l'init del datasource serve solo per salvataggio segnalazione
   }


   protected void processRequest(HttpServletRequest request, HttpServletResponse response)
       throws ServletException, IOException
   {
      String servletPath = request.getServletPath();
      logger.debug("servlet-path = " + servletPath);

      if (servletPath.equals("/options"))
      {
	 String accessible = getRequestParameter(request, "accessible");
	 String expand = getRequestParameter(request, "expand");
	 String collapse = getRequestParameter(request, "collapse");
	 String language = getRequestParameter(request, "language");

	 if (accessible != null || expand != null || collapse != null || language != null)
	 {
	    OpacUser opacUser = null;
	    HttpSession session = request.getSession(true);
	    if (!session.isNew())
	    {
	       opacUser = (OpacUser) session.getAttribute(
		   Constants.SKEY_OPACUSER);
	    }

	    if (opacUser == null)
	       opacUser = new OpacUser();

	    if (accessible != null)
	    {
	       opacUser.setAccessible(accessible.equals("1"));
	       session.setAttribute(Constants.SKEY_OPACUSER, opacUser);
	    }
	    else
	    {
	       if (language != null)
	       {
		  opacUser.setLocale(language);
		  session.setAttribute(Constants.SKEY_OPACUSER, opacUser);
	       }
	       else
	       {
		  if (expand != null)
		     opacUser.removeClosedBox(expand);

		  if (collapse != null)
		     opacUser.addClosedBox(collapse);

		  response.setContentType("text/html; charset=utf-8");
		  PrintWriter out = response.getWriter();
		  out.print("ok");
		  out.close();
		  session.setAttribute(Constants.SKEY_OPACUSER, opacUser);

		  return;
	       }
	    }
	 }

	 request.getRequestDispatcher(SHOW_OPACUSER_JSP).forward(request,
								 response);
      }


      if (servletPath.equals("/insertsuggestion"))
      {
	 String bid = (String) request.getParameter("bid");
	 String email = (String) request.getParameter("email");
	 String testo = (String) request.getParameter("testo");
	 String captcha = (String) request.getParameter("captcha");

	 String ip = request.getHeader("x-forwarded-for");
	 if (ip == null)
	 {
	    ip = request.getHeader("X_FORWARDED_FOR");
	    if (ip == null)
	       ip = request.getRemoteAddr();
	 }

	 HttpSession session = request.getSession(true);
	 String sessCaptcha = (String) session.getAttribute("CAPTCHA");

	 SuggestHandler handler = new SuggestHandler(dataSource);
	 handler.setValues(bid, email, testo, captcha, sessCaptcha, ip);

	 PrintWriter out = null;
	 response.setContentType("text/plain; charset=utf-8");

	 try
	 {
	    out = response.getWriter();
	 }
	 catch (IOException ex)
	 {
	    logger.debug("Error insertsuggestion: " + ex);
	    out.print("ko");
	    return;
	 }

	 boolean check = handler.check();
	 if (!check)
	 {
	    logger.debug(
		"insertsuggestion: wrong data, ajaxResponse: " + handler.getAjaxResponse());
	    out.write(handler.getAjaxResponse());
	 }
	 else
	 {
	    boolean saved = handler.save();
	    if (!saved)
	    {
	       logger.debug("insertsuggestion: db error");
	       out.write("ko");
	    }
	    else
	    {
	       session.setAttribute("CAPTCHA", null);
	       out.write("ok");
	    }
	 }
	 return;
      }
   }

} //class//
