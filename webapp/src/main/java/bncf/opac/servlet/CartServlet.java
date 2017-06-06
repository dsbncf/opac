
package bncf.opac.servlet;

import bncf.opac.Constants;

import bncf.opac.beans.OpacUser;
import bncf.opac.beans.Record;

import bncf.opac.util.Translator;

import java.io.IOException;
import java.io.PrintWriter;

import java.util.HashMap;
import java.util.Locale;

import javax.servlet.ServletConfig;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;



/**
 * The CartServlet is responsible for taking in commands,
 * run queries and prepare data for output through JSP for books cart requests.
 *
 */
public class CartServlet extends BaseServlet
{
   private static Logger logger = LoggerFactory.getLogger(CartServlet.class);


   /**
    * @param servletConfig
    * @throws ServletException
    */
   @Override
   public void init(ServletConfig servletConfig) throws ServletException
   {
      //
   }


   /**
    * Process the incoming requests, based on the "servlet-path"
    *
    * @param request
    * @param response
    * @throws ServletException
    * @throws IOException
    */
   @Override
   protected void processRequest(HttpServletRequest request,
				 HttpServletResponse response)
       throws ServletException
   {
      String contextPath = request.getContextPath();
      String servletPath = request.getServletPath();

      logger.debug("context-path = " + contextPath); // "/opac2"
      logger.debug("servlet-path = " + servletPath); // "/addbidtocart"

      if (servletPath.equals("/addbidtocart"))
	 addBidToCart(request, response);

      if (servletPath.equals("/removebidfromcart"))
	 removeBidFromCart(request, response);

      if (servletPath.equals("/exportcart"))
	 exportCart(request, response);
   }


   /**
    * Save a bid in cart
    *
    * @param request
    * @param response
    */
   private void addBidToCart(HttpServletRequest request,
                             HttpServletResponse response)
   {
      String bid = getRequestParameter(request, "bid", null);
      String titolo = getRequestParameter(request, "titolo", null);
      String autore = getRequestParameter(request, "autore", null);
      String anno = getRequestParameter(request, "anno", null);
      PrintWriter out = null;

      try
      {
         out = response.getWriter();
      }
      catch(IOException ex)
      {
         logger.debug("Error addBidToCart: " + ex);
         out.print("error");
         return;
      }

      response.setContentType("text/plain; charset=utf-8");

      if (bid == null)
      {
         out.print("error");
         return;
      }

      OpacUser opacUser = null;
      HttpSession session = request.getSession(true);
      if (!session.isNew())
         opacUser = (OpacUser) session.getAttribute(Constants.SKEY_OPACUSER);

      if (opacUser == null)
      {
         opacUser = new OpacUser();
         session.setAttribute(Constants.SKEY_OPACUSER, opacUser);
      }

      opacUser.addBidToCart(bid, titolo, autore, anno);

      if (opacUser.hasBidInCart(bid))
         out.print(bid);
      else
         out.print("error");
   }


   /**
    * Remove a bid from cart
    *
    * @param request
    * @param response
    */
   private void removeBidFromCart(HttpServletRequest request,
                                  HttpServletResponse response)
   {
      String bid = getRequestParameter(request, "bid", null);
      PrintWriter out = null;

      try
      {
         out = response.getWriter();
      }
      catch(IOException ex)
      {
         logger.debug("Error addBidToCart: " + ex);
         out.println("error");
         return;
      }

      response.setContentType("text/plain; charset=utf-8");

      if (bid == null)
      {
         out.println("error");
         return;
      }

      OpacUser opacUser = null;
      HttpSession session = request.getSession(true);
      if (!session.isNew())
         opacUser = (OpacUser) session.getAttribute(Constants.SKEY_OPACUSER);

      if (opacUser == null)
         opacUser = new OpacUser();

      opacUser.removeBidFromCart(bid);

      out.print(bid);
   }


   /**
    * Export cart in format xml or txt
    *
    * @TODO La funzione e' funzionante ma mancano le specifiche su come trattare i dati e come
    * mostrarli in output. E' probabile che dovra' essere effettuata una chiamata a Solr per
    * mostrare dei dati piu' completi.
    *
    * @param request
    * @param response
    */
   private void exportCart(HttpServletRequest request,
                           HttpServletResponse response)
   {
      String fmt = getRequestParameter(request, "fmt", null);
      PrintWriter out = null;

      try
      {
         out = response.getWriter();
      }
      catch(IOException ex)
      {
         logger.debug("Error exportCart: " + ex);
         response.setContentType("text/plain; charset=utf-8");
         out.println("error");
         return;
      }

      if (fmt == null || (!fmt.equals("xml") && !fmt.equals("txt")))
      {
         logger.debug("Error exportCart: format requested invalid");
         response.setContentType("text/plain; charset=utf-8");
         out.println("error");
         return;
      }

      OpacUser opacUser = null;
      HttpSession session = request.getSession(true);
      if (!session.isNew())
         opacUser = (OpacUser) session.getAttribute(Constants.SKEY_OPACUSER);

      if (opacUser == null)
      {
         opacUser = new OpacUser();
         session.setAttribute(Constants.SKEY_OPACUSER, opacUser);
      }

      HashMap<String, Record> cart = opacUser.getCart();

      if (cart == null || cart.isEmpty())
      {
         logger.debug("Error exportCart: cart is empty");
         response.setContentType("text/plain; charset=utf-8");
         out.println("error");
         return;
      }

      Record record = null;
      
      Locale locale   = opacUser.getLocale();
      Translator lang = new Translator(locale);

      response.setContentType("application/octet-stream; charset=utf-8");
      response.setHeader("Content-Disposition",
                         "attachment; filename=\"" + lang.translate("carrello") + "." + fmt + "\"");

      if (fmt.equals("txt"))
      {
         for (String key : cart.keySet())
         {
            record = cart.get(key);
            out.println(String.format("%-15s", lang.translate("Bid")).replace(' ', '.') + ": " + record.getBid());
            out.println(String.format("%-15s", lang.translate("Titolo")).replace(' ', '.') + ": " + record.getTitle());
            out.println(String.format("%-15s", lang.translate("Autore")).replace(' ', '.') + ": " + record.getAuthor());
            out.println(String.format("%-15s", lang.translate("Anno")).replace(' ', '.') + ": " + record.getYear());
            out.println("");
         }
      }

      if (fmt.equals("xml"))
      {
         out.println("<?xml version=\"1.0\" encoding=\"UTF-8\" ?>");
         out.println(" <" + lang.translate("tag_carrello") + ">");
         out.println("");
         for (String key : cart.keySet())
         {
            record = cart.get(key);
            out.println(" <rec>");
            out.println("   <bid>" + record.getBid() + "</bid>");
            out.println(
               "   <" + lang.translate("tag_titolo") + "><![CDATA[" + record.getTitle() + "]]></" + lang.translate("tag_titolo") + ">");
            out.println(
               "   <" + lang.translate("tag_autore") + "><![CDATA[" + record.getAuthor() + "]]></" + lang.translate("tag_autore") + ">");
            out.println("   <" + lang.translate("tag_anno") + "><![CDATA[" + record.getYear() + "]]></" + lang.translate("tag_anno") + ">");
            out.println(" </rec>");
            out.println("");
         }
         out.println(" </" + lang.translate("tag_carrello") + ">");
      }
   }

}//class//

