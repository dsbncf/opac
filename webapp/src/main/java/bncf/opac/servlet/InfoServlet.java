
package bncf.opac.servlet;

import webdev.webengine.solr.SearchTerm;
import webdev.webengine.solr.SolrResult;

import bncf.opac.Constants;
import bncf.opac.handler.SearchHandler;
import bncf.opac.handler.SearchHandlerException;
import bncf.opac.util.DeweyInfo;
import bncf.opac.util.DeweyTree;
import bncf.opac.util.DeweyTreeLoader;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.io.File;
import java.io.IOException;
import java.util.Date;

import javax.servlet.ServletConfig;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;


/**
 * Questa Servlet estrae periodicamente informazioni da Solr,
 * le registra in memoria (application context) per le frequenti
 * visualizzazioni dei totali delle varie faccette.
 *
 */
public class InfoServlet extends BaseServlet implements Runnable
{
   protected Logger logger = LoggerFactory.getLogger(InfoServlet.class);

   private final boolean debug = false;

   private static final String INITPARAM_INFO_UPDATE_INTERVAL = "update-interval";

   private static final int DEFAULT_SLEEPHOURS = 24;
   private static final int DEFAULT_FACETLIMIT = 50;

   //private static final String APPKEY_FACETCOUNTS    = "facetCounts";
   private static final String APPKEY_DEWEYTREE = "deweyTree";
   private static final String FACETS_INFO_JSP  = "facetsInfo.jsp";

   private static final int millisecondsPerHour = 3600000;
   //private static final int    millisecondsPerMinute = 60000;

   private String solrlocation = null;
   private File deweytreeFile  = null;
   private DeweyTree deweytree = null;
   //private FacetCounts facetCounts    = null;

   private volatile Thread worker = null;

   private int waithours   = DEFAULT_SLEEPHOURS;
   private long waitmillis = DEFAULT_SLEEPHOURS * millisecondsPerHour;
   private int facetlimit  = DEFAULT_FACETLIMIT;

   private volatile Date lastexecutiondate = null;
   private final String deweycodFacet = "dewey_cod3";
   private final String[] facetFields =
   {
      deweycodFacet, "categoria_fc", "lingua_fc",
      "biblioteca_fc", "annopub_fc"
   };


   /**
    * Get the Solr location from the web.xml.
    *
    * @param config
    * @throws ServletException
    */
   @Override
   public void init(ServletConfig config) throws ServletException
   {
      super.init(config);

      solrlocation = appConfig.getSolrLocation();
      logger.info("Solr must be running at " + solrlocation + " for this application to work");

      String df = appConfig.getDeweytreeDatafile();
      String path = servletContext.getRealPath("/") + "WEB-INF/" + df;
      deweytreeFile = new File(path);
      if (!deweytreeFile.exists())
      {
         throw new ServletException("deweytree-datafile non trovato: " + path);
      }

      loadDeweyTree(); // carica i dati dal file (cod + descr, non count)
      servletContext.setAttribute(APPKEY_DEWEYTREE, deweytree);

      setUpdateInterval(getInitParameter(INITPARAM_INFO_UPDATE_INTERVAL,
                                              DEFAULT_SLEEPHOURS));

      worker = new Thread(this);
      worker.setPriority(Thread.MIN_PRIORITY);
      worker.start();
   }


   // ------------------------------------------------------------- -- run --
   @Override
   public void run()
   {
      Thread thisThread = Thread.currentThread();
      while (thisThread == worker)
      {
         logger.info("started... " + dateformatter.format(new Date()));
         try
         {
            processSearch();
            lastexecutiondate = new Date();
            logger.info("...finished at " + dateformatter.format(lastexecutiondate));
         }
         catch(Exception ex)
         {
            logger.error(ex.getMessage(), ex);
         }
         finally
         {
            try
            {
               thisThread.sleep(waitmillis);
            }
            catch(InterruptedException ex)
            {
               logger.error(ex.getMessage());
            }
         }
      }
   }


   public void stop()
   {
      worker = null;
   }


   @Override
   public void destroy()
   {
      worker = null;
   }


   /**
    * Processes the search request.
    *
    * @throws ServletException
    * @throws IOException
    */
   private void processSearch()
      throws Exception, IOException, ServletException, SearchHandlerException
   {
      //String param;
      SearchHandler fshandler = new SearchHandler(solrlocation, false);
      SearchTerm term = new SearchTerm(SearchHandler.KEYWORDS, "*");
      fshandler.addSearchTerm(term);
      for (String facet : facetFields)
      {
         fshandler.addFacet(facet);
      }
      fshandler.setFacetLimit(3000);
      SolrResult solrResult = fshandler.getSolrResult();
      logger.debug("SolrResult: {}", solrResult);
      if (solrResult == null)
      {
         logger.error("SolrResult(facetcounts) non disponibile");
         return;
      }

      //FacetInfo fcinfo = solrResult.getFacetInfo("categoria_fc");
      //if (fcinfo != null)
      //   fcinfo.sortByName();

      deweytree.updateCount(solrResult.getFacetInfo(deweycodFacet));

      if (logger.isDebugEnabled())
      {
         for (DeweyInfo dwy : deweytree.getDeweyInfoList())
         {
            logger.debug("DeweyInfo : " + dwy.toString());
         }
         for (String c : new String[]{"0", "1", "2", "3", "4", "5", "6", "7", "8", "9"})
         {
            for (DeweyInfo dwy : deweytree.getDeweyInfoList(c))
            {
               logger.debug("DeweyInfo : " + dwy.toString());
            }
         }
      }
      servletContext.setAttribute(Constants.AKEY_FACETCOUNTS, solrResult);
   }


   /**
    * Carica i dati relativi al tree delle classi Dewey.
    *
    * @throws IOException
    */
   private void loadDeweyTree() throws ServletException
   {
      DeweyTreeLoader loader = new DeweyTreeLoader();
      loader.loadDeweyTree(deweytreeFile);
      // loader.loadDeweyTree(dataSource);
      deweytree = loader.getDeweyTree();

      /*
      try
      {
         BufferedReader inp = new BufferedReader(new FileReader(deweytreeFile));
         deweytree = new DeweyTree();
         String str;
         while ((str = inp.readLine()) != null)
         {
            if (str.equals(""))
               continue;
            String[] values = str.split("\\|");
            String descr = ((values.length > 1) ? values[1] : "?");
            deweytree.addDeweyInfo(values[0],descr);
            // logger.debug("dewey loaded: " + values[0] + " | " + descr);
         }
         inp.close();
      }
      catch (IOException ex)
      {
         throw new ServletException(ex);
      }
       */
   }


   /**
    * Implementa funzioni amministrative.
    *
    * @TODO implementare varie funzioni relative alle info sulle facette.
    * Permette:
    *      * di rilanciare la query per aggiornare i totali.
    *      * di modificare il tempo di intervallo fra le esecuzioni.
    *      * di impostare il numero di voci da memorizzare/visualizzare.
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
      String action = getRequestParameter(request, "action");
      if ((action != null) && action.equals("update"))
      {
	 doUpdate();
      }

      request.setAttribute("lastupdate", dateformatter.format(lastexecutiondate)); // String
      request.setAttribute("solrlocation", solrlocation);      // String
      request.setAttribute("facetlimit", new Integer(facetlimit));
      request.setAttribute("updateinterval", new Integer(waithours));

      request.getRequestDispatcher(FACETS_INFO_JSP).forward(request, response);
   }


   private void setUpdateInterval(int hours)
   {
      if (hours > 0)
      {
	 waithours = hours;
	 waitmillis = hours * millisecondsPerHour;
	 logger.info("InfoServlet aggiorna ogni " + waithours + " ore");
	 // TODO: interrupt current sleep
      }
   }


   private void doUpdate()
   {
      Date last = lastexecutiondate;
      worker.interrupt();

      Thread thisThread = Thread.currentThread();
      int loop = 3;
      while (last.equals(lastexecutiondate) && (loop > 0))
      {
	 // logger.debug("loop=" + loop + " - lastupdate = " + dateformatter.format(lastexecutiondate));
	 try
	 {
	    thisThread.sleep(100);
	 }
	 catch (InterruptedException ex)
	 {
	    logger.error(ex.getMessage());
	 }
	 --loop;
      }
   }

} //class//

