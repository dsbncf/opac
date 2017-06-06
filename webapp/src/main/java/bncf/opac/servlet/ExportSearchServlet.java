
package bncf.opac.servlet;

import bncf.opac.Constants;

import bncf.opac.handler.SearchHandler;
import bncf.opac.handler.SearchHandlerException;
import bncf.opac.util.ParameterMap;

import bncf.opac.beans.OpacUser;

import webdev.webengine.solr.SolrResult;
import webdev.webengine.solr.SolrResultDocument;

import javax.servlet.ServletConfig;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;

import javax.xml.transform.Transformer;
import javax.xml.transform.TransformerFactory;
import javax.xml.transform.dom.DOMSource;
import javax.xml.transform.stream.StreamResult;

import org.xml.sax.InputSource;

import org.w3c.dom.Document;

import java.io.IOException;
import java.io.PrintWriter;
import java.io.StringReader;

import java.util.Locale;

import javax.xml.transform.stream.StreamSource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;


/**
 * The ExportSearchServlet is responsible for taking in commands,
 * run queries to Solr and prepare data for output through a text file.
 *
 */
public class ExportSearchServlet extends BaseServlet
{
   private final static Logger logger = LoggerFactory.getLogger(ExportSearchServlet.class);
   private final static String SHOW_ERROR_JSP = "/error.jsp";

   private String solrLocation;
   private String exportXslIt;
   private String exportXslEn;
   private int maxResult = 0;
   private DocumentBuilderFactory factory = null;
   private Transformer transformerIt = null;
   private Transformer transformerEn = null;

   /**
    * Inizializza i parametri (solrLocation, maxResult, exportXsl) dal web.xml.
    * Inoltre inizializza i due oggetti necessari per la visualizzazione del file
    * di export: il Transformer e il DocumentBuilderFactory.
    *
    * @param servletConfig
    * @throws ServletException
    */
   @Override
   public void init(ServletConfig servletConfig) throws ServletException
   {
      super.init(servletConfig);
      solrLocation = servletConfig.getInitParameter("solr-location");
      maxResult    = Integer.parseInt(servletConfig.getInitParameter("maxResult"));
      exportXslIt  = servletConfig.getInitParameter("exportXslIt");
      exportXslEn  = servletConfig.getInitParameter("exportXslEn");
      factory      = DocumentBuilderFactory.newInstance();

      TransformerFactory tf = TransformerFactory.newInstance();
      String xslpathIt      = servletContext.getRealPath("/") + exportXslIt;
      String xslpathEn      = servletContext.getRealPath("/") + exportXslEn;
      
      try
      {
         transformerIt = tf.newTransformer(new StreamSource(xslpathIt));
         transformerEn = tf.newTransformer(new StreamSource(xslpathEn));
      }
      catch (Exception ex) { throw new ServletException(ex); }
   }


   /**
    * Processa le richieste.
    *
    * @param request
    * @param response
    * @throws ServletException
    * @throws IOException
    */
   protected void processRequest(HttpServletRequest request,
                                 HttpServletResponse response)
      throws ServletException, IOException
   {
      String contextPath = request.getContextPath();
      String servletPath = request.getServletPath();
      String pathInfo    = request.getPathInfo();

      logger.debug("context-path = " + contextPath); // "/opac2"
      logger.debug("servlet-path = " + servletPath); // "/fcsearch"
      logger.debug("path-info = " + pathInfo);    // "/140" // offset

      try
      {
         processExport(request, response);
      }
      catch(SearchHandlerException ex)
      {
         throw new ServletException(ex);
      }
      catch(Exception ex)
      {
         throw new ServletException(ex);
      }
   }


   /**
    * Effettua una ricerca su Solr e restituisce in output un file scaricabile con
    * il browser (contentType di tipo application/octet-stream). Il file viene
    * processato a partire dall'XML di ogni singolo documento del risultato di
    * Sorl utilizzando un xsl dedicato.
    * Se la ricerca non ha successo, se il numero dei risultati e' maggiore a quello
    * di default (definito tra i parametri inziali) o ci sono altri errori,
    * si viene rediretti alla pagina di errore (error.jsp).
    *
    * @param request
    * @param response
    * @throws ServletException
    * @throws IOException
    * @throws SearchHandlerException
    * @throws Exception
    */
   private void processExport(HttpServletRequest request,HttpServletResponse response)
      throws IOException, ServletException, SearchHandlerException, Exception
   {
      @SuppressWarnings("unchecked")
      ParameterMap map = new ParameterMap(request.getParameterMap());
      map.put("start","0");
      SearchHandler fshandler = new SearchHandler(solrLocation);
      fshandler.setSearchParameters(map);
      fshandler.setNumRows(maxResult);

      if (!fshandler.hasValidQuery())
      {
         logger.debug("La query di ricerca non e' valida");
         response.sendRedirect(request.getContextPath() + SHOW_ERROR_JSP);
         return;
      }

      SolrResult solrResult = fshandler.getSolrResult(false);

      if ((solrResult==null) || (solrResult.getNumFound()>maxResult))
      {
         logger.debug("Il numero di risultati supera il dovuto o errore inaspettato");
         response.sendRedirect(request.getContextPath() + SHOW_ERROR_JSP);
         return;
      }

      response.setContentType( "application/octet-stream; charset=utf-8" );
      response.setHeader( "Content-Disposition", "attachment; filename=\"opac-risultati.txt" );
      
      DocumentBuilder builder = factory.newDocumentBuilder();

      PrintWriter out = response.getWriter();
      StreamResult streamResult = new StreamResult(out);
      
      OpacUser opacUser = null;
      HttpSession session = request.getSession(true);
      if (!session.isNew())
         opacUser = (OpacUser) session.getAttribute(Constants.SKEY_OPACUSER);

      if (opacUser == null)
      {
         opacUser = new OpacUser();
         session.setAttribute(Constants.SKEY_OPACUSER, opacUser);
      }

      Locale locale   = opacUser.getLocale();
      
      for (SolrResultDocument doc : solrResult.getDocuments())
      {
         String xml = doc.getString("xml");
         InputSource is = new InputSource(new StringReader(xml));
         Document document = builder.parse(is);
         DOMSource domSource = new DOMSource(document);
         
         if (locale.getLanguage().equals(new Locale("en", "", "").getLanguage()))
            transformerEn.transform(domSource, streamResult);
         else
            transformerIt.transform(domSource, streamResult);

      }

      out.close();
   }

}//class//

