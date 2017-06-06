
package bncf.opac.util;

import org.apache.commons.io.IOUtils;
import org.apache.http.Consts;
import org.apache.http.HttpEntity;
import org.apache.http.StatusLine;
import org.apache.http.client.methods.CloseableHttpResponse;
import org.apache.http.client.methods.HttpGet;
import org.apache.http.client.methods.HttpPost;
import org.apache.http.entity.ContentType;
import org.apache.http.entity.StringEntity;
import org.apache.http.impl.client.CloseableHttpClient;
import org.apache.http.impl.client.HttpClients;
import org.apache.http.util.EntityUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.io.IOException;
import java.io.InputStream;

import static org.apache.http.HttpStatus.SC_OK;


public class HttpUtils
{
   private static final Logger logger = LoggerFactory.getLogger(HttpUtils.class);
   private static final String ENCODING = "UTF-8";


   private HttpUtils()
   {
      //
   }

   
   public static String get(String url) throws IOException
   {
      logger.debug("Get request: {}", url);
      CloseableHttpClient httpclient = HttpClients.createDefault();
      HttpGet httpGet = new HttpGet(url);
      httpGet.addHeader("Accept", "text/xml");
      CloseableHttpResponse response1 = httpclient.execute(httpGet);
      // The underlying HTTP connection is still held by the response object
      // to allow the response content to be streamed directly from the network socket.
      // In order to ensure correct deallocation of system resources
      // the user MUST call CloseableHttpResponse#close() from a finally clause.
      // Please note that if response content is not fully consumed the underlying
      // connection cannot be safely re-used and will be shut down and discarded
      // by the connection manager. 
      String body = null;
      try
      {
         StatusLine statusLine = response1.getStatusLine();
         if (statusLine.getStatusCode() != SC_OK)
         {
            logger.error("Method failed: [{}] {}", statusLine.getStatusCode(), 
                                                 statusLine.getReasonPhrase());
         }
         HttpEntity entity1 = response1.getEntity();
         InputStream inps = entity1.getContent();
         body = IOUtils.toString(inps, ENCODING);
         EntityUtils.consume(entity1);
      }
      finally
      {
         response1.close();
      }
      return body;
   }      

   
   /**
    * Post xml text..
    *
    * @param command
    * @param url
    * @return
    * @throws IOException
    */
   public static String postXml(String uri, String content) throws IOException
   {
      CloseableHttpClient httpclient = HttpClients.createDefault();
      HttpPost httpPost = new HttpPost(uri);
      
      // List <NameValuePair> nvps = new ArrayList <NameValuePair>();
      // nvps.add(new BasicNameValuePair("username", "vip"));
      // nvps.add(new BasicNameValuePair("password", "secret"));
      // httpPost.setEntity(new UrlEncodedFormEntity(nvps));
      
      StringEntity strent = new StringEntity(content, ContentType.create("text/xml", Consts.UTF_8));
      strent.setChunked(true);
      httpPost.setEntity(strent);      
      
      CloseableHttpResponse resp = httpclient.execute(httpPost);
      String body = null;
      try
      {
         StatusLine statusLine = resp.getStatusLine();
         if (statusLine.getStatusCode() != SC_OK)
         {
            logger.error("Method failed: " + statusLine.getReasonPhrase());
         }
         HttpEntity entity = resp.getEntity();
         InputStream inps = entity.getContent();
         body = IOUtils.toString(inps, ENCODING);
         EntityUtils.consume(entity);
      }
      finally
      {
         resp.close();
      }
      return body;
   }

   
} //class//
