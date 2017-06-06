
package bncf.opac.handler;


import bncf.opac.util.HttpUtils;

import java.io.IOException;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;



 /**
  *Handler per la interrogazione SOL (database sebina).
  */

public class SebinaHandler extends Handler
{
   private static final Logger logger = LoggerFactory.getLogger(SebinaHandler.class);

   private String sebinaHost = null;
   private String sebinaURI = null;
   private String sebinaPort;
   private int connectionTimeout = 20000;


   public SebinaHandler(String host, String port, String uri)
   {
      sebinaHost = host;
      sebinaPort = port;
      sebinaURI = uri;
   }


  public String getAbbonamento(String bibcod, String abbo)
  {
     logger.debug("SOL abbonamento = " + bibcod + "-" + abbo);
     String doc = null;
     try
     {
        doc = requestInfo(composeRequestXML(bibcod.toUpperCase(), abbo));
     }
     catch (Exception ex)
     {
        logger.error(ex.getMessage(), ex);
     }
     return doc;
  }


   public String getAnnata(String idannata)
   {
      logger.debug("SOL annata = " + idannata);
      String doc = null;
      try
      {
         doc = requestInfo(composeRequestXML(idannata));
      }
      catch (Exception ex)
      {
         logger.error(ex.getMessage(), ex);
      }
      return doc;
   }

   
   private String getSebinaUri()
   {
      StringBuilder uri = new StringBuilder("http://");
      uri.append(sebinaHost);
      uri.append(":").append(sebinaPort);
      uri.append(sebinaURI);
      return uri.toString();
   }
   
   
   public void setTimeout(int timeout)
   {
      this.connectionTimeout = timeout;
   }

   
   private String requestInfo(String req) throws IOException
   {
      return HttpUtils.postXml(getSebinaUri(), req);
   }

   /*
  private String requestInfo(String req) throws IOException
  {
    StringBuilder requesturl = new StringBuilder("http://");
    requesturl.append(sebinaHost);
    requesturl.append(":").append(sebinaPort);
    requesturl.append(sebinaURI);

    PostMethod post = new PostMethod(requesturl.toString());

    logger.debug("SOL request URL = " + requesturl.toString() );
    logger.debug("SOL request = " + req );
    RequestEntity reqentity = new StringRequestEntity(req, "text/xml", "UTF-8");
    post.setRequestEntity(reqentity);
    post.setFollowRedirects(false);

    HttpClient client = new HttpClient();
    client.getHttpConnectionManager().getParams().setConnectionTimeout(connectionTimeout);

    String response = null;
    try
    {
       int rc = client.executeMethod(post);
       logger.debug("SOL request return code = " + rc );
       if (rc != 200)
           logger.info(post.getStatusText());
       else
           response = post.getResponseBodyAsString();
    }
    finally
    {
       post.releaseConnection();
    }
    logger.info("SOL request response = " + response );
    return response;
  }
*/


  private String composeRequestXML(String bibcod, String abbo)
  {
    StringBuilder req = new StringBuilder("<?xml version=\"1.0\" encoding=\"UTF-8\"?>");
    req.append("<MServDoc xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" ");
    req.append("xsi:noNamespaceSchemaLocation=\"picos_sbn.xsd\">");

    req.append("<askfasc><xabbfas kbibl=\"").append(bibcod);
    req.append("\" kordi=\"").append(abbo).append("\"/></askfasc>");

    req.append("</MServDoc>");
    return req.toString();
  }


  private String composeRequestXML(String idannata)
  {
    StringBuilder req = new StringBuilder("<?xml version=\"1.0\" encoding=\"UTF-8\"?>");
    req.append("<MServDoc xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" ");
    req.append("xsi:noNamespaceSchemaLocation=\"picos_sbn.xsd\">");

    req.append("<askfasc><idannata>").append(idannata).append("</idannata></askfasc>");

    req.append("</MServDoc>");
    return req.toString();
  }

  
} //class//


/*
#$post_string = '<?xml version="1.0" encoding="UTF-8" ?> <MServDoc xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:noNamespaceSchemaLocation="picos_sbn.xsd"> <askdoc> <xinv  kbibl="CF" kinv="5220902"/> </askdoc> </MServDoc>';
#$post_string = '<?xml version="1.0" encoding="UTF-8" ?> <MServDoc xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:noNamespaceSchemaLocation="picos_sbn.xsd"> <askdoc> <xabb kbibl="CF" kordi="D61199" kanno="2004"/> </askdoc> </MServDoc>';
#$post_string = '<?xml version="1.0" encoding="UTF-8" ?> <MServDoc xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:noNamespaceSchemaLocation="picos_sbn.xsd"> <askdoc xbid="CFVIA0048998"/> </MServDoc>';
#$post_string = '<?xml version="1.0" encoding="UTF-8" ?> <MServDoc xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:noNamespaceSchemaLocation="picos_sbn.xsd"> <askinv kbibl="CF" kordi="CFF59933" kanno="2005" tipomat="VP" tipocirc="Q" precis="1991-2002" valore="1000" flacoll="false" consisDoc="" annoBil="" tipoPrezzo="R"/> </MServDoc>';
#$post_string = '<?xml version="1.0" encoding="UTF-8" ?> <MServDoc xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:noNamespaceSchemaLocation="picos_sbn.xsd"> <askinv kbibl="CF" kordi="CFC02013" kanno="2007" tipomat="VP" tipocirc="Q" precis="2007" valore="1000" flacoll="true" consisDoc="1990-2007" annoBil="" tipoPrezzo="R" prezzoBil=""/> </MServDoc>';
#$post_string = '<?xml version="1.0" encoding="UTF-8" ?> <MServDoc xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:noNamespaceSchemaLocation="picos_sbn.xsd"> <askdoc> <xabb kbibl="CF" kordi="C30217" kanno="1994"/> </askdoc> </MServDoc>';
*/


