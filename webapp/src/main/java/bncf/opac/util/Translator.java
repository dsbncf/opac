

package bncf.opac.util;


import java.io.IOException;
import java.io.InputStream;
import java.util.Locale;
import java.util.Properties;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;





public class Translator extends Properties
{
   private static final Logger logger = LoggerFactory.getLogger(Translator.class);
   public  static final String FILEBASE = "Translation";

   private Locale locale = Locale.ITALIAN; // default


   public Translator(Locale locale)
   {
      super();
      this.locale = locale;
      try
      {
         loadResource();
      }
      catch(IOException ex)
      {
         logger.error("impossibile caricare le traduzioni: " + ex.getMessage());
      }
   }


   public String translate(String toTrans)
   {
      String trans = getProperty(toTrans);
      return (trans == null) ? toTrans : trans;
   }


   private final void loadResource() throws IOException
   {
      StringBuilder res = new StringBuilder(FILEBASE);
      res.append(".");
      res.append(locale.getLanguage());
      res.append("_");
      res.append(locale.getCountry());
      logger.debug("opening resource: " +  res.toString());
      InputStream inp = this.getClass().getClassLoader().getResourceAsStream(res.toString());
      this.load(inp);
   }

}//class//

