package webdev.webengine.solr;


import java.io.Reader;
import java.io.StringReader;
import java.io.StringWriter;
import java.util.ArrayList;
import java.util.Iterator;

import javax.xml.namespace.QName;
import javax.xml.stream.XMLEventReader;
import javax.xml.stream.XMLInputFactory;
import javax.xml.stream.events.Attribute;
import javax.xml.stream.events.Characters;
import javax.xml.stream.events.EndElement;
import javax.xml.stream.events.EntityReference;
import javax.xml.stream.events.StartElement;
import javax.xml.stream.events.XMLEvent;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;



public class SolrResultParser
{
    private static final Logger logger = LoggerFactory.getLogger(SolrResultParser.class);
    private static final String SOLR_RESULT_VERSION = "2.2";

    private static final int ST_UNDEFINED       =  0;
    private static final int ST_RESPONSE        =  1;
    private static final int ST_HEADER          =  2;
    private static final int ST_HEADERPARAMS    =  3;
    private static final int ST_HD_FACETQUERY   =  4;
    private static final int ST_HD_FACETFIELD   =  5;
    private static final int ST_HD_QUERY        =  6;
    private static final int ST_HD_FILTERQUERY  =  7;
    private static final int ST_RESULT          =  8;
    private static final int ST_DOCUMENT        =  9;
    private static final int ST_DOCUMENT_ARRAY  = 10;
    private static final int ST_FACET_COUNTS    = 11;
    private static final int ST_FACET_QUERIES   = 12;
    private static final int ST_FACET_FIELDLIST = 13;
    private static final int ST_FACET_FIELD     = 14;
    private static final int ST_FACET_DATES     = 15;
    private static final int ST_FACET_RANGES    = 16;

    private int parsingStage = ST_UNDEFINED;

    final XMLInputFactory inputFactory;
    private SolrResult solrResult;
    private ParseValue currentParseValue = null;
    private SolrResultDocument currentDocument = null;
    private FacetInfo currentFacetInfo = null;
    private FacetQueries facetQueries = new FacetQueries();
    private ArrayList<String> currentList = null;
    private String currentListName = null;

    private int debug = 1;


    public SolrResultParser()
    {
        super();
        inputFactory = initInputFactory();
    }

    SolrResultParser(SolrResult solrResult)
    {
        this.solrResult = solrResult;
        inputFactory = initInputFactory();
    }


    public void parse(String xml)   throws Exception
    {
        Reader sin = new StringReader(xml);

        // Let's pass generated system id:
        //@SuppressWarnings("deprecation")
        //XMLEventReader er = mFactory.createXMLEventReader(, fin);

        XMLEventReader eventReader =  inputFactory.createXMLEventReader(sin);

        //int count = 300;
        while (eventReader.hasNext())
        {
            //if(count--==0)break;

            XMLEvent event = eventReader.nextEvent();

            if (debug > 1)
            {
                StringWriter sw = new StringWriter();
                sw.write("\n\n{ENC:");
                event.writeAsEncodedUnicode(sw);
                sw.write("}");
                logger.debug(sw.toString());
            }

            if (event.isStartElement())
            {
               StartElement startElement = event.asStartElement();
               String elementName = startElement.getName().toString();
               
               logger.debug("Event - Start Element: {} [{}]", elementName, event.getEventType());

               if (elementName.equals("lst"))
                   handleLstElement(startElement);
               else
               if (elementName.equals("arr"))
                   handleArrElement(startElement);
               else
               if (elementName.equals("response"))
                   handleStartElement(startElement);
               else
               if (elementName.equals("result"))
                   handleStartElement(startElement);
               else
               if (elementName.equals("doc"))
                   handleStartElement(startElement);
               else
               if (elementName.equals("facet_counts"))
                   handleStartElement(startElement);
               else
                   initParseValue(elementName, startElement);
           }
           else
           if (event.isCharacters())
           {
                logger.debug("Event - Characters: [{}]", event.getEventType());

                Characters text = event.asCharacters();
                if (!text.isWhiteSpace())
                {
                    String data = text.getData();
                    int len = data.length();
                    if (debug > 1) logger.debug("Text[" + len + "]: " + data);
                    if ((len > 0)  && (currentParseValue !=null))
                        currentParseValue.setValue(data);
                }

                if (text.isWhiteSpace())
                {
                    if (debug > 1) logger.debug("Characters is White Space");
                }
                if (text.isIgnorableWhiteSpace()) {  }
            }
            else
            if (event.isEndElement())
            {
               EndElement endElement = event.asEndElement();
               String name = endElement.getName().toString();
               logger.debug("Event - End Element: {} [{}]", name, event.getEventType());

               handleEndElement(name,endElement);
            }
            /*
            else
            if (event.isStartDocument())
            {
                if (debug > 1) prEvent(event, "Start Document");
            }
            */
            else
            if (event.isEndDocument())
            {
               logger.debug("Event - End Document: [{}]", event.getEventType());
            }
            else
            if (event.isAttribute())
            {
               logger.debug("Event - Attribute: [{}]", event.getEventType());
               // throw new UnsupportedOperationException("Not yet implemented");
            }
            else
            if (event.isNamespace())
            {
               logger.debug("Event - Namespace: [{}]", event.getEventType());
               // throw new UnsupportedOperationException("Not yet implemented");
            }
            else
            if (event.isProcessingInstruction())
            {
               logger.debug("Event - Processing instruction: [{}]", event.getEventType());
               // throw new UnsupportedOperationException("Not yet implemented");
            }
            else
            if (event instanceof EntityReference)
            {
               EntityReference eref = (EntityReference) event;
               logger.debug("[ENTITY-REF {}]", eref.getName());
               //throw new UnsupportedOperationException("Not yet implemented");
            }

        }
    }


    private void handleStartElement(StartElement startElement)
    {
       String elementName = startElement.getName().toString();
       if (debug > 1) logger.debug("Element Name:" + elementName);

       Iterator attributes = startElement.getAttributes();
       while (attributes.hasNext())
       {
        Attribute attribute  = (Attribute) (attributes.next());
        if (debug > 1)
        {
            logger.debug("Attribute Name: " + attribute.getName().toString());
            logger.debug("Attribute Value:" + attribute.getValue());
        }
       }

       switch(parsingStage)
       {
         case ST_UNDEFINED:
             if (elementName.equals("response"))
                 setParsingStage(ST_RESPONSE);
             break;

         case ST_RESPONSE:
             if (elementName.equals("result"))
             {
                setParsingStage(ST_RESULT);
                Iterator attrs = startElement.getAttributes();
                while (attrs.hasNext())
                {
                  Attribute attr  = (Attribute) (attrs.next());
                  solrResult.setResultAttribute(attr.getName().toString(),attr.getValue());
                }
             }
             else
                 throw new UnsupportedOperationException("Not yet implemented");
             break;
         case ST_HEADER:
             throw new UnsupportedOperationException("Not yet implemented");
         case ST_HEADERPARAMS:
             throw new UnsupportedOperationException("Not yet implemented");
         case ST_RESULT:
             if (elementName.equals("doc"))
             {
                 setParsingStage(ST_DOCUMENT);
                 currentDocument = new SolrResultDocument();
                 if (debug > 1) logger.debug("current document assigned");
             }
             else
             throw new UnsupportedOperationException("Not yet implemented");
             break;
         case ST_DOCUMENT:
             break;

         case ST_FACET_COUNTS:
             throw new UnsupportedOperationException("Not yet implemented");
         case ST_FACET_QUERIES:
             throw new UnsupportedOperationException("Not yet implemented");
         case ST_FACET_FIELDLIST:
             throw new UnsupportedOperationException("Not yet implemented");
         case ST_FACET_FIELD:
             throw new UnsupportedOperationException("Not yet implemented");
         case ST_FACET_DATES:
             throw new UnsupportedOperationException("Not yet implemented");
         case ST_FACET_RANGES:
             throw new UnsupportedOperationException("Not yet implemented");

       }
    }


    private void handleArrElement(StartElement startElement)
    {
       String name = getElementName(startElement);
       if (name == null)
           return;

       switch(parsingStage)
       {
         case ST_RESPONSE:
             throw new UnsupportedOperationException("Not yet implemented");
         case ST_HEADER:
             throw new UnsupportedOperationException("Not yet implemented");
         case ST_HEADERPARAMS:
                  if (name.equals("facet.field"))
                        setParsingStage(ST_HD_FACETFIELD);
                  else
                      if (name.equals("facet.query"))
                          setParsingStage(ST_HD_FACETQUERY);
                  else
                      if (name.equals("q"))
                          setParsingStage(ST_HD_QUERY);
                  else
                      if (name.equals("fq"))
                          setParsingStage(ST_HD_FILTERQUERY);
                 break;
         case ST_RESULT:
             throw new UnsupportedOperationException("Not yet implemented");
         case ST_DOCUMENT:
              currentListName = name;
              currentList = new ArrayList<String>();
              setParsingStage(ST_DOCUMENT_ARRAY);
              break;

         case ST_FACET_COUNTS:
             throw new UnsupportedOperationException("Not yet implemented");
         case ST_FACET_QUERIES:
             throw new UnsupportedOperationException("Not yet implemented");
         case ST_FACET_FIELDLIST:
             throw new UnsupportedOperationException("Not yet implemented");
         case ST_FACET_FIELD:
             throw new UnsupportedOperationException("Not yet implemented");
         case ST_FACET_DATES:
             throw new UnsupportedOperationException("Not yet implemented");
         case ST_FACET_RANGES:
             throw new UnsupportedOperationException("Not yet implemented");

       }
    }


    private void handleLstElement(StartElement startElement)
    {
       String lstName = getElementName(startElement);
       if (debug > 1) logger.debug("lst element: " + lstName);
       if (lstName == null)
          return;

       switch(parsingStage)
       {
         case ST_RESPONSE:
                    if (lstName.equals("responseHeader"))
                       setParsingStage(ST_HEADER);
                    else
                      if (lstName.equals("facet_counts"))
                         setParsingStage(ST_FACET_COUNTS);
                    else
                        throw new UnsupportedOperationException("Not yet implemented: " + lstName);
                    break;
         case ST_HEADER:
                     if (lstName.equals("params"))
                        setParsingStage(ST_HEADERPARAMS);
                 break;
         case ST_HEADERPARAMS:
             throw new UnsupportedOperationException("Not yet implemented: " + lstName);
         case ST_RESULT:
             throw new UnsupportedOperationException("Not yet implemented: " + lstName);
         case ST_DOCUMENT:
             throw new UnsupportedOperationException("Not yet implemented: " + lstName);

         case ST_FACET_COUNTS:
                    if (lstName.equals("facet_queries"))
                    {
                         setParsingStage(ST_FACET_QUERIES);
                    }
                    else
                    if (lstName.equals("facet_fields"))
                         setParsingStage(ST_FACET_FIELDLIST);
                    else
                    if (lstName.equals("facet_dates"))
                         setParsingStage(ST_FACET_DATES);
                    else
                    if (lstName.equals("facet_ranges"))
                         setParsingStage(ST_FACET_RANGES);
                    else
                        throw new UnsupportedOperationException("Not yet implemented: " + lstName);
                    break;
         case ST_FACET_QUERIES:
                        throw new UnsupportedOperationException("Not yet implemented: " + lstName);

         case ST_FACET_FIELDLIST:
                     logger.debug("creating new FacetInfo for " + lstName);
                     currentFacetInfo = new FacetInfo(lstName);
                     setParsingStage(ST_FACET_FIELD);
                     break;

         case ST_FACET_FIELD:
             throw new UnsupportedOperationException("Not yet implemented");

         case ST_FACET_DATES:
                            break;
         case ST_FACET_RANGES:
                            break;
       }
    }


    @SuppressWarnings("fallthrough")
    private void handleEndElement(String name,EndElement endElement) throws Exception
    {
       switch(parsingStage)
       {
         case ST_UNDEFINED:
             throw new UnsupportedOperationException("Not yet implemented [" + name + "]");
         case ST_RESPONSE:
             logger.debug("document done");
         case ST_HEADER:
             if (name.equals("arr"))
                throw new UnsupportedOperationException("Not yet implemented [" + name +"]");
             else
             if (name.equals("lst"))
                 setParsingStage(ST_RESPONSE);
             else
                 closeCurrentParseValue();
             break;
         case ST_HEADERPARAMS:
             if (name.equals("arr"))
                throw new UnsupportedOperationException("Not yet implemented [" + name +"]");
             else
             if (name.equals("lst"))
                 setParsingStage(ST_HEADER);
             else
             if ((currentParseValue.name != null) && (currentParseValue.name.equals("version")))
                 checkVersion(currentParseValue.value);
             closeCurrentParseValue();
             break;
         case ST_HD_FACETFIELD:
             if (name.equals("arr"))
                 setParsingStage(ST_HEADERPARAMS);
             else
             if (name.equals("lst"))
                throw new UnsupportedOperationException("Not yet implemented [" + name +"]");
             else
                 closeCurrentParseValue();
             break;
         case ST_HD_QUERY:
             if (name.equals("arr"))
                 setParsingStage(ST_HEADERPARAMS);
             else
             if (name.equals("lst"))
                throw new UnsupportedOperationException("Not yet implemented [" + name +"]");
             else
                 closeCurrentParseValue();
             break;
         case ST_HD_FILTERQUERY:
             if (name.equals("arr"))
                 setParsingStage(ST_HEADERPARAMS);
             else
             if (name.equals("lst"))
                throw new UnsupportedOperationException("Not yet implemented [" + name +"]");
             else
                 closeCurrentParseValue();
             break;
         case ST_HD_FACETQUERY:
             if (name.equals("arr"))
                 setParsingStage(ST_HEADERPARAMS);
             else
             if (name.equals("lst"))
                throw new UnsupportedOperationException("Not yet implemented [" + name +"]");
             else
                 closeCurrentParseValue();
             break;
         case ST_RESULT:
             if (name.equals("result"))
                 setParsingStage(ST_RESPONSE);
             else
                throw new UnsupportedOperationException("Not yet implemented [" + name +"]");
             break;
         case ST_DOCUMENT_ARRAY:
             if (name.equals("arr"))
             {
                if ((currentDocument != null) &&(currentList != null))
                   currentDocument.addStringList(currentListName, currentList);
                setParsingStage(ST_DOCUMENT);
             }
             else
                if (name.equals("str"))
                   closeCurrentParseValue();
             break;
         case ST_DOCUMENT:
             if (name.equals("arr"))
                throw new UnsupportedOperationException("Not yet implemented [" + name +"]");
             else
             if (name.equals("lst"))
                throw new UnsupportedOperationException("Not yet implemented [" + name +"]");
             else
             if (name.equals("doc"))
             {
                 closeCurrentDocument();
                 setParsingStage(ST_RESULT);
             }
             else
                 closeCurrentParseValue();
             break;

         case ST_FACET_COUNTS:
               if (name.equals("lst"))
                   setParsingStage(ST_RESPONSE);
               else
                   throw new UnsupportedOperationException("Not yet implemented [" + name +"]");
               break;

         case ST_FACET_DATES:
                               break;

         case ST_FACET_RANGES:
                               break;

         case ST_FACET_QUERIES:
                  if (name.equals("lst"))
                  {
                     //if (currentFacetInfo != null)
                     //{
                     //   logger.debug("currentFacetInfo: " + currentFacetInfo.getName());
                     //   solrResult.addFacetInfo(currentFacetInfo);
                     //   currentFacetInfo = null;
                     //}
                     for (FacetInfo fi : facetQueries)
                     {
                         logger.debug("FacetQueries, adding FacetInfo: " + fi.getName());
                         solrResult.addFacetInfo(fi);
                     }
                     setParsingStage(ST_FACET_COUNTS);
                  }
                  else
                      closeCurrentParseValue();
                  break;

         case ST_FACET_FIELDLIST:
                 if (name.equals("lst"))
                     setParsingStage(ST_FACET_COUNTS);
                 else
                     closeCurrentParseValue();
                 break;

         case ST_FACET_FIELD:
                 if (debug > 1) logger.debug("EndOfFacet: " + name);
                 if (name.equals("lst"))
                 {
                     if (currentFacetInfo != null)
                     {
                        logger.debug("currentFacetInfo: " + currentFacetInfo.getName());
                        solrResult.addFacetInfo(currentFacetInfo);
                        currentFacetInfo = null;
                     }
                     setParsingStage(ST_FACET_FIELDLIST);
                 }
                 else
                     closeCurrentParseValue();
                 break;

       }
    }


    private void closeCurrentParseValue() throws Exception
    {
        if (currentParseValue == null)
                return;
        String type = currentParseValue.type;
        String  name = currentParseValue.name;
        String value = currentParseValue.value;
        if (debug > 0)
        {
          logger.debug("current parsing stage = " + parsingStage);
          logger.debug("current parse value: [" + type + ", " + name + ", " + value + "]");
        }

       switch(parsingStage)
       {
         case ST_RESPONSE:
             throw new UnsupportedOperationException("Not yet implemented");
         case ST_HEADER:
             solrResult.setHeaderAttribute(name,value);
             break;
         case ST_HEADERPARAMS:
             solrResult.setHeaderParameter(name,value);
             break;
         case ST_HD_FACETFIELD:
             solrResult.addFacetField(value);
             break;
         case ST_HD_QUERY:
             solrResult.addQuery(value);
             break;
         case ST_HD_FILTERQUERY:
             solrResult.addFilterQuery(value);
             break;
         case ST_HD_FACETQUERY:
             solrResult.addFacetQuery(value);
             break;
         case ST_RESULT:
             throw new UnsupportedOperationException("Not yet implemented");
         case ST_DOCUMENT_ARRAY:
             if (currentList == null)
                 throw new Exception("no current list");
             currentList.add(value);
             break;
         case ST_DOCUMENT:
             if (currentDocument == null)
                 throw new Exception("no current document");
             currentDocument.put(type, name, value);
             break;

         case ST_FACET_COUNTS:
             throw new UnsupportedOperationException("Not yet implemented");

         case ST_FACET_FIELDLIST:
             throw new UnsupportedOperationException("Not yet implemented");

         case ST_FACET_FIELD:
             currentFacetInfo.add(new FacetEntry(name,value));
             break;

         case ST_FACET_QUERIES:
             // currentFacetInfo.add(new FacetEntry(name,value));
             facetQueries.addQuery(name,value);
             break;

         case ST_FACET_DATES:
             throw new UnsupportedOperationException("Not yet implemented");
         case ST_FACET_RANGES:
             throw new UnsupportedOperationException("Not yet implemented");

       }
       currentParseValue = null;
    }


    private void closeCurrentDocument() throws Exception
    {
        if (currentDocument == null)
            throw new Exception("no current document");

        solrResult.addDocument(currentDocument);
        currentDocument = null;
    }

    private void initParseValue(String elementName, StartElement startElement)
    {
        if (debug > 1) logger.debug("reading element of type " + elementName);

        Attribute attribute = startElement.getAttributeByName(new QName("name"));
        String name = (attribute == null)  ? null : attribute.getValue();
        currentParseValue = new ParseValue(elementName,name);
    }

    private String getElementName(StartElement startElement)
    {
       Attribute attribute = startElement.getAttributeByName(new QName("name"));
       return attribute.getValue();
    }

    private void checkVersion(String value) throws Exception
    {
        if (!SOLR_RESULT_VERSION.equals(value))
            throw new Exception("Versione della risposta Solr non supportata, versione richiesta: "
                                  + SOLR_RESULT_VERSION + " versione trovata: " + value);
       logger.debug("Solr Result Version: " + value);

    }

    private XMLInputFactory initInputFactory()
    {
        System.setProperty("javax.xml.stream.XMLInputFactory",
                           "com.fasterxml.aalto.stax.InputFactoryImpl");
        XMLInputFactory f = XMLInputFactory.newInstance();
        //f.setProperty(XMLInputFactory.IS_COALESCING, Boolean.FALSE);
        f.setProperty(XMLInputFactory.IS_COALESCING, Boolean.TRUE);
        //f.setProperty(XMLInputFactory.REPORTER, new TestReporter());
        f.setProperty(XMLInputFactory.IS_REPLACING_ENTITY_REFERENCES, Boolean.FALSE);

        logger.debug("Factory instance: {}", f.getClass());
        logger.debug("  coalescing: {}", f.getProperty(XMLInputFactory.IS_COALESCING));
        return f;
    }

    public void setSolrResult(SolrResult solrResult)
    {
        this.solrResult = solrResult;
    }

    private void setParsingStage(int stage)
    {
        if (debug > 1) logger.debug("Changing parsing stage: " + parsingStage + " -> " + stage);
        parsingStage = stage;
    }

    private void  prEvent(XMLEvent event, String eventname)
    {
       logger.debug("Event Type: " + eventname + " [" + event.getEventType() + "]");
    }



    //////////////////////////////////////////////////////////////////

    private class ParseValue
    {
        private String type  = null;
        private String name  = null;
        private String value = null;

        private ParseValue(String type, String name)
        {
            this.type = type;
            this.name = name;
        }

        private void setValue(String value)
        {
            this.value = value;
        }
    }

}//class//


/*

response	: risposta solr

  lst:responseHeader:	generalita della richiesta
	int:status	0
	int:QTime	31
	lst:params
		str:indent	on
		str:start	0
		str:q		keywords:marketing informatica
		str:rows	10
		str:version	2.2
		str:facet	true
		str:fl		*,score
		str:facet.mincount	1
		arr:facet.query
			str
		str:facet.limit	11
		str:q.op	AND
		arr:facet.field
			str

  result:response:numFound:start:maxScore
	doc
		str:{field}
		date:{field}
		int:{field}
		float:{field}

  lst:facet_counts
	lst:facet_queries
		int:{query}
	lst:facet_fields
		lst:azienda_fc
			int:{value}	98
		lst:facet_dates
		lst:facet_ranges
*/