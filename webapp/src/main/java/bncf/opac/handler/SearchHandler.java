
package bncf.opac.handler;

import bncf.opac.Constants;

import bncf.opac.util.StringUtils;
import bncf.opac.util.SearchResult;
import bncf.opac.util.ParameterMap;
import bncf.opac.util.LuceneTerm;

import java.util.Arrays;

import webdev.webengine.solr.SolrResult;
import webdev.webengine.solr.SearchTerm;
import webdev.webengine.solr.SearchTermList;
import webdev.webengine.solr.SolrResultDocument;

import bncf.opac.util.HttpUtils;

import java.io.IOException;
import java.io.UnsupportedEncodingException;

import java.net.URLEncoder;

import java.text.ParseException;
import java.text.SimpleDateFormat;

import java.util.ArrayList;
import java.util.Locale;
import java.util.TimeZone;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;





/**
 * Questa servlet esegue la ricerca su solr, richiedendo anche le facette correlate.
 */
public class SearchHandler
{
   // public static variables
   public static TimeZone UTC = TimeZone.getTimeZone("UTC");

   // Il facelimit viene sempre comunque risettato dalla servlet SearchServlet,
   // in ogni caso viene settato un valore di default
   // Vedere parametri: facetLimitMin e facetLimitMax in web.xml
   // Questo valore deve sempre essere maggiore del facetLimitMin,
   // altrimenti non si vede il "mostra tutti" nella pagina pubblica
   public static final int DEFAULT_FACETLIMIT = 20;

   //Numero massimo di termini da ricercare (sf/sv, ovvero i termini che non sono faccette)
   private static int SEARCHTERMSMAX = Constants.DEF_SEARCHTERMSMAX;

   public static final String KEYWORDS       = "keywords";
   public static final String TITOLO         = "titolo";
   public static final String SEARCHFIELD    = "sf";
   public static final String SEARCHVALUE    = "sv";
   public static final String LINGUA_FC      = "lingua_fc";
   public static final String CATEGORIA_FC   = "categoria_fc";
   public static final String BIBLIOTECA_FC  = "biblioteca_fc";
   public static final String SOGGETTO_FC    = "soggetto_fc";
   public static final String DESCRITTORE_FC = "descrittore_fc";
   public static final String AUTORE_FC      = "autore_fc";
   public static final String TITOLO_FC      = "titolo_fc";
   public static final String OPERA_FC       = "opera_fc";
   public static final String EDITORE_FC     = "editore_fc";
   public static final String DEWEY_FC       = "dewey_fc";
   public static final String DEWEYEDIZ_FC   = "deweyediz_fc";
   public static final String DEWEYCOD_FC    = "deweycod_fc";
   public static final String PAESE_FC       = "paese_fc";
   public static final String ANNOPUB_FC     = "annopub_fc";
   public static final String DEWEY_COD3     = "dewey_cod3";
   public static final String TIPOSOGG       = "tiposogg";

   // range filters
   public static final String RF_ANNO1   = "anno1";
   public static final String RF_DATAAGG = "dataagg";

   //NON USATO
   public static final String[][] DATE_QUERIES =
   {
      {"*", "1439"},
      {"1440", "1500"},
      {"1501", "1599"},
      {"1600", "1650"},
      {"1651", "1699"},
      {"1700", "1750"},
      {"1751", "1799"},
      {"1800", "1830"},
      {"1831", "1860"},
      {"1861", "1885"},
      {"1886", "1899"},
      {"1900", "1920"},
      {"1921", "1940"},
      {"1941", "1960"},
      {"1961", "1980"},
      {"1981", "2000"},
      {"2000", "*"}
   };

   // private variables
   private final static Logger logger = LoggerFactory.getLogger(SearchHandler.class);

   private static final String SEARCHOPERATOR_AND     = "AND";
   private static final String SEARCHOPERATOR_OR      = "OR";
   private static final String DEFAULT_SEARCHOPERATOR = SEARCHOPERATOR_AND;
   private static final int DEFAULT_SEARCHRESULTS     = 20;
   private static final int DEFAULT_RESULTSTART       = 0;

   // la lista dei fields presenti in solr
   private static final String[] solrFields =
   {
      LINGUA_FC, CATEGORIA_FC, BIBLIOTECA_FC,
      SOGGETTO_FC, DESCRITTORE_FC, AUTORE_FC,
      TITOLO_FC, OPERA_FC, EDITORE_FC, DEWEY_FC,
      DEWEYEDIZ_FC, DEWEYCOD_FC, PAESE_FC, ANNOPUB_FC,
      DEWEY_COD3, TIPOSOGG, RF_ANNO1, RF_DATAAGG
   };

   // la lista dei filtri che possono essere impostati nella query
   private static final String[] filterNames =
   {
      LINGUA_FC, CATEGORIA_FC, BIBLIOTECA_FC,
      DESCRITTORE_FC, SOGGETTO_FC, AUTORE_FC,
      TITOLO_FC, OPERA_FC, DEWEY_FC, DEWEYCOD_FC,
      DEWEY_COD3, DEWEYEDIZ_FC, PAESE_FC,
      ANNOPUB_FC, EDITORE_FC, TIPOSOGG
   };

   private static final String[] defaultFacets =
   {
      CATEGORIA_FC, LINGUA_FC, EDITORE_FC, DESCRITTORE_FC, SOGGETTO_FC,
      AUTORE_FC, BIBLIOTECA_FC, OPERA_FC, ANNOPUB_FC
   };

   private static final String[] rangefilters = { RF_ANNO1, RF_DATAAGG };

   private static SimpleDateFormat sdtformatter  = new SimpleDateFormat("dd/MM/yyyy");
   private static SimpleDateFormat solrFormatter = new SimpleDateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS", Locale.US);

   private SearchTermList searchTermList = new SearchTermList();
   private SearchTermList filterTermList = new SearchTermList(); //era filtermap

   private SolrResult solrResult = null;
   private String querystring    = null;
   private String queryop        = DEFAULT_SEARCHOPERATOR;
   private int start             = DEFAULT_RESULTSTART;
   private int numrows           = DEFAULT_SEARCHRESULTS;
   private String sortfld        = null;
   private String sortdir        = null;
   private int facetLimit        = DEFAULT_FACETLIMIT;
   private int numFound          = 0;

   // facets da aggiungere ad ogni query
   private ArrayList<String> queryFacets = new ArrayList<String>();
   private final String solrLocation;


   public static String[] getFilterNames()
   {
      return filterNames; // final
   }


   public static boolean isFilterName(String name)
   {
      for (String filter : filterNames)
      {
         if (filter.equals(name))
         {
            return true;
         }
      }
      return false;
   }


   public static boolean isSolrField(String name)
   {
      for (String fld : solrFields)
      {
         if (fld.equals(name))
         {
            return true;
         }
      }
      return false;
   }


   /**
    * Constructor
    *
    * @param  location of Solr search engine.
    */
   public SearchHandler(String solrLocation)
   {
      this.solrLocation = solrLocation;
      solrFormatter.setTimeZone(UTC);
      loadDefaultFacets();
   }


   public SearchHandler(String solrLocation, boolean useDefaultFacets)
   {
      this.solrLocation = solrLocation;
      solrFormatter.setTimeZone(UTC);
      if (useDefaultFacets)
      {
         loadDefaultFacets();
      }
   }


   public void setSearchParameters(ParameterMap params)
   {
      this.setStart(params.get("start"));
      this.setNumRows(params.get("numResults"));
      this.setSort(params.get("sort"), params.get("direction"));
      this.addRangeFilters(params);
      this.addSearchTerms(params);
      this.addFilters(params);
   }

   /** Invia una richiesta a solr imponendo di usare le faccette.
    *
    * @return
    * @throws Exception
    */
   public SolrResult getSolrResult() throws Exception
   {
      return getSolrResult(true);
   }

   /** Invia una richiesta a solr.
    *
    * @param useFacet Indica se devono essere usate le faccette o meno.
    * @return
    * @throws Exception
    */
   public SolrResult getSolrResult(boolean useFacet) throws SearchHandlerException
   {
      loadSolrResult(useFacet);
      return solrResult;
   }


   private boolean loadSolrResult(boolean useFacet) throws SearchHandlerException
   {
      solrResult = null;
      try
      {
         String resultXml = sendSolrGetCommand(useFacet);
         // logger.debug("XML:...............................\n{}", resultXml);
         // parsing del risultato Solr
         if (resultXml != null)
         {
            solrResult = new SolrResult();
            logger.debug("parsing solr result....");
            solrResult.parse(resultXml);
            logger.debug("... END parsing solr result");
            this.numFound = solrResult.getNumFound();
         }
         return (solrResult != null);
      }
      catch (Exception ex)
      {
         solrResult = null;
         logger.error("Error loading Result from Solr", ex);
         // UnsupportedEncodingException, IOException,
         // ParserConfigurationException, SAXException
         throw new SearchHandlerException(ex);
      }
   }


   // -----------------------------------------------------
   private void setQueryString(SolrResult solrResult)
   {
      //inutilizzato, serviva per modificare certi dati nel solrResult
   }


   /**
    * Submit a {@link #sendSolrGetCommand(String,String)} with facets
    * and then output pure XML.
    *
    * @return Output xml string
    */
   public String getResultXML() // throws  IOException, ParserConfigurationException, SAXException
   {
      return getResultXML(true);
   }

   /**
    * Submit a {@link #sendSolrGetCommand(String,String)} with or without facets
    * and then output pure XML.
    *
    * @param useFacet Indica se usare le faccette o no nella richiesta a Solr
    *
    * @return Output xml string
    */
   public String getResultXML(boolean useFacet) // throws  IOException, ParserConfigurationException, SAXException
   {
      try
      {
         return sendSolrGetCommand(useFacet);
      }
      catch(Exception ex)
      {
         logger.info(null, ex);
         return null;
      }
   }


   public String getQueryString()
   {
      return (querystring == null) ? null : querystring.toString();
   }


   public void setStart(String start)
   {
      if (start != null)
      {
         try
         {
            this.start = Integer.parseInt(start);
         }
         catch(NumberFormatException ex)
         {
            logger.debug(null, ex);
         }
      }
   }


   public void setStart(int start)
   {
      this.start = start;
   }


   public void setNumRows(int num)
   {
      this.numrows = num;
   }


   public void setNumRows(String num)
   {
      if (num != null)
      {
         try
         {
            this.numrows = Integer.parseInt(num);
         }
         catch(NumberFormatException ex)
         {
            logger.debug(null, ex);
         }
      }
   }


   public void setFacetLimit(int num)
   {
      this.facetLimit = num;
   }


   public void setSort(String sort, String direction)
   {
      //only adding sort if it is not score, since score is the default

      if (sort != null && !sort.equals("") && !sort.equals("score"))
      {
         if (sort.equals("data"))
         {
            this.sortfld = "anno1";
            this.sortdir = "desc";
         }
         else
         {
            if (sort.equals("titolo"))
            {
               this.sortfld = "titolo_srt";
               this.sortdir = "asc";
            }
            else
            {
               if (sort.equals("autore"))
               {
                  this.sortfld = "autore_srt";
                  this.sortdir = "asc";
               }
            }
         }

         if (direction != null)
         {
            this.sortdir = direction.equals("asc") ? "asc" : "desc";
         }
      }
   }


   public void addSearchTerm(SearchTerm term)
   {
      if (term.isValid())
      {
         this.searchTermList.add(term);
         logger.debug("added term: " + term);
      }
      else
      {
         logger.debug("invalid term: " + term);
      }
   }


   public SearchTermList getSearchTermList()
   {
      return this.searchTermList;
   }


   public void addFacet(String facetname)
   {
      for (String facet : queryFacets)
      {
         if (facet.equals(facetname)) // gia' presente
         {
            return;
         }
      }
      queryFacets.add(facetname);
      logger.debug("added facet: " + facetname);
   }


   public void addFilter(String filtername, String[] values)
   {
      if ((filtername == null) || (values == null) || (values[0] == null) || values[0].
         equals(""))
      {
         return;
      }

      if (filterTermList == null)
         filterTermList = new SearchTermList();

      for (String val : values)
      {
         filterTermList.add(new SearchTerm(filtername, val));
         logger.debug("added filter: " + filtername + " : " + val);
      }
   }


   public void addFilter(String filtername, String value)
   {
      if ((filtername == null) || (value == null) || value.equals(""))
      {
         return;
      }

      if (filterTermList == null)
      {
         filterTermList = new SearchTermList();
      }
      filterTermList.add(new SearchTerm(filtername, value));
      logger.debug("added filter: " + filtername + " : " + value);
   }


   public int getNumRows()
   {
      return numrows;
   }


   public int getNumFound()
   {
      return this.numFound;
   }


   public int getStart()
   {
      return this.start;
   }


   /**
    * Tokenizes search parameters and add search terms to query.
    *
    * @param field the terms field
    * @param value search parameter
    *
    */
   public void addSearchParameter(String field, String value)
   {
      String[] tokens = StringUtils.extractLucenePhrases(value);
      for (String token : tokens)
      {
         logger.debug("token: " + token);
         if (token.equals("*"))
         {
            continue;
         }

         int op = LuceneTerm.getOperatorType(token.charAt(0));
         logger.debug("operator: " + op);
         String tokval = (op != LuceneTerm.OPERATOR_NONE) ? token.substring(1) : token;
         addSearchTerm(new SearchTerm(field, tokval, op));
      }
   }


   /**
    * Tokenizes search parameters and add search terms to query.
    *
    * @param field the terms field
    * @param value search parameter
    *
    */
   public void addRangeFilter(String field, String from, String to)
   {
      StringBuilder sb = new StringBuilder();
      //sb.append("%5B").append(from).append("%2BTO%2B").append(to).append("%5D");
      sb.append("[").append(from).append(" TO ").append(to).append("]");
      addFilter(field, sb.toString());
   }


   public String[] getBids()
   {
      if (solrResult == null)
      {
         return null;
      }

      ArrayList<SolrResultDocument> docs = solrResult.getDocuments();

      String[] bids = new String[docs.size()];
      for (int i = 0; i < docs.size(); i++)
      {
         bids[i] = docs.get(i).getString("idn");
      }
      return bids;
   }


   public SearchResult getSearchResult(boolean loadsolrresult)
   {
      SearchResult res = new SearchResult(getStart(), getNumFound(), getBids());
      res.setNumRows(numrows);
      if (loadsolrresult)
      {
         res.setSolrResult(solrResult);
      }
      return res;
   }


   /**
    * Verifica se il term rappresenta un range-filter.
    */
   private boolean isRangeFilterTerm(LuceneTerm term)
   {
      String field = term.getField();
      for (String fltr : rangefilters)
      {
         if (fltr.equals(field))
         {
            logger.debug("is range filter: " + term);
            return true;
         }
      }
      return false;
   }


   /**
    * Verifica se il term rappresenta un filter (not range-filter).
    */
   private boolean isFilterTerm(LuceneTerm term)
   {
      String field = term.getField();
      for (String fltr : filterNames)
      {
         if (fltr.equals(field))
         {
            return true;
         }
      }
      return false;
   }


   /**
    * Aggiunge il parametro 'fq' (filter-query) alla richiesta.
    * Filtri multipli vengono accodati, separati da carattere '+' (%2B)
    */
   private void appendFilterTerms(StringBuilder query, boolean asFilter)
      throws UnsupportedEncodingException
   {
      String queryParam = "&q=";
      String filterParam = "&fq=";

      int position = 0; // indicazione del primo elemento del parametro
      for (SearchTerm term : filterTermList)
      {
         String name = term.getField();
         if (!isSolrField(name))
         {
            logger.debug("unknow Solr field: " + name);
            continue;
         }
         String value = term.getValue();
         //if (logger.isDebugEnabled())
         //   logger.debug("examine filter: " + name + " : " + value + " position=" + position );
         switch(position)
         {
            case 0:
               query.append(asFilter ? filterParam : queryParam);
               break;
            default:
               query.append(filterParam);
               break;
            //case  1: query.append(filterParam); break;
            //default: query.append("+%2B"); // '+'
         }
         query.append(name).append(":").append(URLEncoder.encode(value, "UTF-8"));
         position++;
         logger.debug("appended filter: " + name + " : " + value);
      }
   }


   /**
    * Aggiunge il parametro 'fq' (filter-query) alla richiesta.
    * Filtri multipli vengono accodati, separati da carattere '+' (%2B)
    */
   /*
   private void appendFilterParams(StringBuilder query, boolean asFilter)
                                             throws UnsupportedEncodingException
   {
      String queryParam  = "&q=";
      String filterParam = "&fq=";

      int position = 0; // indicazione del primo elemento del parametro
      for (Map.Entry<String,String[]> entry: filterTermList.entrySet())
      {
         String name = entry.getKey();
         String[] values = entry.getValue();
         if (values != null)
         {
            for (String val: values)
            {
               if (logger.isDebugEnabled())
                  logger.debug("examine filter: " + name + " : " + val + " position=" + position );
               switch(position)
               {
                  case  0: query.append(asFilter ? filterParam : queryParam); break;
                  // case  1: query.append(filterParam); break;
                  default: query.append("+%2B"); // '+'
               }
               query.append(name).append(":").append(URLEncoder.encode(val,"UTF-8"));
               position++;
               logger.debug("appended filter: " + name + " : " + val );
            }
         }
      }
   }
   */


   /**
    * Aggiunge il parametro 'q' (query) alla richiesta.
    * SearchTerms multipli vengono accodati, separati da carattere '+' (%2B)
    */
   /*
   private void appendSearchTerms(StringBuilder query) throws  UnsupportedEncodingException
   {
      boolean first = true; // indicazione del primo elemento del parametro
      for (LuceneTerm term: searchTermList)
      {
         if (first)
         {
            query.append("&q=");
            first = false;
         }
         else
            query.append("+");

         switch(term.getOperator())
         {
            case LuceneTerm.OPERATOR_AND: query.append("%2B"); break; // '+'
            case LuceneTerm.OPERATOR_NOT: query.append("-"); break;
         }
         // if (term.isRequired()) query.append("%2B"); // '+'
         query.append(term.getField()).append(":").append(URLEncoder.encode(term.getText(),"UTF-8"));
      }
   }
    *
    */


   /**
    * Aggiunge il parametro 'q' (query) alla richiesta.
    * SearchTerms multipli vengono accodati, separati da carattere '+' (%2B)
    */
   private void appendSearchTerms(StringBuilder query) throws UnsupportedEncodingException
   {
      int pos = 0; // indicazione del primo elemento del parametro
      //for (LuceneTerm term: searchTermList)
      for (SearchTerm term : searchTermList)
      {
         query.append((pos++ == 0) ? "&q=" : "&fq=");
         if (term.isRequired())
         {
            query.append("%2B"); // '+'
         }
         query.append(term.getField()).append(":").append(URLEncoder.encode(term.
            getValue(), "UTF-8"));
      }
   }


   public boolean hasValidQuery()
   {
      return (searchTermList.hasSearchTerms() || filterTermList.hasSearchTerms());
   }


   /**
    * Build the querystring for a Solr Facet Query request.
    *
    * See http://wiki.apache.org/solr/CoreQueryParameters,
    *     http://wiki.apache.org/solr/CommonQueryParameters,
    *     http://wiki.apache.org/solr/HighlightingParameters,
    *     http://wiki.apache.org/solr/SolrRequestHandler
    *     http://wiki.apache.org/solr/SolrFacetingOverview
    *     http://wiki.apache.org/solr/SimpleFacetParameters
    *
    * @throws UnsupportedEncodingException
    *
    */
   private String buildSolrQuery() throws UnsupportedEncodingException
   {
      return buildSolrQuery(true); //not use facet
   }

   /**
    * Build the querystring for a Solr Facet Query request.
    *
    * @param useFacet Costruisce la query in modo che abbia o non abbia la richiesta di faccette.
    *
    * See http://wiki.apache.org/solr/CoreQueryParameters,
    *     http://wiki.apache.org/solr/CommonQueryParameters,
    *     http://wiki.apache.org/solr/HighlightingParameters,
    *     http://wiki.apache.org/solr/SolrRequestHandler
    *     http://wiki.apache.org/solr/SolrFacetingOverview
    *     http://wiki.apache.org/solr/SimpleFacetParameters
    *
    * @throws UnsupportedEncodingException
    *
    */
   private String buildSolrQuery(boolean useFacet) throws UnsupportedEncodingException
   {
      boolean hasSearchTerms = searchTermList.hasSearchTerms();
      boolean hasFilterTerms = filterTermList.hasSearchTerms();

      logger.debug("hasSearchTerms: " + hasSearchTerms);
      logger.debug("hasFilterTerms: " + hasFilterTerms);

      if (!hasSearchTerms && !hasFilterTerms)
         return null;

      StringBuilder query = new StringBuilder();
      query.append("fl=*,score");
      if (useFacet)
      {
         if (facetLimit > 0)
            query.append("&facet=true&facet.mincount=1&facet.limit=").append(facetLimit);
      }
      else
         query.append("&facet=false");

      String op = searchTermList.hasOR() ? SEARCHOPERATOR_OR : SEARCHOPERATOR_AND;
      query.append("&q.op=").append(op);
      query.append("&start=").append(start);
      query.append("&rows=").append(numrows);

      StringBuilder sort = new StringBuilder();
      //Eliminato orderBy come array di ordinamenti perche' su opac c'e' un solo
      //possibile ordinamento
      //for (String ord : orderBy)
      //{
      if (this.sortfld != null)
      {
         //sort.append(",");
         sort.append(this.sortfld).append("+").append(this.sortdir);
      }
      //}
      if (sort.length() > 0)
         query.append("&sort=").append(sort);

      if (useFacet && (facetLimit>0))
      {
         for (String facet : queryFacets)
            if (facet != null)
               query.append("&facet.field=").append(facet);
         addDateRangeFacets(query);
      }

      //// aggiunta di elementi facet.query
      //for (String[] dts: DATE_QUERIES)
      //{
      //   facets.append("&facet.query=").append("anno1%3A%5B")
      //          .append(dts[0]).append("+TO+").append(dts[1]).append("%5D");
      //}

      if (hasSearchTerms)
         appendSearchTerms(query);

      if (hasFilterTerms)
         appendFilterTerms(query, hasSearchTerms);

      return query.toString().trim();
   }


   private void addDateRangeFacets(StringBuilder query)
   {
      //eventuale aggiunta di filtri di tipo date range
   }


   /**
    * Dato un Parameter Map, trova i termini di ricerca contenuti
    * e li aggiunge, cercando solo i termini
    *
    * @param param
    * @return
    */
   private void addSearchTerms(ParameterMap params)
   {
      if (params == null)
         return;

      for (int i = 0; i <= SEARCHTERMSMAX; i++)
      {
         if (params.containsKey(SEARCHFIELD + i)
	     && params.containsKey(SEARCHVALUE + i))
         {
            String sf = params.get(SEARCHFIELD + i, null);
            String sv = params.get(SEARCHVALUE + i, null);
            if ((sf != null) && (sv != null))
            {
               this.addSearchTerm(new SearchTerm(sf, sv));
            }
         }
      }
   }


   /**
    * Dato un Parameter Map, trova filtri di tipo range contenuti
    * e li aggiunge, cercando solo i termini
    *
    * @param param
    * @return
    */
   private void addRangeFilters(ParameterMap params)
   {
      if (params == null)
         return;

      for (String rangeFilter : rangefilters)
      {
         logger.debug("rangeFilter: " + rangeFilter);
         if (params.containsKey(rangeFilter + "_from")
	     || params.containsKey(rangeFilter + "_to"))
         {
            String from = params.get(rangeFilter + "_from", "*");
            String to   = params.get(rangeFilter + "_to", "*");
            if ((!from.equals("*")) || (!to.equals("*")))
               this.addRangeFilter(rangeFilter, from, to);
         }
      }
   }


   /**
    * Dato un Parameter Map, trova filtri contenuti
    * e li aggiunge
    *
    * @param param
    * @return
    */
   private void addFilters(ParameterMap params)
   {
      if (params == null)
      {
         return;
      }

      // estrazione filtri
      for (String filtername : filterNames)
      {
         if (params.containsKey(filtername))
         {
            String value = params.get(filtername, null);
            if (value != null)
            {
               this.addFilter(filtername, value);
            }
         }
      }
   }

   


   /**
    * Send the command to Solr using a GET
    *
    * @param useFacet Costruisce la query in modo che abbia o non abbia la richiesta di faccette.
    * @return
    * @throws IOException
    */
   private String sendSolrGetCommand(boolean useFacet) throws IOException
   {
      this.querystring = buildSolrQuery(useFacet);
      logger.debug("Query: " + querystring);
      if (querystring == null)
      {
         return null;
      }
      String url = solrLocation + "/select?" + querystring;
      logger.debug("Sending GET request: {}", url);
      String resultXml = HttpUtils.get(url);
      logger.debug("Response: {}", resultXml);
      return resultXml;
   }


   /**
    * Converts locale date format to Solr DateField format.
    * Formato applicato: yyyy-MM-dd'T'HH:mm:ss.SSSZ
    */
   private String getSolrDate(String sdate) throws ParseException
   {
      return (sdate == null) ? null : solrFormatter.format(sdtformatter.parse(
         sdate));
   }


   public void updateSearchResult(SearchResult searchResult)
   {
      searchResult.updateRecordList(start, getBids());
   }


   public SearchResult getSearchResult()
   {
      SearchResult res = new SearchResult(start, numFound, getBids());
      res.setNumRows(numrows);
      return res;
   }


   private void loadDefaultFacets()
   {
      queryFacets.addAll(Arrays.asList(defaultFacets));
   }

} //class//

