
package bncf.opac.servlet;

import webdev.webengine.solr.FacetInfo;
import webdev.webengine.solr.SolrResult;

import bncf.opac.Constants;
import bncf.opac.beans.OpacUser;
import bncf.opac.handler.SearchHandler;
import bncf.opac.handler.SearchHandlerException;
import bncf.opac.util.DidYouMean;
import bncf.opac.util.ParameterMap;
import bncf.opac.util.SearchResult;
import bncf.opac.util.SpellChecker;

import org.apache.lucene.store.Directory;
import org.apache.lucene.store.SimpleFSDirectory;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.io.File;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.Map.Entry;

import javax.servlet.ServletConfig;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;


/**
 * The SearchServlet is responsible for taking in commands,
 * run queries to Solr and prepare data for output through JSP.
 *
 */
public class SearchServlet extends BaseServlet
{
   private static final long serialVersionUID = 1L;
   private final static Logger logger = LoggerFactory.getLogger(SearchServlet.class);
   private final static String SHOW_SOLR_RESULTS_JSP = "/fcsearch_results.jsp";
   private final static String SHOW_HOME_JSP = "/";
   private static int facetLimitMin;
   private static int facetLimitMax;
   private static int numRows = Constants.DEF_SOLRRESULT_NUMROWS;

   private static String didyoumeanIndexLocation;
   private static Directory spellIndex;
   private static SpellChecker spellChecker;
   private static float didyoumeanAccuracy;
   private static int maxResultsForDidyoumean;
   private static int maxResultsForExport;
   private static int didyoumeanMaxTermCount;


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
      
      // solrLocation = servletConfig.getInitParameter("solr-location");
      facetLimitMin = Integer.parseInt(servletConfig.getInitParameter("facetLimitMin"));
      facetLimitMax = Integer.parseInt(servletConfig.getInitParameter("facetLimitMax"));
      didyoumeanIndexLocation = servletConfig.getInitParameter("didyoumeanIndexLocation");
      didyoumeanAccuracy = Float.parseFloat(servletConfig.getInitParameter("didyoumeanAccuracy"));
      maxResultsForDidyoumean = Integer.parseInt(servletConfig.getInitParameter("maxResultsForDidyoumean"));
      didyoumeanMaxTermCount = Integer.parseInt(servletConfig.getInitParameter("didyoumeanMaxTermCount"));
      maxResultsForExport = appConfig.getMaxExport(); // Integer.parseInt(servletConfig.getInitParameter("maxResultForExport"));
      // System.out.println("Solr must be running at " + solrLocation + " for this application to work");
      try
      {
         spellIndex = new SimpleFSDirectory(new File(didyoumeanIndexLocation));
         spellChecker = new SpellChecker(spellIndex);
         spellChecker.setAccuracy(didyoumeanAccuracy);
      }
      catch(IOException ex)
      {
         throw new ServletException(ex);
      }
      numRows = getInitParameter(Constants.IPARAM_SOLRRESULT_NUMROWS,numRows);
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

      String ricerca = "fcsearch";

      if (servletPath.equals("/fcsearch"))
         ricerca = "fcsearch";

      if (servletPath.equals("/fcsearchm"))
         ricerca = "fcsearchm";

      logger.debug("setting ricerca attribute to: " + ricerca);
      request.setAttribute("ricerca", ricerca);

      /*
       * @todo controllare uso del canc, pare che non sia mai utilizzato
       */
      if (request.getParameter("canc") != null)
      {
         // clearFormRequest(request,response);
         StringBuilder sb = new StringBuilder(contextPath);
         sb.append(servletPath);
         if (pathInfo != null)
            sb.append(pathInfo);
         redirect(response, sb.toString());
         return;
      }

      // normalize listoffset
      int listoffset = extractOffset(pathInfo);
      logger.debug("listoffset: " + listoffset);
      if (listoffset > 0)
      {
         listoffset -= listoffset % numRows;
      }
      logger.debug("normalized listoffset: " + listoffset);

      try
      {
         processSearch(request, response, listoffset);
      }
      catch(SearchHandlerException ex)
      {
         throw new ServletException(ex);
      }
   }


   private int extractOffset(String pinfo)
   {
      if (pinfo == null)// || (pinfo.size() < 2))
      {
         return 0;
      }
      try
      {
         return Integer.parseInt(pinfo.substring(1));
      }
      catch(NumberFormatException ex)
      {
         logger.debug("bad offset in pathinfo: " + pinfo);
         return 0;
      }
   }


   /**
    * Processes the search request.
    *
    * Metodo usato in vecchia versione (si usava un DOM al posto del SolrResult).
    * Mantenuto per promemoria
    *
    * @param request
    * @param response
    * @throws ServletException
    * @throws IOException
    */
   /*
   private void _processSearch(HttpServletRequest request, HttpServletResponse response, int offset)
                              throws IOException, ServletException, SearchHandlerException
   {
      long procstart = new Date().getTime();

      SearchHandler fshandler = new SearchHandler(solrLocation);
      fshandler.setSpellChecker(spellChecker);
      fshandler.setMaxResultsForDidyoumean(maxResultsForDidyoumean);
      fshandler.setDidyoumeanMaxTermCount(didyoumeanMaxTermCount);

      // estrazione search fields and values
      for (int i = 1; i <= searchTermsMax; i++)
      {
         String field = getRequestParameter(request, "sf"+i, SearchHandler.KEYWORDS);
         String value = getRequestParameter(request, "sv"+i, null);
         if ((field == null) || (value == null))
         continue;

         fshandler.addSearchParameter(field,value);
      }

      // estrazione filtri, nella seguenza di ricezione
      for (String pname: extractParameterNames(request))
      {
         logger.debug("request-param: " + pname);
         if (SearchHandler.isFilterName(pname))
         {
            String[] params = getRequestParameters(request, pname);
            if (params != null)
            {
               if (logger.isDebugEnabled())
               {
                  for (String p: params)
                     logger.debug("filter-param: " + p);
               }
               fshandler.addFilter(pname, params);
            }
         }
      }

      // estrazione filtri per range di date
      for (String field: new String[] { "anno1" , "dataagg" })
      {
         String from = getRequestParameter(request, field + "_from", "*");
         String to   = getRequestParameter(request, field + "_to", "*");
         if (!from.equals("*")  && ! to.equals("*"))
            fshandler.addRangeFilter(field, from, to);
      }

      // fshandler.setOperator(getRequestParameter(request,"operator"));
      fshandler.setStart(offset);
      fshandler.setNumRows(numRows);
      fshandler.setSort(getRequestParameter(request,"sort"), getRequestParameter(request,"direction"));

      // impostazioni per la visualizzazione delle faccette nei box (show all, min, max)
      OpacUser opacUser = getOpacUser(request);

      //dosearch: indica una nuova ricerca testuale, e' passato dal bottone di invio della form
      if (getRequestParameter(request,"dosearch",false))
      {
         opacUser.setShowAll(null);
         fshandler.setFacetLimit(this.facetLimitMin + 1);
      }
      else
      {
         String showAll  = getRequestParameter(request,"exp");
         if (showAll == null)
            showAll = opacUser.getShowAll();
         else
         {
            opacUser.setShowAll(showAll);
            fshandler.setFacetLimit(this.facetLimitMax);
         }
      }

      if (!fshandler.runSearch())
      {
         logger.debug("Query non valida");
         request.getRequestDispatcher(SHOW_SOLR_RESULTS_JSP).forward(request, response);
         return;
      }
      Document doc = fshandler.getResultDoc();
      request.setAttribute("resultsDoc", doc);

      long searchstop = new Date().getTime();
      long xparsestop = 0L;

      int found = fshandler.getNumFound();
      if (found == 1)
      {
         SearchResult searchres =  fshandler.getSearchResult(true);
         searchres.setQueryString(request.getQueryString());
         opacUser.setSearchResult(searchres);
         // redirect sull'analitica
         StringBuilder sb = new StringBuilder(request.getContextPath());
         sb.append(Constants.SERVLETPATH_BID).append("/").append(fshandler.getBids()[0]);
         logger.debug("redirecting to: " + sb);
         redirect(response, sb.toString());
         return;
      }

      // output format  XML  o  record formattato XSL
      String fmt = getRequestParameter(request, "fmt");
      if ((fmt != null) && fmt.equals("xml"))
      {
         response.setContentType("text/xml; charset=utf-8");
         PrintWriter out = response.getWriter();
         out.println(fshandler.getResultXML());
      }
      else
      {
         SearchResult searchres =  fshandler.getSearchResult(true);
         searchres.setQueryString(request.getQueryString());
         opacUser.setSearchResult(searchres);

         xparsestop = new Date().getTime();

         request.getRequestDispatcher(SHOW_SOLR_RESULTS_JSP).forward(request, response);
      }
      long renderstop = new Date().getTime();

      if (logger.isDebugEnabled())
      {
         StringBuilder sb = new StringBuilder("search");
         if (xparsestop > 0)
         sb.append(",xparse");
         sb.append(",render: ").append(searchstop - procstart);
         if (xparsestop > 0L)
         {
            sb.append(",").append(xparsestop - searchstop);
            sb.append(",").append(renderstop - xparsestop);
         }
         else
            sb.append(",").append(renderstop - searchstop);
         sb.append(" => ").append(renderstop - procstart);
         logger.debug(sb.toString());
      }
   }
    */


   /**
    * Processes the search request.
    *
    * @param request
    * @param response
    * @throws ServletException
    * @throws IOException
    */
   private void processSearch(HttpServletRequest request,
                              HttpServletResponse response, int offset)
      throws IOException, ServletException, SearchHandlerException
   {
      @SuppressWarnings("unchecked")
      ParameterMap map = new ParameterMap(request.getParameterMap());
      map.put("start", offset+"");
      SearchHandler fshandler = new SearchHandler(appConfig.getSolrLocation());
      if (logger.isDebugEnabled())
      {
         for (Entry<String,String[]> entry : map.entrySet())
         {
            logger.debug("Request parameter: [{}] {}", entry.getKey(), entry.getValue()[0]);
         }
      }
      fshandler.setSearchParameters(map);

      /**
       * @todo ripristinare tempi di esecuzione nel log?
       */
      //settaggio di un attributo del request che indica se la ricerca e' stata
      //lanciata o meno
      if (!fshandler.hasValidQuery())
      {
         request.setAttribute("isValidSearch", false);
         request.getRequestDispatcher(SHOW_SOLR_RESULTS_JSP).forward(request, response);
         return;
      }
      request.setAttribute("isValidSearch", true);

      // impostazioni per la visualizzazione delle faccette nei box (show all, min, max)
      OpacUser opacUser = getOpacUser(request);

      //dosearch: indica una nuova ricerca testuale, e' passato dal bottone di invio della form
      if (getRequestParameter(request, "dosearch", false))
      {
         opacUser.setShowAll(null);
         fshandler.setFacetLimit(facetLimitMin + 1);
      }
      else
      {
         String showAll = getRequestParameter(request, "exp");
         if (showAll == null)
         {
            showAll = opacUser.getShowAll();
         }
         else
         {
            opacUser.setShowAll(showAll);
            fshandler.setFacetLimit(facetLimitMax);
         }
      }

      logger.debug("getting solr result...");
      String fmt = map.get("fmt", null);
      if ((fmt != null) && fmt.equals("xml"))
      {
         String resultXml = fshandler.getResultXML();
         if (resultXml != null)
         {
            response.setContentType("text/xml; charset=utf-8");
            PrintWriter out = response.getWriter();
            out.println(resultXml);
         }
      }
      else
      {
         try
         {
            SolrResult solrResult = fshandler.getSolrResult();
            if (solrResult == null)
            {
               throw new Exception("No SolrResult available!");
            }
            int numFound = solrResult.getNumFound();
            if (numFound <= maxResultsForDidyoumean)
            {
               DidYouMean didyoumean = new DidYouMean(spellChecker, didyoumeanMaxTermCount,
                                                      fshandler.getSearchTermList());
               String[] similarTerms = didyoumean.getSimilarTerms();
               request.setAttribute("didyoumean", similarTerms);
            }

            //ordinamento faccette di tipo data per nome e non per conteggio risultati
            FacetInfo fcinfo = solrResult.getFacetInfo("annopub_fc");
            if (fcinfo != null)
            {
               fcinfo.sortByName();
            }

            if (numFound == 1)
            {
               SearchResult searchres = fshandler.getSearchResult(true);
               searchres.setQueryString(request.getQueryString());
               searchres.setType((String)request.getAttribute("ricerca"));
               opacUser.setSearchResult(searchres);
               // redirect sull'analitica
               StringBuilder sb = new StringBuilder(request.getContextPath());
               sb.append(Constants.SERVLETPATH_BID).append("/").append(fshandler.getBids()[0]);
               logger.debug("redirecting to: " + sb);
               redirect(response, sb.toString());
               return;
            }

            //logger.debug("SolrResult: " + solrResult.toText());
            request.setAttribute("solrResult", solrResult);

            SearchResult searchres = fshandler.getSearchResult(true);
            searchres.setQueryString(request.getQueryString());
            searchres.setType((String)request.getAttribute("ricerca"));
            opacUser.setSearchResult(searchres);
            request.getRequestDispatcher(SHOW_SOLR_RESULTS_JSP).forward(request, response);
         }
         catch(Exception ex)
         {
            logger.info(null, ex);
            response.sendRedirect(request.getContextPath() + SHOW_HOME_JSP);
         }
      }

   }


   private void clearFormRequest(HttpServletRequest request,
                                 HttpServletResponse response) throws ServletException, IOException
   {
      request.getRequestDispatcher(SHOW_SOLR_RESULTS_JSP).forward(request,response);
   }


   public static int getFacetLimitMin()
   {
      return facetLimitMin;
   }


   public static int getFacetLimitMax()
   {
      return facetLimitMax;
   }

   public static int getMaxResultsForExport()
   {
      return maxResultsForExport;
   }
}//class//

