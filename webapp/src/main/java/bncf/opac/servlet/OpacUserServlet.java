
package bncf.opac.servlet;

import bncf.opac.Constants;
import bncf.opac.beans.OpacUser;
import bncf.opac.db.OpacUserDb;
import bncf.opac.handler.SuggestHandler;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

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
   private static final long serialVersionUID = 1L;
   private static final Logger logger = LoggerFactory.getLogger(OpacUserServlet.class);
   // serlvet path trattati
   private static final String SPATH_OPTIONS = "/options";
   private static final String SPATH_INSERTSUGGEST = "/insertsuggestion";
   // session key per il captcha
   private static final String SKEY_CAPTCHA = "CAPTCHA";
   // default forward
   private final static String SHOW_OPACUSER_JSP = "/showOpacUser.jsp";
   // parametri per le opzioni
   private final static String POPT_ACCESSIBILE = "accessible";
   private final static String POPT_EXPAND = "expand";
   private final static String POPT_COLLAPSE     = "collapse";
   private final static String POPT_LANGUAGE   = "language";
   // parametri per il suggerimento
   private final static String PSUGG_BID   = "bid";
   private final static String PSUGG_EMAIL = "email";
   private final static String PSUGG_TESTO = "testo";
   private final static String PSUGG_CAPTCHA = "captcha";
   // valori di risposta Ajax
   private static final String RESP_OK = "ok";
   private static final String RESP_KO = "ko";

   private OpacUserDb userDb;

   /**
    * Inizializzazione della servlet.
    *
    * @param config
    * @throws ServletException
    */
   @Override
   public void init(ServletConfig config) throws ServletException
   {
      super.init(config);
      
      userDb = appConfig.getOpacUserDb();
      //logger.debug("System:file.encoding= {}", System.getProperty("file.encoding"));
   }

   
   @Override
   protected void processRequest(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException
   {
      String servletPath = request.getServletPath();
      logger.debug("servlet-path = {}", servletPath);
      HttpSession session = request.getSession(true);
      String content = null; // da mandare in risposta tramite PrintWriter

      if (servletPath.equals(SPATH_OPTIONS))
      {
         OpacUser opacUser = getUserInSession(session);
         if (processOptions(request, opacUser)) {
            content = RESP_OK;
         } 
         else
         {
            request.getRequestDispatcher(SHOW_OPACUSER_JSP).forward(request,response);
            return;
         }
      }
      else if (servletPath.equals(SPATH_INSERTSUGGEST))
      {
         String ip = getRemoteAddress(request);
         String ctrlCaptcha = (String) session.getAttribute(SKEY_CAPTCHA);

         content = processSuggerimento(request, ctrlCaptcha, ip);
         logger.debug("processSuggerimento returned: {}", content);
         if (RESP_OK.equals(content)) {
            session.removeAttribute(SKEY_CAPTCHA);
         }
      }
      if (content != null)
      {
         response.setContentType("text/plain; charset=utf-8");
         PrintWriter out = response.getWriter();
         out.write(content);
         out.close();
      }
   }

   
   /**
    * Imposta le varie opzioni dell'utente in sessione.
    * Le opzioni riguardno l'accessibilita, la scelta della lingua,
    * l'espansione/collassamento dei box delle faccette.
    * @param request
    * @param opacUser
    * @return
    */
   protected boolean processOptions(HttpServletRequest request, OpacUser opacUser)
   {
      String accessible = getRequestParameter(request, POPT_ACCESSIBILE);
      String expand = getRequestParameter(request, POPT_EXPAND);
      String collapse = getRequestParameter(request, POPT_COLLAPSE);
      String language = getRequestParameter(request, POPT_LANGUAGE);
      
      if ((accessible == null) && (expand == null)
          && (collapse == null) && (language == null)) {
         return false;
      }
      
      if (accessible != null) {
         opacUser.setAccessible(accessible.equals("1"));
      }
      if (language != null) {
         opacUser.setLocale(language);
      }
      if (expand != null) {
         opacUser.removeClosedBox(expand);
      }
      if (collapse != null) {
         opacUser.addClosedBox(collapse);
      }
      return true;
   }

   
   private String processSuggerimento(HttpServletRequest request, String ctrlCaptcha, String ip)
   {
      String bid = request.getParameter(PSUGG_BID);
      String email = request.getParameter(PSUGG_EMAIL);
      String testo = request.getParameter(PSUGG_TESTO);
      String captcha = request.getParameter(PSUGG_CAPTCHA);
      
      SuggestHandler handler = new SuggestHandler(userDb);
      handler.setValues(bid, email, testo, captcha, ctrlCaptcha, ip);
      String result;
      if (!handler.isValid())
      {
         result = handler.getErrorString();
      }
      else
      {
         result = handler.save() ? RESP_OK : RESP_KO;
      }
      handler.close();
      return result;
   }


   /**
    * Restituisce l'utente in sessione.
    * Se nell'attuale sessione non e' presente l'utente, questo viene creato
    * e inserito in sessione.
    * @param session
    * @return
    */
   private OpacUser getUserInSession(HttpSession session)
   {
      OpacUser user = (OpacUser) session.getAttribute(Constants.SKEY_OPACUSER);
      if (user == null)
      {
         user = new OpacUser();
         session.setAttribute(Constants.SKEY_OPACUSER, user);
      }
      return user;
   }

   /**
    * Restituisce l'indirizzo IP del richiedente.
    * Considera anche un'eventuale proxy.
    * @param request
    * @return
    */
   private String getRemoteAddress(HttpServletRequest request)
   {
      String ip = request.getHeader("x-forwarded-for");
      if (ip == null)
      {
         ip = request.getHeader("X_FORWARDED_FOR");
         if (ip == null) {
            ip = request.getRemoteAddr();
         }
      }
      return ip;
   }

} //class//
