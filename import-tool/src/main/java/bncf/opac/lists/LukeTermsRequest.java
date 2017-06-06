
package bncf.opac.lists;

import bncf.opac.utils.HttpGetRequest;
import java.io.IOException;
import java.util.List;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;


class LukeTermsRequest
{
   private static final Logger logger = LoggerFactory.getLogger(LukeTermsRequest.class);

   private static final String RESPONSE_FORMAT = "xml";
   private static final long DEFAULT_MAXTERMS = 100000000; // 100 Mio - max long: 2100000000

   private final String lukeUrl;
   private final String field;


   public LukeTermsRequest(String lukeUrl, String field)
   {
      this.lukeUrl = lukeUrl;
      this.field = field;
   }

   public List<LukeTerm> getTerms()
   {
      return getTerms(DEFAULT_MAXTERMS);
   }

   public List<LukeTerm> getTerms(long max)
   {
      String url = formatLukeUrl(max);
      logger.debug("getTerms request URL: {}", url);
      HttpGetRequest req = new HttpGetRequest(url);
      List<LukeTerm> terms = null;
      try
      {
         LukeTermsParser parser = new LukeTermsParser(field);
         terms = parser.parse(req.getResponseStream());
      }
      catch (IOException ex)
      {
         logger.error("Request: {}", url, ex);
      }
      catch (Exception ex)
      {
         logger.error("Parsing Request: {}", url, ex);
      }
      finally
      {
         req.close();
      }
      return terms;
   }
   
   protected String formatLukeUrl(long max)
   {
      return String.format("%s?fl=%s&wt=%s&numTerms=%d", lukeUrl, field, RESPONSE_FORMAT, max);
   }
   
} //class//
