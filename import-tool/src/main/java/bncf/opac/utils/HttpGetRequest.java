
package bncf.opac.utils;

import org.apache.http.HttpEntity;
import org.apache.http.StatusLine;
import org.apache.http.client.methods.CloseableHttpResponse;
import org.apache.http.client.methods.HttpGet;
import org.apache.http.impl.client.CloseableHttpClient;
import org.apache.http.impl.client.HttpClients;
import org.apache.http.util.EntityUtils;

import java.io.IOException;
import java.io.InputStream;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;


import static org.apache.http.HttpStatus.SC_OK;


public class HttpGetRequest
{
   private static final Logger logger = LoggerFactory.getLogger(HttpGetRequest.class);
   private static final String ENCODING = "UTF-8";

   private final String url;
   private HttpEntity entity = null;
   private CloseableHttpResponse response = null;

   
   public HttpGetRequest(String url)
   {
      this.url = url;
   }
   
   
   public InputStream getResponseStream() throws IOException 
   {
      CloseableHttpClient httpClient = HttpClients.createDefault();
      HttpGet httpGet = new HttpGet(url);
      httpGet.addHeader("Accept", "text/xml");
      response = httpClient.execute(httpGet);
      StatusLine statusLine = response.getStatusLine();
      if (statusLine.getStatusCode() != SC_OK)
      {
         logger.error("Method failed: [{}] {}", statusLine.getStatusCode(), 
                                              statusLine.getReasonPhrase());
      }
      entity = response.getEntity();
      return entity.getContent();
   }

   public void close()
   {
      if (response != null)
      {
         try
         {
            if (entity != null)
               EntityUtils.consume(entity);
            response.close();
         }
         catch (IOException ex)
         {
            logger.error("Could not close response stream", ex);
         }
      }
   }

   
} //class//
