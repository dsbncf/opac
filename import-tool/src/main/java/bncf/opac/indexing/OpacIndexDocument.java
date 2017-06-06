
package bncf.opac.indexing;

import bncf.opac.utils.StringUtils;

import org.apache.lucene.document.Document;
import org.apache.lucene.document.Field;

import java.util.ArrayList;
import java.util.StringTokenizer;

/**
 * Indicizza i records estratti dal file xml come documento Lucene.
 */

public class OpacIndexDocument
{
   private String idn = null;
   private Document doc = null;
   private String keywordsAll = null;
   private ArrayList autori = null;
   private ArrayList titoli = null;
   private ArrayList soggetti = null;
   private ArrayList deweys = null;


   public OpacIndexDocument()
   {
      doc = new Document();
   }

   public Document getDocument()
   {
      return doc;
   }

   public boolean isValid()
   {
      return ((idn != null) && (idn.length() == 10));
   }

   public String getIdn()
   {
      return idn;
   }

   public void setIdn(String _idn)
   {
      if (_idn == null)
         return;

      idn = _idn.trim();
      if (idn.equals(""))
      {
         idn = null;
         return;
      }
      idn = idn.substring(0, 10).toLowerCase();

      addKeyword("idn", idn);
   }

   /**
    * display della breve nei risultati di ricerca.
    */
   public void addTitoloDisplay(String val)
   {
      if (val != null)
      {
         addSortField("titolosort", val);
         addDisplay("titolodisplay", val);
      }
   }

   public void addAutoreDisplay(String val)
   {
      if (val != null)
      {
         addSortField("autoresort", val);
         addDisplay("autoredisplay", val.replaceAll(" , ", ", "));
      }
   }

   public void addTitolo(Titolo titolo)
   {
      if (titolo == null)
         return;

      if (titoli == null)
         titoli = new ArrayList();

      titoli.add(titolo);
      addTitoloNorm(titolo.getNomeNormkey());
   }

   public ArrayList getTitoli()
   {
      return titoli;
   }


   public void addAutore(Autore autore)
   {
      if (autore == null)
         return;

      if (autori == null)
         autori = new ArrayList();

      autori.add(autore);
      addAutoreNorm(autore.getNomeNormkey()); // default non sostituisce _, ma compatta //
      addAutoreNorm(autore.getNomeNormkey(true));// sostituisce '_' con ' ' (spazio) //
      addAutoreKeywords(autore.getKeywords());
      addVid(autore.getVid());
   }

   public ArrayList getAutori()
   {
      return autori;
   }


   public void addSoggetto(Soggetto soggetto)
   {
      if (soggetto == null)
         return;

      if (soggetti == null)
         soggetti = new ArrayList();

      soggetti.add(soggetto);
      addSoggettoNorm(soggetto.getNomeNorm());
      addSoggettoKeywords(soggetto.getNomeNorm());
      addCid(soggetto.getCid());
   }

   public ArrayList getSoggetti()
   {
      return soggetti;
   }


   public void addDewey(Dewey dewey)
   {
      if (dewey == null)
         return;

      if (deweys == null)
         deweys = new ArrayList();

      deweys.add(dewey);
      addCodDewey(dewey.getCod());
      addEdizDewey(dewey.getEdiz());
      addDeweyKeywords(dewey.getDescr());
   }

   public ArrayList getDeweys()
   {
      return deweys;
   }

   public void addTitoloNorm(String val)
   {
      if (val != null)
      {
         addUnstoredKeyword("titolonorm", val);
      }
   }

   public void addTitoloKw(String val)
   {
      addKwText("titolo_kw", val);
   }


   public void addBidTutti(String val)
   {
      addKwText("bidtutti", val);
      addKwText("keywords", val);
   }


   public void addAutoreNorm(String val)
   {
      if (val != null)
      {
         addUnstoredKeyword("autorenorm", val);
      }
   }

   public void addAutoreKeywords(String val)
   {
      if (val != null)
      {
         addKwText("autore_kw", val);
         addKwText("keywords", val);
      }
   }

   public void addVid(String val)
   {
      addKwText("vidtutti", val);
      addKwText("keywords", val);
   }


   public void addSoggettoNorm(String val)
   {
      addUnstoredKeyword("soggettonorm", val);
      //System.err.println("addSoggettoNorm: " + val);
   }

   public void addSoggettoKeywords(String val)
   {
      addKwText("soggetto_kw", val);
      addKwText("keywords", val);
   }

   public void addCid(String val)
   {
      addKwText("cidtutti", val);
      addKwText("keywords", val);
   }


   public void addDeweyKeywords(String val)
   {
      if (val != null)
      {
         addKwText("dewey_kw", val);
         addKwText("keywords", val);
      }
   }

   public void addCodDewey(String val)
   {
      if (val != null)
      {
         // String s = spechar.utf8ToNorm(val); // senza punto //
         String s = StringUtils.utf8ToNorm(val); // senza punto //
         addUnstoredKeyword("coddewey", s);
         addKwText("keywords", s);
      }
   }

   public void addEdizDewey(String val)
   {
      if (val == null)
         return;

      String s = StringUtils.utf8ToNorm(val);
      if (s == null)
         return;
      s = s.trim();
      addUnstoredKeyword("edizdewey", s);
      addKwText("keywords", s);
   }


   public void addCollana(String val)
   {
      addKwText("collana_kw", val);
      addKwText("keywords", val);
   }


   public void addLuogo(String val)
   {
      addKwText("luogo_kw", val);
      addKwText("keywords", val);
   }


   public void addEditore(String val)
   {
      addKwText("editore_kw", val);
      addKwText("keywords", val);
   }


   public void addIdentificatore(String val)
   {
      if (val == null)
         return;
      String compact = val.trim().replaceAll("-", "");

      addKwText("identificatore_kw", val);
      addKwText("identificatore_kw", compact);
      addKwText("keywords", val);
      addKwText("keywords", compact);
   }


   public void addMarca(String val)
   {
      addKwText("marca_kw", val);
      addKwText("keywords", val);
   }


   public void addInventario(String val)
   {
      if (val == null)
         return;

      addKwText("inventario_kw", val);
   }


   public void addCollocazione(String val)
   {
      if (val == null)
         return;

      String stran = val.trim();
      if (stran.equals(""))
         return;
      // elimina caratteri non alfanumerici (non-word) [a-zA-Z_0-9]
      stran = stran.replaceAll("\\W", " ");
      // e compatta spazi multipli
      stran = stran.replaceAll("\\s\\s*", " ");
      StringTokenizer st = new StringTokenizer(stran);

      String nozero = null;
      while (st.hasMoreTokens())
      {
         // elimina 0 iniziali //
         String tok = st.nextToken().replaceFirst("^0+", "");
         if (!tok.equals(""))
            nozero = (nozero == null) ? tok : nozero + " " + tok;
      }

      //System.err.println("Colloc: orig. = " + val);
      //System.err.println("Colloc: space = " + nozero);

      addKwText("collocazione_kw", val);
      addKwText("keywords", val);

      if ((nozero != null) && (!nozero.equals("")))
      {
         addKwText("collocazione_kw", nozero);
         addKwText("keywords", nozero);
      }
   }


   public void addKeywords(String val)
   {
      addKwText("keywords", val);
   }


   public void addKeywords950e33(String val)
   {
      if (val == null)
         return;
      String fval = val.trim();

      if (fval.equals(""))
         return;

      fval = StringUtils.utf8ToNorm(fval);

      if ((fval == null) || ("".equals(fval.trim())))
         return;

      fval = fval.toLowerCase();


      String toindex = null;
      boolean excl = true;
      StringTokenizer st = new StringTokenizer(fval);

      while (st.hasMoreTokens())
      {
         String tk = st.nextToken();
         if (tk.equalsIgnoreCase("v"))
         {
            excl = false;
            continue;
         }
         if (excl)
         {
            try
            {
               Integer.parseInt(tk);
               continue;
            }
            catch (NumberFormatException ex)
            {
            }
         }
         if (toindex == null)
            toindex = tk;
         else
            toindex += " " + tk;
      }
      if (toindex == null)
         return;
      // doc.add(new Field("keywords", toindex, Field.Store.NO, Field.Index.TOKENIZED));
      doc.add(new Field("keywords", toindex, Field.Store.NO, Field.Index.ANALYZED));
   }


   public void addCategorie(String val)
   {
      addKwTextDisplay("categoria", val);
   }

   public void addCategoria(String val)
   {
      addKwTextDisplay("categoria", val);
   }

   public void addLingua(String val)
   {
      addKwText("lingua", val);
   }

   public void addPaese(String val)
   {
      addKwText("paese", val);
   }

   public void addDataAggiornamento(String val)
   {
      addUnstoredKeyword("dataagg", val);
   }

   public void addAnno1(String val)
   {
      addKeyword("anno1", val);
      addKwText("keywords", val);
   }

   public void addAnno2(String val)
   {
      addKeyword("anno2", val);
      addKwText("keywords", val);
   }

   public void addNatura(String val)
   {
      addKeyword("natura", val);
      // addKwText("keywords", val);
   }

   public void addTipoMateriale(String val)
   {
      addKeyword("tipomateriale", val);
      // addKwText("keywords", val);
   }

   public void addBiblioteca(String val)
   {
      addKwText("biblioteca", val);
   }

   public void addTipoDig(String val)
   {
      addKeyword("tipodig", val);
   }


   /**
    * aggiunge Field al Document per la indicizzazione come Keyword.
    * <p>
    * Tokenizza e indicizza la stringa passata nel parametro <param>fval</param>
    * senza salvare la stringa nel Document.
    **/
   private void addKwText(String fname, String fval)
   {
      if ((fname != null) && (fval != null) && (!fval.equals("")))
      {
         String s = StringUtils.utf8ToNorm(fval);
         if (s != null)
         {
            doc.add(new Field(fname, s.toLowerCase(), Field.Store.NO, Field.Index.ANALYZED));
         }
      }
   }

   /**
    * aggiunge Field al Document per la indicizzazione come Keyword.
    * <p>
    * Tokenizza e indicizza la stringa passata nel parametro <param>fval</param>
    * e salva la stringa nel Document.
    **/
   private void addKwTextDisplay(String fname, String fval)
   {
      if ((fname != null) && (fval != null) && (!fval.equals("")))
      {
         String s = StringUtils.utf8ToNorm(fval);
         // Field( name, string, store, index, token )
         if (s != null)
         {
            doc.add(new Field(fname, s.toLowerCase(), Field.Store.YES, Field.Index.ANALYZED));
         }
      }
   }

   /**
    * aggiunge Field al Document per il solo display.
    * <p>
    * Memorizza la stringa passata nel parametro <param>fval</param>
    * senza tokenizzarla e senza indicizzarla
    **/
   private void addDisplay(String fname, String fval)
   {
      if ((fname != null) && (fval != null))
      {
         String val = fval.replaceAll("", "");
         doc.add(new Field(fname, val.replaceAll("", ""), Field.Store.YES, Field.Index.NO));
      }
   }

   /**
    * aggiunge Field al Document per il solo ordinamento dei risultati.
    * <p>
    * Indicizza la stringa passata nel parametro <param>fval</param>.
    * <p>
    * vengono effettuate le seguenti operazioni:
    * eliminazione delle stringhe incluse fra <0xc298> e <0xc29c>
    * normalizzazione
    **/
   private void addSortField(String fname, String fval)
   {
      if ((fname != null) && (fval != null))
      {
         String val = fval.replaceAll("[^]*", ""); //

         String norm = StringUtils.utf8ToNorm(val);
         if (norm != null)
         {
            int sl = norm.length();
            if (sl > 50)
               sl = 50;
            doc.add(new Field(fname, norm.substring(0, sl), Field.Store.YES, Field.Index.NOT_ANALYZED));
         }
      }
   }


   /**
    * aggiunge Field al Document per la indicizzazione dell'intera stringa.
    * <p>
    * Indicizza la stringa passata nel parametro <param>fval</param>,
    * la memorizza ma non la tokenizza.
    **/
   private void addKeyword(String fname, String fval)
   {
      if ((fname != null) && (fval != null))
      {
         doc.add(new Field(fname, fval.toLowerCase(), Field.Store.YES, Field.Index.NOT_ANALYZED));
      }
   }

   /**
    * aggiunge Field al Document per la sola indicizzazione dell'intera stringa.
    * <p>
    * Indicizza la stringa passata nel parametro <param>fval</param>
    * senza tokenizzarla e senza memorizzarla.
    **/
   private void addUnstoredKeyword(String fname, String fval)
   {
      if ((fname != null) && (fval != null))
      {
         doc.add(new Field(fname, fval.toLowerCase(), Field.Store.NO, Field.Index.NOT_ANALYZED));
      }
   }


} // class //
