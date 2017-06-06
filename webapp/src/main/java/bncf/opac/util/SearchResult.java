
package bncf.opac.util;


import java.io.IOException;
import java.io.Serializable;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;


import webdev.webengine.solr.SolrResult;

/**
 * Questa classe rappresenta un bid / record.
 *
 * L'istanza viene salvata in una hash map dell'utente in sessione
 * e rappresenta una sorta di carrello di libri.
 */


public final class SearchResult  implements Serializable
{
   private final static Logger logger = LoggerFactory.getLogger(SearchResult.class);

   private SolrResult solrResult    = null;
   private String     querystring   = null;
   private String[]   bids          = null;
   private int        numrows       = 0;
   private int        hashcode      = 0;
   private int        absolutestart = 0;
   private int        start         = 0;
   private int        reccount      = 0;
   private String     type          = "fcsearch";

   // -----------------------------------------

   public SearchResult()
   {
   }

   public SearchResult(int start, int reccount, String[] bids)
   {
      this.reccount = reccount;
      this.start    = start;
      this.bids     = bids;
   }

   public SearchResult(String querystring, SolrResult solrResult, String[] bids)
   {
      setQueryString(querystring);
      this.solrResult = solrResult;
      this.bids       = bids;
   }

   // -----------------------------------------

   public String getQueryString()
   {
      return this.querystring;
   }

   public void setQueryString(String querystring)
   {
      this.querystring = querystring;
      if (querystring != null)
         this.hashcode = querystring.hashCode();
   }

   public int getHashCode()
   {
      return (hashcode < 0) ? (hashcode * -1) : hashcode;
   }

   // -----------------------------------------

   public int getStart()
   {
      return this.start;
   }
 
   public void setStart(int start)
   {
      this.start = start;
   }

   // -----------------------------------------

   public void setType(String type)
   {
      this.type = type;
   }

   public String getType()
   {
      return this.type;
   }


   public int getRecordCount()
   {
      return reccount;
   }

   public void setRecordCount(int count)
   {
      this.reccount = count;
   }

   // -----------------------------------------

   public int getNumRows()
   {
      return numrows;
   }

   public void setNumRows(int rows)
   {
      this.numrows = rows;
   }

   // -----------------------------------------

   public SolrResult getSolrResult()
   {
      return this.solrResult;
   }
 
   public void setSolrResult(SolrResult solrResult)
   {
      this.solrResult = solrResult;
   }
 
   // -----------------------------------------

   public String[] getBids()
   {
      return bids;
   }

   // -----------------------------------------

   public boolean isFirst(int pos)
   {
      // logger.debug("start=" + start + "  pos=" + pos);
      return (pos == (start + 1));
   }

   public boolean isLast(int pos)
   {
      logger.debug("pos = " + pos);
      logger.debug("start = " + start);
      logger.debug("numrows = " + numrows);
      logger.debug("st+num  = " + (start + numrows));
      
      return (pos == (start + numrows));
   }

   // -----------------------------------------

   /**
    * Restituisce il successivo bid dalla lista dei bid.
    * I bid in memoria sono quelli della pagina attuale dei risultati.
    */
   public String getNextBid(String bidCorrente)
   {
     int pos = getPageOffset(bidCorrente) + 1;
     //logger.debug("pos = " + pos);
     int len = (bids == null) ? 0 : bids.length;
     //logger.debug("len = " + len);
     //logger.debug("bids = " + bids[pos]);
     return (pos < len) ? bids[pos] : null; // TODO: assicurarsi che ci sia un successivo
   }


   /**
    * Restituisce il precedente bid dalla lista dei bid.
    * I bid in memoria sono quelli della pagina attuale dei risultati.
    */
   public String getPreviousBid(String bidCorrente)
   {
     int pos = getPageOffset(bidCorrente) - 1;
     return (pos >= 0) ? bids[pos] : null; // TODO: assicurarsi che ci sia un precedente
   }


   /**
    * Restituisce la posizione assoluta nella lista dei risultati.
    */
   public int getPosition(String bidCorrente)
   {
       int relpos = getPageOffset(bidCorrente);
       return (relpos > -1) ? start + 1 + relpos : 0;
   }


   public void updateRecordList(int start, String[] newbids)
   {
     // TODO

     if (this.bids == null)
     {
       this.start = start;
       this.bids  = newbids;
       return;
     }

     logger.debug("   my start: " + this.start);
     logger.debug("bids  start: " + start);
     
     int actlen = this.start + this.bids.length;
     int endoff = start + newbids.length;

     if (actlen == start)
     {
         int newsize = newbids.length + this.bids.length;
         logger.debug("bids to append: " + actlen + " : " + start + " : " + newsize);
         String[] tmparr = new String[newsize];
         System.arraycopy(this.bids, 0, tmparr, 0, this.bids.length);
         System.arraycopy(newbids, 0, tmparr, this.bids.length, newbids.length);
         this.bids = tmparr;
     }
     else if (endoff == this.start)
     {
         logger.debug("bids to prepend: " + endoff + " : " + start );
         int newsize = newbids.length + this.bids.length;
         String[] tmparr = new String[newsize];
         System.arraycopy(newbids, 0, tmparr, 0, newbids.length);
         System.arraycopy(this.bids, 0, tmparr, newbids.length, this.bids.length);
         this.bids = tmparr;
         this.start = start;
     }
     numrows = this.bids.length;

   }

   @Override
   public String toString()
   {
     String res = "querystring: " + querystring + "  hash: " + hashcode;
     return res;
   }

   ///////////////////////////////////////////////////////////////////////////////


   /**
    * Restituisce l'offest del bid nella lista attuale dei bid.
    * l'offset aggiungto al valore start indica la posizione assoluta nel resultset.
    *
    * @param bidCorrente il bid per il quale va calcolato l'offset
    * @return l'offset all'interno della lista dei bid, ritorna 0 se non trovato.
    */

   private int getPageOffset(String bidCorrente)
   {
      if ((bids == null) || (bidCorrente == null))
         return -1;

      int len = (bids == null) ? 0 : bids.length;
      for (int k = 0 ; k < len ; k++)
      {
         if (bidCorrente.equals(bids[k]))
            return  k;
      }
      return -1; // non trovato
   }


   // -----------------------------------------
   // @TODO ELIMINARE A COMPLETAMENTO USO SOLRRESULT AL POSTO DEL DOCUMENT:
   public void setDocument (Object document){}
   // -----------------------------------------

   private void writeObject(java.io.ObjectOutputStream out) throws IOException
   {
     out.defaultWriteObject();
   }

   private void readObject(java.io.ObjectInputStream in) throws IOException, ClassNotFoundException
   {
      in.defaultReadObject();
   }


}//class//
