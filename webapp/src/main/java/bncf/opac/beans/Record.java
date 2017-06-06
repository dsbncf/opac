
package bncf.opac.beans;


import java.io.IOException;
import java.io.Serializable;


/**
 * Questa classe rappresenta un bid / record.
 *
 * L'istanza viene salvata in una hash map dell'utente in sessione
 * e rappresenta una sorta di carrello di libri.
 */


public final class Record  implements Serializable
{
   private String   bid    = null;
   private String   title  = null;
   private String   author = null;
   private String   year   = null;

   // -----------------------------------------

   public Record()
   {
   }

   // -----------------------------------------

   public void setBid(String bid)
   {
      this.bid = bid;
   }

   public void setTitle(String title)
   {
      this.title = title;
   }

   public void setAuthor(String author)
   {
      this.author = author;
   }

   public void setYear(String year)
   {
      this.year = year;
   }

   public String getBid()
   {
      return this.bid;
   }

   public String getTitle()
   {
      return this.title;
   }

   public String getAuthor()
   {
      return this.author;
   }

   public String getYear()
   {
      return this.year;
   }

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
