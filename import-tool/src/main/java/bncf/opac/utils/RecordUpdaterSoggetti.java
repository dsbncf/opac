

package bncf.opac.utils;


import org.w3c.dom.Document;
import org.w3c.dom.Element;
import org.w3c.dom.Node;
import org.w3c.dom.NodeList;
import org.w3c.dom.Text;

import org.xml.sax.SAXException;
import javax.xml.parsers.ParserConfigurationException;

import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;



public class RecordUpdaterSoggetti
{
  private static final Logger logger = LoggerFactory.getLogger(RecordUpdaterSoggetti.class);
  
  private RelazioniSoggetti relsogg = null;


  public RecordUpdaterSoggetti(RelazioniSoggetti relsogg)
  {
     this.relsogg = relsogg;
  }


  private void appendNode969(String preferred, String notpref, String sf, Document doc, Element record)
  {
     if (logger.isDebugEnabled())
        logger.debug("Append969: " + notpref + " -> " + preferred + " " + sf);
     Element elem = doc.createElement("df");
     elem.setAttribute("t","969");
     elem.setAttribute("i1"," ");
     elem.setAttribute("i2"," ");

     Element sfa = doc.createElement("sf");
     sfa.setAttribute("c","a");
     Text txtn = doc.createTextNode(notpref);
     sfa.appendChild(txtn);

     Element sfz = doc.createElement("sf");
     sfz.setAttribute("c",sf);
     Text txtp = doc.createTextNode(preferred);
     sfz.appendChild(txtp);

     elem.appendChild(sfa);
     elem.appendChild(sfz);
     record.appendChild(elem);
  }


  public void update(Document recdom)
                     throws SAXException, IOException, ParserConfigurationException
  {
     // Element root = recdom.getDocumentElement(); // <rec>
     update(recdom, recdom.getDocumentElement());
  }


  public void update(Document recdom, Element root)
                     throws SAXException, IOException, ParserConfigurationException
  {
     NodeList fields = root.getChildNodes();

     // lookup per evitare doppioni
     // (key = not-preferred-term), relation is many non-pref. to 1 preferred
     HashMap<String,String> map = new HashMap<String,String>();

     int flen = fields.getLength();
     for (int f = 0 ; f < flen ; f++)
     {
        Node field = fields.item(f);
        String nodename = field.getNodeName();
        if (nodename.equals("df"))
        {
            Node tag = field.getAttributes().getNamedItem("t");
            if ((tag == null) || !tag.getNodeValue().equals("606"))
               continue;

           // considera solo tag 606
           NodeList subfields = field.getChildNodes();
           int sflen = subfields.getLength();
           for (int j = 0 ; j < sflen ; j++)
           {
              Node subfld = subfields.item(j);
              String sfid = subfld.getAttributes().getNamedItem("c").getNodeValue();

              if (sfid.equals("a") || sfid.equals("x")) // non preferito
              {
                 String term = subfld.getTextContent();
                 if (logger.isDebugEnabled())
                    logger.debug("Subfield: {} : {}", sfid, term);
                 if (term == null)
                    continue;

                 // find preferred term for rel UF
                 // skip, if already treated
                 if (map.get(term) == null)
                 {
                    String preferred = relsogg.getPreferredUF(term);
                    if (preferred != null)
                    {
                       appendNode969(preferred, term, "z", recdom, root);
                       map.put(term,preferred);
                    }
                 }

                 // find non-preferred terms for rel HSF
                 ArrayList<String> usedfor = relsogg.getHSF(term);
                 if (usedfor != null)
                 {
                    for (String uf: usedfor)
                       if (map.get(uf) == null)
                       {
                          appendNode969(term, uf, "y", recdom, root);
                          map.put(uf,term);
                       }
                 }
                 // find non-preferred terms for rel UF
                 usedfor = relsogg.getUF(term);
                 if (usedfor != null)
                 {
                    for (String uf: usedfor)
                       if (map.get(uf) == null)
                       {
                          appendNode969(term, uf, "z", recdom, root);
                          map.put(uf,term);
                       }
                 }
              }//subfield terms
           }//loop subfields
        }//df
     }//for
  }

}//class

