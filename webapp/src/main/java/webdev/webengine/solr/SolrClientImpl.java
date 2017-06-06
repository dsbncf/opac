
package webdev.webengine.solr;


import bncf.opac.util.HttpUtils;

import java.io.UnsupportedEncodingException;
import java.util.ArrayList;

import javax.xml.stream.XMLInputFactory;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;


public class SolrClientImpl
{
    private static final Logger logger = LoggerFactory.getLogger(SolrClientImpl.class);
    private final XMLInputFactory _xmlInputFactory = XMLInputFactory.newInstance();

    private String solrLocation = null;

    // facets da aggiungere ad ogni query
    private ArrayList<String> queryFacets = new ArrayList<String>();

    public static final String KEYWORDS      = "keywords";
    public static final String CATEGORIA_FC  = "categoria_fc";
    public static final String TITOLO_FC     = "titolo_fc";
    public static final String AZIENDA_FC    = "azienda_fc";
    public static final String REGIONE_FC    = "regione_fc";
    public static final String PROVINCIA_FC  = "provincia_fc";
    public static final String COMUNE_FC     = "comune_fc";
    public static final String CONTRATTO_FC  = "contratto_fc";
    public static final String SALARIO_FC    = "salario_fc";
    public static final String DATAPUB_TS    = "datapub_ts";



/*
    public SolrClientImpl(String solrLocation)
    {
       this.solrLocation = solrLocation;
    }
*/

    public SolrClientImpl(String solrLocation)
    {
      this.solrLocation = solrLocation;
      queryFacets.add(CATEGORIA_FC);
      queryFacets.add(AZIENDA_FC);
      queryFacets.add(REGIONE_FC);
      queryFacets.add(PROVINCIA_FC);
      queryFacets.add(COMUNE_FC);
    }



    public void setSolrLocation(String location)
    {
       this.solrLocation = location;
    }


  private String buildSolrQuery(String keyword) throws  UnsupportedEncodingException
  {
      StringBuilder query = new StringBuilder();
      query.append("fl=*,score&facet=true&facet.mincount=1&facet.limit=20");

      for (String facet: queryFacets)
         if (facet != null)
            query.append("&facet.field=").append(facet);

      query.append("&q.op=AND");
      query.append("&start=0");
      query.append("&rows=20");

      query.append("&q=keywords:").append(keyword);

      query.append("&facet.query=datapub_ts:%5B1304200800+TO+1304332269%5D");
      query.append("&facet.query=datapub_ts:%5B1306360800+TO+1304332269%5D");
      query.append("&facet.query=datapub_ts:%5B1301695200+TO+1304332269%5D");
      query.append("&facet.query=datapub_ts:%5B1299106800+TO+1304332269%5D");

      return query.toString();
  }


    public String runSearch(String keyword) throws Exception
    {
      String querystring = buildSolrQuery(keyword);
      String url = solrLocation + "/select?" + querystring;
      logger.debug("Sending GET request: {}", url);
      String resultXml = HttpUtils.get(url);
      logger.debug("Response: {}", resultXml);
      return resultXml;
    }

    
    
    /**
     * Send the command to Solr using a GET
     *
     * @param queryString
     * @param url
     * @return
     * @throws IOException
     */
/*
    public String sendSolrGetCommand(String url, SolrQuery query) throws Exception
    {
       return sendSolrGetCommand(url, query.getQueryString());
    }
*/

    /**
     * Send the command to Solr using a GET
     *
     * @param queryString
     * @param url
     * @return
     * @throws IOException
     */
/*
    private String sendSolrGetCommand(String url, String queryString) throws IOException
    {
        String results = null;
        HttpClient client = new HttpClient();
        GetMethod  get    = new GetMethod(url);
        String qs = queryString.trim();
        get.setQueryString(qs);

        //client.executeMethod(get);
        try
        {
            // Execute the method.
            int statusCode = client.executeMethod(get);

            if (statusCode != HttpStatus.SC_OK)
            {
                logger.info("Method failed: " + get.getStatusLine());
            }
            results = get.getResponseBodyAsString();
        }
        finally
        {
            // Release the connection.
            get.releaseConnection();
        }
        return results;
    }
*/

    /*
    public String sendGetSelect(SolrQuery solrquery) throws Exception
    {
        String url = solrLocation + "/select";
        String qs = solrquery.getQueryString();

        GetMethod get = new GetMethod(url);
        get.setQueryString(qs.trim());

        String results = null;
        try
        {
            // Execute the GET method.
            HttpClient client = new HttpClient();
            int statusCode = client.executeMethod(get);
            if (statusCode != HttpStatus.SC_OK)
            {
                logger.info("Method failed: " + get.getStatusLine());
            }
            results = get.getResponseBodyAsString();
        }
        catch(Exception ex)
        {
           String msg = ex.getMessage() + ": " + url + " querystring: " + qs;
           throw new Exception(msg,ex);
        }
        finally
        {
            // Release the connection.
            get.releaseConnection();
        }
        return results;
    }
*/

    /**
     * Send the command to Solr using a Post
     *
     * @param command
     * @param url
     * @return
     * @throws IOException
     */
    /*
    private String sendSolrPostCommand(String command, String url)
            throws IOException
    {
        String results = null;
        HttpClient client = new HttpClient();
        PostMethod post = new PostMethod(url);

        StringRequestEntity re = new StringRequestEntity(command, "text/xml", "UTF-8");
        post.setRequestEntity(re);
        try
        {
            // Execute the method.
            int statusCode = client.executeMethod(post);

            if (statusCode != HttpStatus.SC_OK)
            {
                logger.info("Method failed: " + post.getStatusLine());
            }

            // Read the response body.
            byte[] responseBody = post.getResponseBody();

            // Deal with the response.
            // Use caution: ensure correct character encoding and is not binary data
            results = new String(responseBody);
        }
        catch (HttpException e)
        {
            logger.info("Fatal protocol violation: " + e.getMessage(), e);
        }
        catch (IOException e)
        {
            logger.info("Fatal transport error: " + e.getMessage(), e);
        }
        finally
        {
            // Release the connection.
            post.releaseConnection();
        }
        return results;
    }
*/

}//class//
