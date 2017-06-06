
package bncf.opac.util;

import java.io.IOException;
import java.io.StringReader;
import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.parsers.ParserConfigurationException;
import org.w3c.dom.Document;
import org.xml.sax.InputSource;
import org.xml.sax.SAXException;



public class XMLUtils
{
   private static final DocumentBuilderFactory docFactory = DocumentBuilderFactory.newInstance();
  /**
   * Returns the string where all non-ascii and <, &, > are encoded as numeric entities.
   * I.e. "&lt;A &amp; B &gt;" * .... (insert result here).
   * The result is safe to include anywhere in a text field in an XML-string.
   * If there was * no characters to protect, the original string is returned.
   *
   * @param originalUnprotectedString
   *            original string which may contain characters either reserved
   *            in XML or with different representation
   *            in different encodings (like 8859-1 and UFT-8)
   * @return
   */
  public static synchronized String protectSpecialCharacters(String originalUnprotectedString)
  {
     if (originalUnprotectedString == null)
         return null;

     boolean anyCharactersProtected = false;

     StringBuilder sb = new StringBuilder();
     for (int i = 0; i < originalUnprotectedString.length(); i++)
     {
        char ch = originalUnprotectedString.charAt(i);
        boolean controlCharacter = (ch < 32);
        boolean unicodeButNotAscii = (ch > 126);
        boolean characterWithSpecialMeaningInXML = (ch == '<') || (ch == '&') || (ch == '>') || (ch == '\'') || (ch == '"');

        if (characterWithSpecialMeaningInXML || unicodeButNotAscii || controlCharacter)
        {
            sb.append("&#").append((int) ch).append(";");
           anyCharactersProtected = true;
        }
        else
           sb.append(ch);
     }
     if (anyCharactersProtected == false)
        return originalUnprotectedString;

     return sb.toString();
  }

    /**
     * Convert xml-text to Document.
     *
     * @param query
     *
     * @throws IOException
     * @throws ParserConfigurationException
     * @throws SAXException
     */
   public static Document xmlTextToDocument(String xmlText)
         throws SAXException, IOException, ParserConfigurationException
   {
      DocumentBuilder documentBuilder = docFactory.newDocumentBuilder();
      Document document = documentBuilder.parse(new InputSource(new StringReader(xmlText)));
      return document;
   }


}//class//
