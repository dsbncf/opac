
package bncf.solr;

import org.apache.solr.client.solrj.SolrServer;
import org.apache.solr.client.solrj.impl.HttpSolrServer;
import org.apache.solr.client.solrj.impl.XMLResponseParser;

import java.util.HashMap;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public class SolrServerManager
{
   private static final Logger logger = LoggerFactory.getLogger(SolrServerManager.class);
   
   private static final HashMap<String,SolrServer> serverMap = new HashMap<>();

  private SolrServerManager()
  {
    // Constructor not available;
  }

  public static SolrServer getSolrServer(String url)
  {
     SolrServer server;
     if (serverMap.containsKey(url))
        server = serverMap.get(url);
     else
     {
        server = newHttpSolrServer(url);
        serverMap.put(url, server);
     }
     return server;
  }

  private static HttpSolrServer newHttpSolrServer(String url)
  {
      HttpSolrServer srv = new HttpSolrServer(url);
      logger.debug("Configuring SolrServer URL: {}", url);
      srv.setMaxRetries(1); // defaults to 0.  > 1 not recommended.
      srv.setConnectionTimeout(5000); // 5 seconds to establish TCP
      // Setting the XML response parser is only required for cross
      // version compatibility and only when one side is 1.4.1 or
      // earlier and the other side is 3.1 or later.
      //srv.setParser(new XMLResponseParser()); // binary parser is used by default
      return srv;
  }

} //class//
