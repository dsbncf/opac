

package bncf.opac.lists;

import bncf.opac.utils.StringUtils;
import java.io.IOException;

import java.io.InputStream;
import java.io.InputStreamReader;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import javax.xml.parsers.ParserConfigurationException;
import javax.xml.parsers.SAXParser;
import javax.xml.parsers.SAXParserFactory;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.xml.sax.Attributes;
import org.xml.sax.InputSource;
import org.xml.sax.SAXException;
import org.xml.sax.SAXParseException;


public class LukeTermsParser extends org.xml.sax.helpers.DefaultHandler
{
   private static final Logger logger = LoggerFactory.getLogger(LukeTermsParser.class);
   
   protected final static int STATE_UNDEFINED       = 0;
   protected final static int STATE_INSIDE_FIELDS   = 1;
   protected final static int STATE_INSIDE_FIELD    = 2;
   protected final static int STATE_INSIDE_TOPTERMS = 3;

   private int state = STATE_UNDEFINED;

   private final StringBuffer accumulator = new StringBuffer();
   private String text = null;
   private String fieldName = null;

   private final ArrayList<LukeTerm> terms = new ArrayList<>();

   protected LukeTermsParser(String fieldName)
   {
      this.fieldName = fieldName;
   }

   
   public  List<LukeTerm> parse(InputStream input) throws IOException
   {
      InputSource source = new InputSource(new InputStreamReader(input));
      SAXParserFactory factory = SAXParserFactory.newInstance();
      SAXParser saxParser;
      try
      {
         saxParser = factory.newSAXParser();
         saxParser.parse(source, this);
      }
      catch (ParserConfigurationException | SAXException | IOException ex)
      {
         throw new IOException(ex);
      }
      return terms;
   }


   @Override
   public void startDocument() throws SAXException
   {
   }


   @Override
   public void endDocument() throws SAXException
   {
   }

   @Override
   public void startElement(String uri, String localName, String tagName,
                            Attributes attributes)
   {
      accumulator.setLength(0);
      if (tagName.equals("int") && (state == STATE_INSIDE_TOPTERMS))
      {
         text = attributes.getValue("name");
      }
      else if (tagName.equals("lst"))
      {
         String name = attributes.getValue("name");
         if (name != null)
         {
            if (name.equals("fields"))
            {
               state = STATE_INSIDE_FIELDS;
            }
            else if (name.equals(fieldName))
            {
               state = STATE_INSIDE_FIELD;
            }
            else if (name.equals("topTerms"))
            {
               state = STATE_INSIDE_TOPTERMS;
            }
         }
      }
   }


   @Override
   public void endElement(String uri, String localName, String tagName)
   {
      String sep = "|";
      if (tagName.equals("int") && (state == STATE_INSIDE_TOPTERMS))
      {
         String count = accumulator.toString().trim();
         String norm = StringUtils.utf8ToNormOrd(text, true);
         if (norm != null)
            norm = norm.toLowerCase();
         terms.add(new LukeTerm(norm, text, count));
      }
      else if (tagName.equals("lst"))
      {
         switch (state)
         {
            case STATE_INSIDE_TOPTERMS:
               state = STATE_INSIDE_FIELD;
               break;
            case STATE_INSIDE_FIELD:
               state = STATE_INSIDE_FIELDS;
               break;
            case STATE_INSIDE_FIELDS:
               state = STATE_UNDEFINED;
               break;
            default:
               state = STATE_UNDEFINED;
               break;
         }
      }
   }


   @Override
   public void characters(char[] buf, int start, int length) throws SAXException
   {
      accumulator.append(buf, start, length);
   }

   @Override
   public void warning(SAXParseException ex)
   {
       logger.warn("WARNING: line {}",ex.getLineNumber(), ex);
   }


   @Override
   public void error(SAXParseException ex)
   {
      logger.error("ERROR: line {}", ex.getLineNumber(), ex);
   }


   @Override
   public void fatalError(SAXParseException ex)
   {
      logger.error("FATAL: line {}",ex.getLineNumber(), ex);
   }

}
