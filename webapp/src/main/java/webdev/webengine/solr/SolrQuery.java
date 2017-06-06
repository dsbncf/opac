/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package webdev.webengine.solr;

import java.util.ArrayList;
import java.net.URLEncoder;


/**
 *
 * @author ds
 */
public class SolrQuery
{
   // la lista dei fields secondo quali ordinare il risultato
   protected static final String[] defaultOrderBy = { "visibilita", "data_pub", "priorita", "score" };

   protected int rows = 20;
   protected int start = 0;
   protected int facetMinCount = 1;
   protected int facetLimit = 10;
   protected boolean facetEnabled = false;
   protected String operator = "OR";
   protected String responseFields = "score,*";

   protected ArrayList<String> facetFields = null;
   protected ArrayList<SearchTerm> searchTerms = null;
   protected String orderBy[] = null;

   protected String queryString = null;



   // --------------------------------------------

   public SolrQuery()
   {
      //
   }

   public SolrQuery(String operator)
   {
      setOperator(operator);
   }


   // --------------------------------------------

   public boolean isValid()
   {
      return ((searchTerms != null) && (searchTerms.size() > 0));
   }


   public void setReturnFields(String fields)
   {
      this.responseFields = fields;
   }
   public String getReturnFields()
   {
      return responseFields;
   }


   public void setFacet(boolean flag)
   {
      this.facetEnabled = flag;
   }
   public boolean isFacet()
   {
       return facetEnabled;
   }


   public void setFacetMinCount(int val)
   {
      this.facetMinCount = val;
   }
   public int getFacetMinCount()
   {
       return facetMinCount;
   }


   public void setFacetLimit(int val)
   {
      this.facetLimit = val;
   }
   public int getFacetLimit()
   {
       return facetLimit;
   }

   public void setStart(int val)
   {
      this.start = val;
   }
   public int getStart()
   {
       return start;
   }


   public void setRows(int val)
   {
      this.rows = val;
   }
   public int getRows()
   {
       return rows;
   }

   public void addFacetField(String str)
   {
      if (facetFields == null)
         facetFields = new ArrayList<String>();
      facetFields.add(str);
   }


   public void addSearchTerm(SearchTerm term)
   {
      if (searchTerms == null)
         searchTerms = new ArrayList<SearchTerm>();
      searchTerms.add(term);
   }


   public final void setOperator(String str)
   {
      if (str == null)
         return;
      String op = str.toUpperCase();

      if (op.equals("AND") || op.equals("OR"))
         this.operator = op;
   }

   public void setQueryString(String querystring)
   {
      this.queryString = querystring;
   }

   /**
    * Costruisce la query string per il metodo GET.
    * @return
    * @throws Exception
    *
    * @TODO: URL-encoding dei valori dei searchterm, ottimizzazione con il param fq=.
    */
   public String getQueryString() throws Exception
   {
      if (queryString != null)
         return queryString;

      if (searchTerms == null)
         throw new Exception("Nessun termine di ricerca specificato");

      StringBuilder query = new StringBuilder();

      query.append("fl=").append(responseFields);
      query.append("&q.op=").append(operator);
      query.append("&start=").append(start);
      query.append("&rows=").append(rows);

      if (orderBy != null)
      {
         StringBuilder sort = new StringBuilder();
         for (String ord : orderBy)
         {
            if (sort.length() > 0)
               sort.append(",");
            sort.append(ord).append("+desc");
         }
         if (sort.length() > 0)
            query.append("&sort=").append(sort);
      }

      if (facetEnabled)
      {
          query.append("&facet=").append(facetEnabled);
          query.append("&facet.mincount=").append(facetMinCount);
          query.append("&facet.limit=").append(facetLimit);
          for (String facet : facetFields)
             query.append("&facet.field=").append(facet);
      }

      int count = 0;
      for (SearchTerm term : searchTerms)
      {
         query.append((count++ == 0) ? "&q=" : "+");
         query.append(term.getField()).append(":");
         query.append(URLEncoder.encode(term.getValue(),"UTF-8"));
      }
      return query.toString();
   }

   /**
    * imposta l'ordine dei records nel risultato.
    * Per ora imposta la sort direction per ogni attributo a desc.
    *
    * TODO:  gestire sort direction (asc,desc)
    *
    * @param arr lista degli attributi per i quali va ordinato il risultato
    */
   public void setOrderBy(String[] arr)
   {
      this.orderBy = arr;
   }

   public void setDefautlOrderBy()
   {
      this.orderBy = defaultOrderBy;
   }


}//class//
