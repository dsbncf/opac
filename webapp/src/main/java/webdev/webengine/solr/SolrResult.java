
package webdev.webengine.solr;

import org.apache.lucene.analysis.standard.StandardAnalyzer;
import org.apache.lucene.queryParser.ParseException;
import org.apache.lucene.queryParser.QueryParser;
import org.apache.lucene.search.BooleanClause;
import org.apache.lucene.search.BooleanQuery;
import org.apache.lucene.search.Query;
import org.apache.lucene.util.Version;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.util.ArrayList;

/**
 *
 * @author ds
 * @TODO: valutare se eliminare distinzione in SearchTerm / FilterTerm
 *
 */
public class SolrResult
{
   public static final int STATUS_UNDEFINED = -1;
   public static final int STATUS_OK = 0; // ricerca eseguita correttamente
   public static final int STATUS_BADQUERY = 1; // query terms/filtri mancanti
   public static final int STATUS_ERROR = 2; // errori solr, errori di protocollo http

   private static final Logger logger = LoggerFactory.getLogger(SolrResult.class);

    private int  status = STATUS_UNDEFINED;
    private long qTime  = 0;

    private boolean facet = false;
    private String[] fieldList = null;
    private int  facetMinCount = 0;
    private int  facetLimit = 0;
    private int  requestStart = 0;
    private int  rows = 0;
    private String query = null;
    private String sort = null;
    private String queryOp = "AND";
    private String filterQuery = null;
    private String version = null;
    private ArrayList<String> facetFields = new ArrayList<String>();
    private ArrayList<String> facetQueries = new ArrayList<String>();
    // result
    private int     start = 0;
    private int     numFound = 0;
    private int     lastDayCount = 0;
    private int     last3DayCount = 0;
    private int     lastWeekCount = 0;
    private int     lastMonthCount = 0;
    private double  maxScore = 0D;
    private ArrayList<SolrResultDocument> documents = new ArrayList<SolrResultDocument>();
    private ArrayList<FacetInfo> facetInfos = new ArrayList<FacetInfo>();
    private SearchTermList searchTermList = new SearchTermList();
    private SearchTermList filterTermList = new SearchTermList();
    private String defaultField = "keywords";

    public SolrResult()
    {
        //
    }

    public void setDefaultField(String field)
    {
       this.defaultField = field;
    }

    public String getDefaultField()
    {
       return defaultField;
    }

    public void parse(String xml) throws Exception
    {
        SolrResultParser evr = new SolrResultParser(this);
        evr.parse(xml);
    }


    public int getStatus()
    {
        return status;
    }

    public boolean hasFacet()
    {
        return facet;
    }

    public int getFacetLimit()
    {
        return facetLimit;
    }

    public int getFacetMincount()
    {
        return facetMinCount;
    }

    public String[] getFieldList()
    {
        return fieldList;
    }

    public double getMaxScore()
    {
        return maxScore;
    }

    public int getNumFound()
    {
        return numFound;
    }

    public long getQTime()
    {
        return qTime;
    }

    public String getQuery()
    {
        return query;
    }

    public String getQueryOp()
    {
        return queryOp;
    }


    public int getRequestStart()
    {
        return requestStart;
    }

    public int getRows()
    {
        return rows;
    }

    public int getStart()
    {
        return start;
    }

    public String getVersion()
    {
        return version;
    }

    public ArrayList<String> getFacetQueries()
    {
        return facetQueries;
    }

    public ArrayList<String> getFacetFields()
    {
        return facetFields;
    }


    public ArrayList<SolrResultDocument> getDocuments()
    {
        return documents;
    }

    public SolrResultDocument getDocument(int index)
    {
        return  ((index >= 0) && (index < documents.size())) ? documents.get(index) : null;
    }


    public ArrayList<FacetInfo> getFacetInfos()
    {
        return facetInfos;
    }

    public FacetInfo getFacetInfo(String name)
    {
        for (FacetInfo fc : facetInfos)
            if (fc.getName().equals(name))
                return fc;
        return null;
    }

    public void addSearchTerm(SearchTerm term)
    {
        searchTermList.add(term);
        logger.debug("SearchTerm added: " + term);
    }

    public void addSearchTerms(SearchTermList termList)
    {
        searchTermList.addAll(termList);
    }

    public SearchTermList getSearchTermList()
    {
        return searchTermList;
    }

    public SearchTerm getSearchTerm(String filtername)
    {
        for (SearchTerm term : searchTermList)
        {
            String field = term.getField();
            logger.debug("SearchTerm name = " + field);
            if (filtername.equals(term.getField()))
                return term;
        }
        return null;
    }



    public void addFilterTerm(SearchTerm term)
    {
        filterTermList.add(term);
        logger.debug("FilterTerm added: " + term);
    }

    public boolean removeFilterTerm(SearchTerm term)
    {
       return (filterTermList != null) ? filterTermList.remove(term) : false;
    }

    public void addFilterTerms(SearchTermList termList)
    {
        filterTermList.addAll(termList);
    }

    public SearchTermList getFilterTermList()
    {
        return filterTermList;
    }

    public SearchTerm getFilterTerm(String filtername)
    {
        for (SearchTerm term : filterTermList)
        {
            String field = term.getField();
            logger.debug("FilterTerm name = " + field);
            if (filtername.equals(term.getField()))
                return term;
        }
        return null;
    }

    public SearchTerm getTerm(String filtername)
    {
        for (SearchTerm term : searchTermList)
        {
            String field = term.getField();
            if (filtername.equals(term.getField()))
                return term;
        }
        for (SearchTerm term : filterTermList)
        {
            String field = term.getField();
            if (filtername.equals(term.getField()))
                return term;
        }
        return null;
    }


    public SearchTermList getAllTermsList()
    {
        SearchTermList sl  = new SearchTermList();
        sl.addAll(searchTermList);
        sl.addAll(filterTermList);
        return sl;
    }

    public String toText()
    {
        StringBuilder sb = new StringBuilder();
        sb.append("\nSolrResult (ver.").append(version).append("\n");
        sb.append("\nstatus........: ").append(status);
        sb.append("\nQTime.........: ").append(qTime);
        sb.append("\nfacet.........: ").append(facet);
        sb.append("\nfacetMinCount.: ").append(facetMinCount);
        sb.append("\nfacetLimit....: ").append(facetLimit);
        sb.append("\nrequestStart..: ").append(requestStart);
        sb.append("\nrows..........: ").append(rows);
        sb.append("\nquery.........: ").append(query);
        sb.append("\nqueryOp.......: ").append(queryOp);
        sb.append("\nstart.........: ").append(start);
        sb.append("\nnumFound......: ").append(numFound);
        sb.append("\nmaxScore......: ").append(maxScore);
        sb.append("\nFieldList:\n");
        for (String fld: fieldList)
        {
            sb.append("\n\t").append(fld);
        }

        sb.append("\nFacetFields:");
        for (String fc: facetFields)
        {
            sb.append("\n\t").append(fc);
        }

        sb.append("\nFacetQueries:");

        for (String fq: facetQueries)
        {
            sb.append("\n\t").append(fq);
        }

        sb.append("\nDocuments:");
        for (SolrResultDocument doc: documents)
        {
            sb.append("\n").append(doc.toStringBuilder());
        }

        sb.append("\nFacets:");
        for (FacetInfo fc: facetInfos)
        {
            sb.append("\n").append(fc.toStringBuilder());
        }

        return sb.toString();
    }

    public void addFacetInfo(FacetInfo facetInfo)
    {
       facetInfos.add(facetInfo);
    }


    public int getLastDayCount()
    {
        return lastDayCount;
    }

    public int getLast3DayCount()
    {
        return last3DayCount;
    }

    public int getLastWeekCount()
    {
        return lastWeekCount;
    }

    public int getLastMonthCount()
    {
        return lastMonthCount;
    }


    public void setLastDayCount(int count)
    {
        lastDayCount = count;
    }

    public void setLast3DayCount(int count)
    {
        last3DayCount = count;
    }

    public void setLastWeekCount(int count)
    {
        lastWeekCount = count;
    }

    public void setLastMonthCount(int count)
    {
        lastMonthCount = count;
    }

    /////////////////////   protected methods   ///////////////////////////////


    protected void addFacetField(String value)
    {
        facetFields.add(value);
    }

     // datapub_ts:[1304287200 TO 1304430871]
    protected void addFacetQuery(String value)
    {
        facetQueries.add(value);
    }


    protected void setHeaderAttribute(String name, String value)
    {
        if (name.equals("status"))
            setStatus(value);
        else
        if (name.equals("QTime"))
            setQTime(value);
        else
           throw new UnsupportedOperationException("Not yet implemented: [" + name + "=" + value + "]");
    }

    protected void setResultAttribute(String name, String value)
    {
        if (name.equals("numFound"))
            setNumFound(value);
        else
        if (name.equals("start"))
            setStart(value);
        else
        if (name.equals("maxScore"))
            setMaxScore(value);
        else
        if (name.equals("name"))
            ;
        else
           throw new UnsupportedOperationException("Not yet implemented: [" + name + "=" + value + "]");
    }


    protected void setHeaderParameter(String name, String value)
    {
        if      (name.equals("facet"))   setFacet(value);
        else if (name.equals("fl"))      setFieldList(value);
        else if (name.equals("start"))   setRequestStart(value);
        else if (name.equals("rows"))    setRows(value);
        else if (name.equals("sort"))    setSort(value);
        else if (name.equals("version")) setVersion(value);
        else if (name.equals("q"))       addQuery(value);
        else if (name.equals("q.op"))    setQueryOp(value);
        else if (name.equals("fq"))      addFilterQuery(value);
        else if (name.equals("facet.limit"))    setFacetLimit(value);
        else if (name.equals("facet.mincount")) setFacetMincount(value);
        else
           throw new UnsupportedOperationException("Not yet implemented: [" + name + "=" + value + "]");
    }


    protected void addDocument(SolrResultDocument doc)
    {
       documents.add(doc);
    }


    /////////////////////   private methods   /////////////////////////////////

    private void setStatus(String value)
    {
        int st = Integer.parseInt(value);
        switch (st)
        {
           case STATUS_OK:
           case STATUS_BADQUERY:
              status = st;
              break;
           default:
              logger.info("Solr status (non gestito): " + value);
              status = STATUS_ERROR;
        }
    }

    private void setQTime(String value)
    {
        qTime = Long.parseLong(value);
    }

    private void setFacet(String value)
    {
        facet = Boolean.parseBoolean(value);
    }

    private void setFieldList(String value)
    {
        fieldList = value.split(",");
    }

    private void setFacetMincount(String value)
    {
        facetMinCount = Integer.parseInt(value);
    }

    private void setFacetLimit(String value)
    {
        facetLimit = Integer.parseInt(value);
    }

    private void setRequestStart(String value)
    {
        requestStart = Integer.parseInt(value);
    }

    private void setVersion(String value)
    {
        version = value;
    }

    private void setRows(String value)
    {
        rows = Integer.parseInt(value);
    }

    private void setSort(String value)
    {
        sort = value;
    }

    private void setQuery(String value)
    {
        query = value;
    }

    private void setQueryOp(String value)
    {
        queryOp = value;
    }

    private void setNumFound(String value)
    {
        numFound = Integer.parseInt(value);
    }

    private void setStart(String value)
    {
        start = Integer.parseInt(value);
    }

    private void setMaxScore(String value)
    {
        maxScore = Double.parseDouble(value);
    }

    void addFilterQuery(String value)
    {
       /*
        if ((value == null) || value.equals(""))
            return;
        String filter[] = value.split(":");
        filterTermList.add(new SearchTerm(filter[0],filter[1]));
        logger.debug("Added FilterQuery: " + filter[0] + " = " + filter[1]);
        */
        filterTermList.addAll(extractTerms(value, defaultField));
    }

    void addQuery(String value)
    {
        if ((value == null) || value.equals(""))
            return;
        String filter[] = value.split(":");
        searchTermList.add(new SearchTerm(filter[0],filter[1]));
        logger.debug("Added Query: " + filter[0] + " = " + filter[1]);
    }


    private ArrayList<SearchTerm> extractTerms(String queryString, String defaultField)
    {
      logger.debug("terms = " + queryString);

      ArrayList<SearchTerm> list = new ArrayList<SearchTerm>();
      if (queryString.indexOf(":") == queryString.lastIndexOf(":"))
      {
        String filter[] = queryString.split(":");
        filterTermList.add(new SearchTerm(filter[0],filter[1]));
        return list;
      }

      QueryParser queryParser = new QueryParser(Version.LUCENE_33,defaultField,
                                       new StandardAnalyzer(Version.LUCENE_33));
      try
      {
         Query qry = queryParser.parse(queryString);
         String clName = qry.getClass().getName();
         logger.debug("query type: " + clName);
         if (clName.equals("org.apache.lucene.search.BooleanQuery"))
         {
            for (BooleanClause cl : ((BooleanQuery)qry).getClauses())
            {
               String s = cl.toString();
               list.add(new SearchTerm(s));
            }
         }
      }
      catch (ParseException ex)
      {
      }
      return list;
    }


}//class//
