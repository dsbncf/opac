
package bncf.opac.servlet;

import webdev.webengine.solr.SolrResult;

import bncf.opac.Constants;
import bncf.opac.beans.OpacUser;
import bncf.opac.handler.BidSearchHandler;
import bncf.opac.handler.SearchHandler;
import bncf.opac.handler.SearchHandlerException;
import bncf.opac.util.ParameterMap;
import bncf.opac.util.SearchResult;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.w3c.dom.Document;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.Date;

import javax.servlet.ServletConfig;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.xml.transform.Transformer;
import javax.xml.transform.TransformerFactory;
import javax.xml.transform.dom.DOMSource;
import javax.xml.transform.stream.StreamResult;



/**
 * The BidViewerServlet recupera il record bibliografico per la visualizzazione.
 *
 */


public class BidViewerServlet extends BaseServlet
{
    private static Logger logger = LoggerFactory.getLogger(BidViewerServlet.class);

    private static final int BID_LENGTH = 10;
    private static final String SHOW_BID_JSP  = "/notizia_view.jsp";
    //Pagina per facebox (senza testata ne' footer)
    private static final String SHOW_BID_FB   = "/notizia_viewfb.jsp";

    //Numero massimo di termini da ricercare (sf/sv, ovvero i termini che non sono faccette)
    //private static int MAX_SEARCHTERMS = 8;
    private static int UPDATE_ROWS = 20;
    private static int numRows = Constants.DEF_SOLRRESULT_NUMROWS;

    private String solrLocation;


   /**
    * Get the Solr location from the web.xml.
    *
    * @param servletConfig
    * @throws ServletException
    */
   @Override
   public void init(ServletConfig servletConfig) throws ServletException
   {
      super.init(servletConfig);
      solrLocation = appConfig.getSolrLocation();
      numRows = appConfig.getSolrResultMaxRows();
   }


   /**
    * Processes the search request.
    *
    * @param request
    * @param response
    * @throws ServletException
    * @throws IOException
    */
   @Override
   protected void processRequest(HttpServletRequest request,
                                 HttpServletResponse response)
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


   protected void processSearch(HttpServletRequest request,
                                HttpServletResponse response)
         throws IOException, ServletException, SearchHandlerException
   {
      String contextPath = request.getContextPath();
      String servletPath = request.getServletPath();
      String pathInfo = request.getPathInfo();

      // logger.debug("context-path = " + contextPath); // "/opac2"
      // logger.debug("servlet-path = " + servletPath); // "/bid"
      // logger.debug("path-info = " + pathInfo);    // "/cfi0747013"

      String bid = null;
      int position = 0;
      int queryhash = 0;

      // controlla path e parametri
      if ((servletPath != null) && servletPath.equals("/bid")
          && (pathInfo != null) && (pathInfo.length() > BID_LENGTH))
      {
         String[] pathelems = pathInfo.split("/");
         if (pathelems.length > 1)
            bid = pathelems[1];
         // logger.debug("bid = " + bid);
         try
         {
            if (pathelems.length > 2)
               queryhash = Integer.parseInt(pathelems[2]);
            // logger.debug("queryhash = " + queryhash);
            if (pathelems.length > 3)
               position = Integer.parseInt(pathelems[3]);
            // logger.debug("position = " + position);
         }
         catch (NumberFormatException ex)
         {
            logger.debug("bad values in pathinfo: " + pathInfo);
         }
         if (logger.isDebugEnabled())
            logger.debug("bid = " + bid + "  queryhash = " + queryhash + "  position = " + position);
      }
      else
      {
         logger.info("invalid request:  servlet-path=" + contextPath
                     + "  path-info=" + pathInfo);
         return;
      }

      // controlla se primo o ulimo nella cache e evtl. update
      if (queryhash > 0)
         checkRecordCache(request, queryhash, position);

      // esegue la ricerca
      BidSearchHandler handler = new BidSearchHandler(solrLocation);
      handler.setBid(bid);
      handler.runSearch();
      Document record = handler.getRecord();

      // output format
      String fmt = getRequestParameter(request, "fmt");
      if ((fmt != null) && (fmt.equals("xml") || fmt.equals("txt")))
      {
         if (fmt.equals("xml"))
         {
            response.setContentType("text/xml; charset=utf-8");
            PrintWriter out = response.getWriter();
            try
            {
               outputRecord(out, record, fmt);
            }
            catch (Exception ex)
            {
               logger.info(null, ex);
            }
            // out.println(handler.getResultXML());
            out.close();
         }
         if (fmt.equals("txt"))
         {
            response.setContentType("text/plain; charset=utf-8");
            PrintWriter out = response.getWriter();
            try
            {
               outputRecord(out, record, fmt);
            }
            catch (Exception ex)
            {
               logger.info(null, ex);
            }

            out.close();
         }
      }
      else
      {
         if (record == null)
            logger.debug("record not found:  bid=" + bid);
         else
         {
            request.setAttribute("record", record);
            request.setAttribute("titolo", handler.getTitolo());
            request.setAttribute("autore", handler.getAutore());
            request.setAttribute("annopub", handler.getAnnopub());
            request.setAttribute("idn", handler.getIdn());
            request.setAttribute("bid", bid);
            request.setAttribute("position", position);
            request.setAttribute("queryhash", queryhash);
         }

         // apertura in facebox o in pagina nuova
         if (getRequestParameter(request, "fb", false))
         {
            logger.debug("Forward to " + SHOW_BID_FB);
            request.getRequestDispatcher(SHOW_BID_FB).forward(request, response);
         }
         else
         {
            logger.debug("Forward to " + SHOW_BID_JSP);
            request.getRequestDispatcher(SHOW_BID_JSP).forward(request, response);
         }
      }
   }


    /**
     * Controlla presenza di altri record rispetto alla poszione specificata.
     *
     * Se la posizione e' la prima o l'ultima aggiunge altri records (prima o dopo)
     * rispetto alla posizione specificata.
     *
     * La sessione potrebbe essere scaduta e quindi il SearchResult non piu disponibile.
     *
     * @param request servlet request
     * @return indica se ci sono altri records disponibili
     */
    private void checkRecordCache(HttpServletRequest request, int hash, int pos)
    {
        OpacUser opacUser = getOpacUser(request);

        SearchResult searchres = opacUser.getSearchResult();

        try
        {
           logger.debug("pos     = " + pos);
           logger.debug("query   = " + request.getQueryString());
           if (searchres == null)
           {
              // normalize listoffset
              int listoffset = (pos > 0) ? pos - 1 : 0;
              logger.debug("listoffset: " + listoffset);
              listoffset -= listoffset % numRows;
              if ((listoffset > 0) && (pos - listoffset < UPDATE_ROWS / 2))
                  listoffset -= numRows;
              logger.debug("normalized listoffset: " + listoffset);

              loadSearchResult(request, opacUser, hash, listoffset);
           }
           else
           {
              if ((pos == 1) || (pos == searchres.getRecordCount()))
                 return;

              if (searchres.isFirst(pos))
              {
                 logger.debug("record is first");
                 int offs = (pos > UPDATE_ROWS) ? pos - UPDATE_ROWS : 1;
                 updateSearchResult(request, opacUser, hash, offs);
              }
              else if (searchres.isLast(pos))
              {
                 logger.debug("record is last");
                 updateSearchResult(request, opacUser, hash, pos+1);
              }
              else
                 logger.debug("record is in the mid");
           }
        }
        catch(Exception ex)
        {
           logger.debug(ex.getMessage(),ex);
        }
    }


   /**
    * Processes the search request.
    *
    * @param request
    * @param response
    * @throws ServletException
    * @throws IOException
    * // throws IOException, ServletException, SearchHandlerException, Exception
    */
   private void loadSearchResult(HttpServletRequest request, OpacUser opacUser,
                                 int queryhash, int pos) throws Exception
   {
      long start = new Date().getTime();

      SearchHandler shandler = new SearchHandler(solrLocation);
      loadQueryParameters(request, shandler);

      shandler.setStart(pos);
      shandler.setNumRows(UPDATE_ROWS * 2);

      if (!shandler.hasValidQuery())
      {
         logger.debug("Query non valida");
         return;
      }

      SolrResult solrResult = shandler.getSolrResult(false); //don't request facet

      SearchResult searchres = opacUser.getSearchResult();
      if ((searchres != null) && (searchres.getHashCode() == queryhash))
      {
         shandler.updateSearchResult(searchres);
      }
      else
      {
         logger.debug("queryhash: " + queryhash);
         logger.debug("searchreshash: " + searchres);
         searchres = shandler.getSearchResult();
         searchres.setQueryString(request.getQueryString());
         opacUser.setSearchResult(searchres);
      }

      if (logger.isDebugEnabled())
         logger.debug("search: " + (new Date().getTime() - start));
   }


   /**
    * Processes the search request.
    *
    * @param request
    * @param response
    * @throws ServletException
    * @throws IOException
    */
   private void updateSearchResult(HttpServletRequest request, OpacUser opacUser,
                                   int queryhash, int pos)
         throws IOException, ServletException, SearchHandlerException, Exception
   {
      long start = new Date().getTime();

      SearchHandler shandler = new SearchHandler(solrLocation);

      loadQueryParameters(request, shandler);
      shandler.setStart(pos - 1);

      if (!shandler.hasValidQuery())
      {
         logger.debug("Query non valida");
         return;
      }

      SolrResult solrResult = shandler.getSolrResult(false); //don't request facet

      SearchResult searchres = opacUser.getSearchResult();
      if ((searchres != null) && (searchres.getHashCode() == queryhash))
      {
         shandler.updateSearchResult(searchres);
      }
      else
      {
         logger.debug("queryhash: " + queryhash);
         logger.debug("searchreshash: " + searchres);
         searchres = shandler.getSearchResult();
         searchres.setQueryString(request.getQueryString());
         opacUser.setSearchResult(searchres);
      }

      if (logger.isDebugEnabled())
      {
         long searchstop = new Date().getTime();
         StringBuilder sb = new StringBuilder("search: ").append(
               searchstop - start);
         logger.debug(sb.toString());
      }
   }


   private void outputRecord(PrintWriter out, Document doc, String format) throws Exception
   {
      if (format.equals("xml"))
         outputRecordXml(out, doc);

      if (format.equals("txt"))
         outputRecordTxt(out, doc);
   }


   /* Funzione per output record formato XML.
    */
   private void outputRecordXml(PrintWriter out, Document doc) throws Exception
   {
      DOMSource domSource = new DOMSource(doc);
      // PrintWriter out = new PrintWriter(new BufferedWriter(new FileWriter(fileNameToWrite)));
      StreamResult streamResult = new StreamResult(out);
      TransformerFactory tf = TransformerFactory.newInstance();
      Transformer transformer = tf.newTransformer();
      transformer.transform(domSource, streamResult);
   }


   /* Funzione per output record formato testo. Da implementare.
    * Per ora replica la funzione per output in XML.
    * @TODO
    */
   private void outputRecordTxt(PrintWriter out, Document doc) throws Exception
   {
      DOMSource domSource = new DOMSource(doc);
      // PrintWriter out = new PrintWriter(new BufferedWriter(new FileWriter(fileNameToWrite)));
      StreamResult streamResult = new StreamResult(out);
      TransformerFactory tf = TransformerFactory.newInstance();
      Transformer transformer = tf.newTransformer();
      transformer.transform(domSource, streamResult);
   }


   private void loadQueryParameters(HttpServletRequest request,
                                    SearchHandler shandler)
   {
      @SuppressWarnings("unchecked")
      ParameterMap map = new ParameterMap(request.getParameterMap());
      shandler.setSearchParameters(map);
   }


} //class//

