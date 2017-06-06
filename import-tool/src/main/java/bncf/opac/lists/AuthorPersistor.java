
package bncf.opac.lists;

import bncf.opac.tools.Config;
import java.util.List;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;


public class AuthorPersistor 
{
   private static final Logger logger = LoggerFactory.getLogger(AuthorPersistor.class);

   private final Config config;
   
   public AuthorPersistor(Config config)
   {
      this.config = config;
   }
   
   public void loadAuthorTerms()
   {
      String field = "autore_fc";
      LukeTermsRequest req = new LukeTermsRequest(config.getLukeUrl(), field);
      List<LukeTerm> terms = req.getTerms();
      if ((terms == null) || terms.isEmpty())
         return;

      for (LukeTerm term : terms)
      {
         System.out.println("Term: " + term.getNorm() + " : " + term.getText() + " : " + term.getCount());
      }
   }

} //class//
