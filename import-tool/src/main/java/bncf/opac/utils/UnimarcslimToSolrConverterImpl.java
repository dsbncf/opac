
/*
 * UnimarcslimToSolrConverterImpl
 *
 * effettua trasformazione da formato unimarcslim in solr-input
 */

package bncf.opac.utils;


import java.io.BufferedReader;
import java.io.ByteArrayInputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.io.OutputStreamWriter;
import java.io.PrintWriter;
import java.io.Reader;
import java.io.StringReader;
import java.io.StringWriter;
import java.io.UnsupportedEncodingException;
import java.io.Writer;

import java.util.Properties;

import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.transform.Transformer;
import javax.xml.transform.TransformerConfigurationException;
import javax.xml.transform.TransformerException;
import javax.xml.transform.TransformerFactory;
import javax.xml.transform.dom.DOMResult;
import javax.xml.transform.dom.DOMSource;
import javax.xml.transform.stream.StreamResult;
import javax.xml.transform.stream.StreamSource;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import org.w3c.dom.Document;
import org.w3c.dom.Element;



/**
 * Classe per la conversione da formato unimarcslim
 * in formato "opacindex" per la indicizzazione delle
 * notize con Lucene.
 */

public class UnimarcslimToSolrConverterImpl
{
   private static final Logger logger = LoggerFactory.getLogger(UnimarcslimToSolrConverterImpl.class);
      
    private final static int TX_NONE    = 0;
    private final static int TX_ADDED   = 1;
    private final static int TX_DELETED = 2;

    private final String outputEncoding = "UTF-8";
    private final String inputEncoding  = "UTF-8";

    private PrintWriter foutAdd = null;
    private PrintWriter foutDel = null;

    private long recordsToAdd = 0;
    private long recordsToDel = 0;
    private long    reccount  = 0;
    private long maxreccount  = 0;

    private TransformerFactory tFactory = null;
    private Transformer transformerAdd = null;
    private Transformer transformerDel = null;
    private Transformer identTransformer = null;
    private DocumentBuilderFactory docbuilderfactory = null;

    private RecordUpdaterSoggetti recupd = null;

   public UnimarcslimToSolrConverterImpl()
   {
      try
      {
         tFactory = TransformerFactory.newInstance();
         identTransformer = tFactory.newTransformer();
         Properties props = new Properties();
         props.setProperty(javax.xml.transform.OutputKeys.OMIT_XML_DECLARATION, "yes");
         identTransformer.setOutputProperties(props);
      }
      catch (TransformerConfigurationException ex)
      {
         logger.error("", ex);
      }
      docbuilderfactory = DocumentBuilderFactory.newInstance();
   }

   
   /**
    * Transform unimarcslim input from file.
    *
    * @param inputfile input file in unimarcslim format.
    *
    * @throws Exception IOException, FileNotFoundException, UnsupportedEncodingException
    */
   public void transform(File inputfile) throws Exception
   {
      transform(new FileInputStream(inputfile));
   }

   public void transform(InputStream inputStream) throws Exception
   {
      init();
      transform(new InputStreamReader(inputStream, inputEncoding));
      close();
   }

   /**
    * Assign istanza di RelazioniSoggetti.
    *
    * @param relsogg
    */
   public void setRelazioniSoggetti(RelazioniSoggetti relsogg)
   {
      recupd = new RecordUpdaterSoggetti(relsogg);
   }


   /**
    * Assign XSLT for transformation of records to add.
    *
    * @param xsltfilename
    */
   public void setXsltForAdd(String xsltfilename)
   {
      try
      {
         transformerAdd = tFactory.newTransformer(new StreamSource(xsltfilename));
      }
      catch (TransformerConfigurationException ex)
      {
         logger.error("Adding transformer: {}", xsltfilename, ex);
      }
   }


   /**
    * Assign XSLT for transformation of records to add.
    *
    * @param inputStream
    *
    * @throws Exception TransformerConfigurationException
    */
   public void setXsltForAdd(InputStream inputStream) throws Exception
   {
      transformerAdd = tFactory.newTransformer(new StreamSource(inputStream));
   }

   
   /**
    * Assign XSLT for transformation of records to delete.
    *
    * @param inputStream
    *
    * @throws Exception TransformerConfigurationException
    */
   public void setXsltForDeletion(InputStream inputStream) throws Exception
   {
      transformerDel = tFactory.newTransformer(new StreamSource(inputStream));
   }


   /**
    * Sets the output stream for printing documents to add.
    *
    * @param outputfile
    *
    * @throws UnsupportedEncodingException
    * @throws FileNotFoundException
    */
   public void setOutputAdd(File outputfile)throws IOException // UnsupportedEncodingException, FileNotFoundException
   {
      OutputStream ostream = (outputfile == null) ? System.out : new FileOutputStream(outputfile);
      java.io.Writer writer = new OutputStreamWriter(ostream, outputEncoding);
      foutAdd = new PrintWriter(writer);
   }


    /**
     * Sets the output stream for printing documents to add.
     *
     * @param outputfile
     * @throws UnsupportedEncodingException
     * @throws FileNotFoundException
     */
    public void setOutputDel(File outputfile) throws IOException
    {
        OutputStream ostream = (outputfile == null) ? System.out : new FileOutputStream(outputfile);
        java.io.Writer writer = new OutputStreamWriter(ostream, outputEncoding);
        foutDel = new PrintWriter(writer);
    }


    /**
     * Enable tracing of conversion time.
    * @param flag
     */

    public void setTrace(boolean flag)
    {
    }

    /**
     *  Assegna il numero di frequenza con la quale viene
     *  scritto, in base al numero di records convertiti,
     *  un messaggio di tracing (totale record letti, tempi parziali e totali)
    * @param freq
     */

    public void setTraceFrequency(int freq)
    {
    }


    /** Sets the maximal number of records to transform.
    * @param max */
    public void setMaxCount(long max)
    {
      maxreccount = max;
    }


    public void printInfo(PrintWriter out)
    {
       //out.println("    input: " + inputfilename);
       //out.println("   output: " + outputfilename);
       //out.println("xslt(add): " + xsltForAddFilename);
       //out.println("xslt(del): " + xsltForDeleteFilename);
    }


   /**
    * Transform unimarcslim input from file.
    *
    * @param inputfilename filename of input file unimarcslim.
    *
    * @throws Exception IOException, FileNotFoundException, UnsupportedEncodingException
    */
   public void transform(String inputfilename) throws Exception
   {
      init();
      transform(new InputStreamReader(new FileInputStream(inputfilename), inputEncoding));
      close();
   }


   public long getRecordCount()
   {
      return this.reccount;
   }


   public long getCountAdded()
   {
      return this.recordsToAdd;
   }


   public long getCountDeleted()
   {
      return this.recordsToDel;
   }


   /**
    * inizializza i files di output.
    *
    * Da chiamare dopo aver assegnato i files di output.
    */
   private void init()
   {
      if (foutAdd != null)
      {
         foutAdd.println("<?xml version=\"1.0\" encoding=\"" + outputEncoding + "\"?>");
         foutAdd.println("<add>");
      }
      if (foutDel != null)
      {
         foutDel.println("<?xml version=\"1.0\" encoding=\"" + outputEncoding + "\"?>");
         foutDel.println("<delete>");
      }
   }

    /**
     * inizializza i files di output.
     *
     * Da chiamare dopo aver assegnato i files di output.
     */
    private void close()
    {
      if (foutAdd != null)
      {
         foutAdd.println("</add>");
         foutAdd.close();
      }
      if (foutDel != null)
      {
         foutDel.println("</delete>");
         foutDel.close();
      }
    }

    
   /**
    * transform unimarcslim input from inputstream.
    *
    * @param reader input stream reader.
    */
   private void transform(Reader reader) throws Exception
   {
      BufferedReader inp = new BufferedReader(reader);
      String rec;
      while ((rec = inp.readLine()) != null)
      {
         if (rec.length() < 1) {
            continue;
         }
         if ("<rec>".equals(rec.substring(0, 5)))
         {
            if ((maxreccount > 0) && (reccount > maxreccount)) {
               break;
            }
            // logger.debug("transform: ", ts);
            switch (transformRecord(rec))
            {
               case TX_ADDED:
                  ++recordsToAdd;
                  ++reccount;
                  break;
               case TX_DELETED:
                  ++recordsToDel;
                  ++reccount;
                  break;
               case TX_NONE:
                  logger.error("invalid record: {}", rec);
            }
         }
      }
   }

    private Document recordToDom(String record) throws Exception
    {
        //logger.debug("conversione record in DOM: {}", record);
        DocumentBuilder docbuilder = docbuilderfactory.newDocumentBuilder();
        ByteArrayInputStream inp = new ByteArrayInputStream(record.getBytes());
        return docbuilder.parse(inp);
    }



    private int transformRecord(String record) throws Exception
    {
      try
      {
        // trasformazione record da string in dom
        Document recdom = recordToDom(record);
        // integrazioni degli rinvii dei soggetti (relsogg)
        if (recupd != null) {
           recupd.update(recdom);
        }

        // reconversione da dom in string del record aggiornato con le relazioni sogg.
        DOMSource domsource = new DOMSource(recdom);
        StringWriter writerrel = new StringWriter();
        identTransformer.transform(domsource, new StreamResult(writerrel));
        String recrel = writerrel.toString();
        // logger.debug("Record dopo integrazione Soggetti: {}", recrel);

        // trasformazione in solr-input
        DOMResult domresult = new DOMResult();
        transformerAdd.transform(domsource, domresult);
        Document doc = (Document)domresult.getNode();
        Element root = doc.getDocumentElement();
        if (root != null)
        {
           //// aggiunge il record xml (unimarcslim) al Document (solr-input)
           Element xml = doc.createElement("field");
           xml.setAttribute("name","xml");
           root.appendChild(xml);
           xml.appendChild(doc.createTextNode(recrel));

           //// scrive il record aggiornato su file
           DOMSource source = new DOMSource(doc);
           StringWriter writer = new StringWriter();
           StreamResult result = new StreamResult(writer);
           identTransformer.transform(source, result);
           appendAdd(writer.toString());
           return TX_ADDED;
        }
        else
        {
           // document vuoto, da cancellare
           if (transformerDel != null)
           {
              Writer writer = new StringWriter();
              StreamResult result = new StreamResult(writer);
              Reader readerdel = new StringReader(record);
              transformerDel.transform(new StreamSource(readerdel), result);
              appendDel(writer.toString());
           }
           return TX_DELETED;
        }
      }
      catch( TransformerException ex)
      {
          logger.error("Transformazione: {}", record, ex);
      }
      return TX_NONE;
    }

    private int transformRecordXXX( String ts ) throws IOException
    {
      try
      {
        Reader reader = new StringReader(ts);
        DOMResult domresult = new DOMResult();
        transformerAdd.transform(new StreamSource(reader), domresult);
        Document doc = (Document)domresult.getNode();
        Element root = doc.getDocumentElement();
        if (root != null)
        {
           // aggiunge il record xml (unimarcslim) al Document
           Element xml = doc.createElement("field");
           xml.setAttribute("name","xml");
           root.appendChild(xml);
           xml.appendChild(doc.createTextNode(ts));

           // scrive il record aggiornato su file
           DOMSource source = new DOMSource(doc);
           Writer writer = new StringWriter();
           StreamResult result = new StreamResult(writer);
           identTransformer.transform(source, result);
           appendAdd(writer.toString());
           return TX_ADDED;
        }
        else
        {
           // document vuoto, da cancellare
           if (transformerDel != null)
           {
              Writer writer = new StringWriter();
              StreamResult result = new StreamResult(writer);
              Reader readerdel = new StringReader(ts);
              transformerDel.transform(new StreamSource(readerdel), result);
              appendDel(writer.toString());
           }
           return TX_DELETED;
        }
      }
      catch( TransformerException ex)
      {
         logger.error("Transformazione: {}", ts, ex);
      }
      return TX_NONE;
    }


    private void appendAdd(String rec)
    {
           foutAdd.println(rec);
           foutAdd.println("");
    }


    private void appendDel(String rec)
    {
           foutDel.println(rec);
    }


  private Transformer getIdentTransformer()
  {
     try
     {
        Transformer tr = TransformerFactory.newInstance().newTransformer();
        Properties props = new Properties();
        props.setProperty(javax.xml.transform.OutputKeys.OMIT_XML_DECLARATION,"yes");
        tr.setOutputProperties(props);
        return tr;
     }
     catch( TransformerConfigurationException ex)
     {
         logger.error("", ex);
     }
     return null;
  }

} //class//

