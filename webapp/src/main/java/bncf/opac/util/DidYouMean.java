
package bncf.opac.util;

import java.io.IOException;

import java.util.ArrayList;

import webdev.webengine.solr.SearchTerm;
import webdev.webengine.solr.SearchTermList;



import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

/** Classe utilizzata per trovare termini simili a quelli dati.
 *
 * La classe utilizza l'oggetto org.apache.lucene.search.spell.SpellChecker
 * che deve essere passato al costruttore gia' impostato con l'indice.
 *
 * @author gb
 */
public class DidYouMean
{
   private final static Logger logger = LoggerFactory.getLogger(DidYouMean.class);

   //Termini simili da trovare, limite massimo
   private static int maxTermCount = 5;

   private static SpellChecker spellChecker = null;

   private static SearchTermList searchTermList = null;

   /** Costruttore.
    *
    */
   public DidYouMean()
   {
   }

   /** Costruttore.
    *
    * @param _spellChecker Oggetto SpellChecker gia' valido (con indice)
    * @param _maxTermCount Numero di termini massimi simili da restituire per ogni termine passato
    * @param _searchTermList Lista di termini di cui cercare i termini simili
    */
   public DidYouMean(SpellChecker _spellChecker, int _maxTermCount, SearchTermList _searchTermList)
   {
      spellChecker = _spellChecker;
      maxTermCount = _maxTermCount;
      searchTermList = _searchTermList;
   }

   /** Setta lo SpellChecker.
    *
    * @param _spellChecker  Oggetto SpellChecker gia' valido (con indice)
    */
   public void setSpellChecker(SpellChecker _spellChecker)
   {
      spellChecker = _spellChecker;
   }


   /** Setta il numero massimo di termini simili da restituire.
    *
    * @param _maxTermCount Numero massimo di termini simili da restituire
    */
   public void setMaxTermCount(int _maxTermCount)
   {
      maxTermCount = _maxTermCount;
   }


   /** Setta la lista di termini di cui cercare i termini simili.
    *
    * @param _searchTermList Lista di termini di cui ricercare i termini simili
    */
   public void setSearchTermList(SearchTermList searchTermList)
   {
      this.searchTermList = searchTermList;
   }

   /** Cerca i termini simili solo se esiste uno spelleChecker e una lista di
    * termini in cui cercare.
    *
    * Vengono restituiti maxTermCount termini simili per ogni termine contenuto
    * nella searchTermList.
    *
    * @return Array contenente la lista dei termini simili. Non e' mai nullo, al limite e' vuoto.
    */
   public String[] getSimilarTerms()
   {
      if (spellChecker == null)
      {
         logger.debug("NO SpellChecker!");
         return new String[0];
      }

      if ((searchTermList == null) || (searchTermList.size() == 0))
      {
         logger.debug("Empty SearchTermList");
         return new String[0];
      }

      ArrayList<String> words = new ArrayList<String>();
      for (SearchTerm searchTerm : searchTermList)
      {
         String field = searchTerm.getField();
         String text = searchTerm.getValue();
         logger.debug("field: " + field + " = " + text);
         if ((field == null) || (text == null))
               continue;

         if (field.equals("keywords") || field.matches(".*_kw"))
         {
            String[] arr = text.split("\\W+");
            for (String w : arr)
            {
               String tr = w.trim();
               if (!tr.equals(""))
               {
                  words.add(w);
               }
            }
         }
      }

      int numwords = words.size();
      if (numwords < 1)
      {
         return new String[0];
      }

      String[] simili = null;
      try
      {
         if (numwords == 1)
         {
            String word = words.get(0);
            logger.debug("Lookup alternative terms for: " + word);
            simili = spellChecker.suggestSimilar(word, maxTermCount);
         }
         else
         {
            ArrayList<String> arr = new ArrayList<String>(maxTermCount * numwords);
            for (String word : words)
            {
               logger.debug("Lookup alternative terms for: " + word);
               String[] alt = spellChecker.suggestSimilar(word, maxTermCount);
               if ((alt != null) && (alt.length > 0))
               {
                  int max = (alt.length < maxTermCount) ? alt.length : maxTermCount;
                  for (int j = 0; j < max; j++)
                  {
                     arr.add(alt[j]);
                  }
               }
            }
            simili = arr.toArray(new String[0]);
         }
      }
      catch(IOException ex)
      {
         logger.info(ex.getMessage());
         return new String[0];
      }

      if ((simili == null) || (simili.length == 0))
      {
         logger.debug("DidYouMean: No similar terms");
         return new String[0];
      }

      return simili;

   }



}
