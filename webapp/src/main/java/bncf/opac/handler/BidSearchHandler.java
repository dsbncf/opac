
package bncf.opac.handler;


import bncf.opac.util.HttpUtils;

import java.io.IOException;
import java.io.StringReader;
import java.io.StringWriter;
import java.io.UnsupportedEncodingException;

import java.net.URLEncoder;

import java.text.SimpleDateFormat;

import java.util.Locale;
import java.util.TimeZone;

import javax.servlet.ServletException;

import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.parsers.ParserConfigurationException;

/*
import org.apache.commons.httpclient.HttpClient;
import org.apache.commons.httpclient.HttpException;
import org.apache.commons.httpclient.HttpStatus;
import org.apache.commons.httpclient.methods.GetMethod;
*/

import org.w3c.dom.Document;
import org.w3c.dom.Element;
import org.w3c.dom.NodeList;
import org.xml.sax.InputSource;
import org.xml.sax.SAXException;

import javax.xml.transform.*;
import javax.xml.transform.dom.*;
import javax.xml.transform.stream.*;


// Solr query parsing
import javax.xml.xpath.XPath;
import javax.xml.xpath.XPathConstants;
import javax.xml.xpath.XPathExpressionException;
import javax.xml.xpath.XPathFactory;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;





/**
 * Questa servlet carica il record bibliografico da solr.
 */


public class BidSearchHandler
{
    private static SimpleDateFormat formatter = new SimpleDateFormat("dd/MM/yyyy");
    private static SimpleDateFormat solrFormatter =
                                 new SimpleDateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS", Locale.US);
    public static TimeZone UTC = TimeZone.getTimeZone("UTC");

    private final static String IDN = "idn";

    private String    solrLocation = null;
    private String    bid = null;
    private Document  document = null;
    private Document  record   = null;
    private String    querystring  = null;

    private String titolo  = null;
    private String autore  = null;
    private String annopub = null;
    private String idn     = null;


    private DocumentBuilderFactory docFactory = DocumentBuilderFactory.newInstance();
    private Logger  logger = LoggerFactory.getLogger(BidSearchHandler.class);



    /**
     * Constructor
     *
     * @param  location of Solr search engine.
     */

    public BidSearchHandler(String solrLocation)
    {
        this.solrLocation = solrLocation;
        solrFormatter.setTimeZone(UTC);
    }

    public BidSearchHandler(String solrLocation, String bid)
    {
       this(solrLocation);
       this.bid = bid;
    }


    public void setBid(String bid)
    {
         this.bid = bid;
    }


    public String getTitolo()
    {
       return this.titolo;
    }

    public void setTitolo(String str)
    {
       this.titolo = str.replaceAll("|","");
    }


    public String getAutore()
    {
       return this.autore;
    }

    public void setAutore(String str)
    {
       this.autore = str;
    }


    public String getAnnopub()
    {
       return this.annopub;
    }

    public void setAnnopub(String str)
    {
       this.annopub = str;
    }

    public String getIdn()
    {
       return this.idn;
    }

    public void setIdn(String str)
    {
      this.idn = str;
    }


    public Document getRecord()
    {
       return this.record;
    }


    public Document getResultDoc()
    {
       return this.document;
    }


   public String getResultXML()
   {
      String res = null;
      if (document != null)
      {
	 try
	 {
	    DOMSource domSource = new DOMSource(document);
	    StringWriter writer = new StringWriter();
	    StreamResult result = new StreamResult(writer);
	    TransformerFactory tf = TransformerFactory.newInstance();
	    Transformer transformer = tf.newTransformer();
	    transformer.transform(domSource, result);
	    res = writer.toString();
	 }
	 catch (TransformerException ex)
	 {
	    logger.info(null, ex);
	 }
      }
      return res;
   }


    public String getQueryString()
    {
       return (querystring == null) ? null : querystring.toString();
    }



    /**
     * Processes the search request.
     *
     * @param request
     * @param response
     * @throws ServletException
     * @throws IOException
     */
   public void runSearch() throws SearchHandlerException
   {
      try
      {
	 this.querystring = buildSolrQuery();
	 logger.debug("Query: " + querystring);

	 if (querystring != null)
	    processSubmitQuery(querystring);
      }
      catch (Exception ex)
      {
	 throw new SearchHandlerException(ex);
      }
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
     * Request parameters:
     *   sf : search-field  - Field name to search on
     *   sv : search-value  - search input value
     *
     * @param request
     *
     * @throws ServletException
     * @throws UnsupportedEncodingException
     *
     */
   private String buildSolrQuery() throws UnsupportedEncodingException
   {
      StringBuilder query = new StringBuilder("fl=*&q=");

      if (bid != null)
      {
	 query.append(IDN).append(":").append(URLEncoder.encode(bid, "UTF-8"));
	 query.append("&start=0");
	 query.append("&rows=1");
      }
      return (query.length() > 0) ? query.toString() : null;
   }


    /**
     * Submit a {@link #sendSolrGetCommand(String,String)}, parse into DOM.
     *
     * @param query
     *
     * @throws IOException
     * @throws ParserConfigurationException
     * @throws SAXException
     */
   private void processSubmitQuery(String query)
                 throws IOException, ParserConfigurationException, SAXException
   {
      String results = sendSolrGetCommand(query, solrLocation + "/select/");
      // logger.debug("XML=" + results);

      DocumentBuilder documentBuilder = docFactory.newDocumentBuilder();
      document = documentBuilder.parse(
	  new InputSource(new StringReader(results)));
      // record = getEmbeddedXML(document);
      extractData(document);
   }


    /**
     * Extract the embedded XML, convert to DOM
     *
     * @param doc The XML Document
     * @return
     *
     * @throws IOException
     * @throws ParserConfigurationException
     * @throws SAXException
     */

   private Document getEmbeddedXML(Document document)
                       throws  IOException, ParserConfigurationException, SAXException
   {
       if (document == null)
          return null;

       NodeList docList = document.getElementsByTagName("doc");
       if (docList == null)
          return null;

       Document xmldoc = null;

       // take only the first "doc"
       int llen = docList.getLength();
       if (llen == 0)
          return null;

       for (int i = 0 ; i < 1 ; ++i)
       {
           Element doc = (Element) docList.item(i);
           NodeList strList = doc.getElementsByTagName("str");
           if (strList == null && strList.getLength() < 1)
              continue;

           // loop over tag "str"
           int last = strList.getLength() - 1;
           for (int j = last ; j >= 0 ; --j)
           {
               Element str = (Element) strList.item(j);
               String name = str.getAttribute("name");
               if (name != null && name.equals("xml"))
               {
                   String xml = str.getTextContent();
                   DocumentBuilder documentBuilder = docFactory.newDocumentBuilder();
                   xmldoc = documentBuilder.parse(new InputSource(new StringReader(xml)));
                   if (xmldoc != null)
                   {
                      doc.replaceChild(document.importNode(xmldoc.getFirstChild(),true),str);
                      break;
                   }
               }
           }
       }
       return xmldoc;
    }


   private void extractData(Document document)
                       throws  IOException, ParserConfigurationException, SAXException
   {
       if (document == null)
          return;

       NodeList docList = document.getElementsByTagName("doc");
       if (docList == null)
          return;

       // take only the first "doc"
       int llen = docList.getLength();
       if (llen == 0)
          return;

       Element doc = (Element) docList.item(0);
       NodeList strList = doc.getElementsByTagName("str");
       if ((strList == null) && (strList.getLength() < 1))
              return;

       // loop over tag "str"
       int last = strList.getLength() - 1;
       for (int j = last ; j >= 0 ; --j)
       {
          Element str = (Element) strList.item(j);
          String name = str.getAttribute("name");
          if (name != null)
          {
             if (name.equals("xml"))
                record = xmlToDom(doc,str);
             else
               if (name.equals("autore_dp"))
                  setAutore(str.getTextContent());
             else
               if (name.equals("titolo_dp"))
                  setTitolo(str.getTextContent());
             else
               if (name.equals("idn"))
                  setIdn(str.getTextContent());
          }
       }

       NodeList intList = doc.getElementsByTagName("int");
       if ((intList == null) && (intList.getLength() < 1))
              return;

       // loop over tag "int"
       last = intList.getLength() - 1;
       for (int j = last ; j >= 0 ; --j)
       {
          Element elm = (Element) intList.item(j);
          String name = elm.getAttribute("name");
          if (name != null)
          {
             if (name.equals("anno1"))
             {
                setAnnopub(elm.getTextContent());
                break;
             }
          }
       }
    }


   private void extractRecord(Document document)
   {
      if (document == null)
	 return;

      String qpath = "/response/result/doc";
      String res = null;
      XPathFactory factory = XPathFactory.newInstance();
      XPath xpath = factory.newXPath();
      try
      {
	 res = (String) xpath.compile(qpath).evaluate(document, XPathConstants.STRING);
      }
      catch (XPathExpressionException ex)
      {
	 logger.info(ex.getMessage());
      }
   }


    private Document xmlToDom(Element doc, Element elem)
	        throws ParserConfigurationException, SAXException, IOException
    {
       String xml = elem.getTextContent();
       DocumentBuilder documentBuilder = docFactory.newDocumentBuilder();
       Document xmldoc = documentBuilder.parse(new InputSource(new StringReader(xml)));
       if (xmldoc != null)
          doc.replaceChild(document.importNode(xmldoc.getFirstChild(),true),elem);
       return xmldoc;
    }


   /**
    * Send the command to Solr using a GET
    *
    * @param queryString
    * @param url
    * @return
    * @throws IOException
    */
   private String sendSolrGetCommand(String queryString, String url) throws IOException
   {
      String requrl = url + "?" + queryString;
      logger.debug("Sending GET request: {}", requrl);
      String resultXml = HttpUtils.get(requrl);
      logger.debug("Response: {}", resultXml);
      return resultXml;
   }
   
   
} //class//

