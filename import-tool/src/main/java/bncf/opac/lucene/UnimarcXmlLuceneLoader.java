

package bncf.opac.lucene;


import java.io.*;
import java.sql.Connection;
import java.sql.PreparedStatement;

import org.apache.commons.digester.Digester;
import org.apache.commons.digester.NodeCreateRule;
import org.apache.lucene.document.Document;
import org.apache.lucene.document.Field;
import org.apache.lucene.analysis.standard.StandardAnalyzer;
import org.apache.lucene.index.IndexWriter;

import org.apache.lucene.index.IndexWriterConfig;
import org.apache.lucene.store.Directory;
import org.apache.lucene.store.NIOFSDirectory;
import org.apache.lucene.util.Version;
import org.w3c.dom.Node;
import org.w3c.dom.NodeList;
import org.w3c.dom.*;

import javax.xml.transform.*;
import javax.xml.transform.dom.*;
import javax.xml.transform.stream.*;



/** Carica i records estratti dal file xml nel database opac.
 *
 * @author  ds@webdev.it
 * @version $Revision: $
 *
 * Utilizza il Digester di Apache
 */

public class UnimarcXmlLuceneLoader
{
  private InputStream inps   = null;
  private PrintWriter writer = null;
  private Digester digester  = null;
  private Connection conn    = null;
  private PreparedStatement pstmt = null;
  private PreparedStatement qstmt = null;
  private PreparedStatement istmt = null;
  private PreparedStatement ustmt = null;
  private IndexWriter index = null;
  private boolean verbose = false;

 
 public UnimarcXmlLuceneLoader()
 {
   writer = new PrintWriter(System.out, true);
 }

 public void setVerbose(boolean flag)
 {
   this.verbose = flag;
 }
 public boolean getVerbose()
 {
   return this.verbose;
 }

 public void openIndex(String indexpath, boolean flag_create) throws IOException
 {
    Directory dir = new NIOFSDirectory(new File(indexpath));
    IndexWriterConfig conf = new IndexWriterConfig(Version.LUCENE_36, new StandardAnalyzer(Version.LUCENE_36));
    conf.setOpenMode(IndexWriterConfig.OpenMode.CREATE_OR_APPEND);
    new IndexWriter(dir, conf);
    index.setUseCompoundFile(false);
 }

 public void closeIndex(boolean flag_optimize) throws IOException
 {
    if (flag_optimize)
        index.optimize();
    index.close();
 }

 private void indexRecord(String idn, String unimarc) throws IOException
 {
      Document doc = new Document();
      doc.add( new Field("idn", idn, Field.Store.YES, Field.Index.NOT_ANALYZED) );
      doc.add( new Field("unimarc", unimarc, Field.Store.YES, Field.Index.NO) );
      index.addDocument(doc);
 }
                                                                                                              

 public void optimize() throws IOException
 {
      index.optimize();
 }

 
 private String nodeToString(Node node)
 {
    try
    {
       Source source = new DOMSource(node);
       StringWriter stringWriter = new StringWriter();
       Result result = new StreamResult(stringWriter);
       TransformerFactory factory = TransformerFactory.newInstance();
       Transformer transformer = factory.newTransformer();
       transformer.transform(source, result);
       return stringWriter.getBuffer().toString();
    }
    catch (TransformerConfigurationException e)
    {
         e.printStackTrace();
    }
    catch (TransformerException e)
    {
         e.printStackTrace();
    }
    return null;
 }


 public void saveRecord(Object obj)
 {
   if (obj == null)
   {
     System.err.println("saveRecord: <null>");
     return;
   }
   Node  node = (Node) obj;
   String bid = getBid(node);

   if (bid == null)
   {
     System.err.println("IDN is null.");
     return;
   }
   bid = bid.toLowerCase();

   String xml = nodeToString(node);

   if (index != null)
   {
     if (verbose) System.out.println(bid);
     try
     {
       System.err.println("unimarc: " + bid );
       indexRecord(bid,xml);
     }
     catch (Exception ex)
     {
       System.err.println("\nErrori durante la indicizzazione del record (bid=" + bid + "): "
                           + ex.getMessage());
       System.exit(1);
     }
   }
   else
   {
     System.out.println("<?xml version=\"1.0\" encoding=\"UTF-8\"?>");
     System.out.println( xml + "\n");
     System.out.flush();
   }
 }


 public void loadFromStream( InputStream inp, boolean usedb )
 {
   if (inp == null)
     return;

   inps = inp;

   digester = new Digester();
   digester.push(this);

   try
   {
     digester.addRule( "collection/rec", new NodeCreateRule(Node.ELEMENT_NODE) );

     if (usedb)
        digester.addSetRoot( "collection/rec", "saveRecord" );
     else
        digester.addSetRoot( "collection/rec", "checkRecord" );

     digester.parse(inp);
   }
   catch (IOException ex)
   {
     System.err.println("impossibile leggere il file xml: " + ex.getMessage());
   }
   catch (org.xml.sax.SAXException ex)
   {
     System.err.println("Errori di formato nel file xml: " + ex.getMessage());
   }
   catch (javax.xml.parsers.ParserConfigurationException ex)
   {
     System.err.println("Errori di configurazione del parser XML: " + ex.getMessage());
   }
 }
 
 public void checkRecord(Object obj)
 {
   if (obj == null)
   {
     System.err.println("checkRecord: -");
     return;
   }

   Node node = (Node) obj;

   String bid = getBid(node);

   System.out.println( bid );
   System.out.flush();
   System.out.println(node.toString());

   digester.pop();
 }



 public String getBid(Node node)
 {
   String bid = null;
   NodeList nl = node.getChildNodes();
   int len = nl.getLength();
   for (int k = 0 ; k < len; ++k )
   {
     Node nd = nl.item(k);
     if ( nd.getNodeName().equals("cf") )
     {
       if ( nd.hasAttributes() )
       {
         Node ni = nd.getAttributes().getNamedItem("t");
         if (ni != null)
         {
            if ( ni.getNodeValue().equals("001") )
            {
              NodeList tnds = nd.getChildNodes();
              int tnl = tnds.getLength();
              bid = "";
              for (int m = 0 ; m < tnl; ++m )
              {
                Node tn = tnds.item(m);
                bid += tn.getNodeValue();
              }
              return bid;
            }
         }
       }
     }
   }
   return null;
 }


} // class //

