
package bncf.solr;

import org.apache.solr.client.solrj.SolrQuery;
import org.apache.solr.client.solrj.SolrServer;
import org.apache.solr.client.solrj.SolrServerException;
import org.apache.solr.client.solrj.impl.ConcurrentUpdateSolrServer;
import org.apache.solr.client.solrj.request.ContentStreamUpdateRequest;
import org.apache.solr.client.solrj.request.UpdateRequest;
import org.apache.solr.client.solrj.response.QueryResponse;
import org.apache.solr.common.SolrDocumentList;
import org.apache.solr.common.params.ModifiableSolrParams;
import org.apache.solr.common.util.NamedList;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.io.File;
import java.io.IOException;
import org.apache.solr.client.solrj.request.AbstractUpdateRequest;
import org.apache.solr.client.solrj.request.AbstractUpdateRequest.ACTION;


public class SolrClient
{
   private static final Logger logger = LoggerFactory.getLogger(SolrClient.class);

   private SolrServer solrServer = null;



  /**
   * Default Constructor.
   * @param serverUrl Url of solr server
   */
  public SolrClient(String serverUrl)
  {
     solrServer = SolrServerManager.getSolrServer(serverUrl);
  }


  public SolrDocumentList doQuery(SolrQuery query) throws SolrServerException
  {
     QueryResponse rsp = solrServer.query( query );
     return rsp.getResults();
  }


   /**
    *
    * @param file
    * @return status (0 means Ok)
    * @throws IOException
    * @throws SolrServerException
    */
   public Integer streamUpdate(File file) throws IOException, SolrServerException
  {
     if (!file.exists()) {
        throw new IOException("file not found: " + file.getPath());
     }
     ContentStreamUpdateRequest req = new ContentStreamUpdateRequest("/update");
     req.addFile(file, "application/xml");
     // req.setAction(AbstractUpdateRequest.ACTION.COMMIT, true, true);
     req.setAction(ACTION.OPTIMIZE, true, true);
     NamedList<Object> result = solrServer.request(req);
     @SuppressWarnings("unchecked")
     NamedList<Object> hdr = (NamedList<Object>) result.get("responseHeader");
     return (Integer) hdr.get("status");
  }

   
   public void commit() throws SolrServerException, IOException
   {
      solrServer.commit();
   }

   public void optimize() throws SolrServerException, IOException
   {
      solrServer.optimize();
   }
   

} //class//
