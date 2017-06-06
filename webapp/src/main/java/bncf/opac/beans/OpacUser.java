
package bncf.opac.beans;

import bncf.opac.util.SearchResult;

import java.io.IOException;
import java.io.Serializable;
import java.util.HashMap;

import java.util.Locale;


/**
 * Questa classe rappresenta un utente web.
 *
 * L'istanza viene salvata nella session.
 */


public final class OpacUser  implements Serializable
{
   private boolean  accessible    = false; // accessible version disabled by default.
   private Locale   locale        = null;
   private String   showAll       = null;  // show all item in grey box on search page for one facet
   private String   emailAddress  = null;
   private String   closedBoxes   = ""; //list of closed box (format: [name1][name2]...)
   private SearchResult searchResult = null;

   public final static Locale DEFAULT_LOCALE = new Locale("it", "IT");

   private HashMap<String,Record>  carrello = null;

   // -----------------------------------------

   public OpacUser()
   {
     this.carrello = new HashMap<String, Record>();
     this.locale = DEFAULT_LOCALE;
   }

   // -----------------------------------------

   public void setSearchResult(SearchResult searchres)
   {
      this.searchResult = searchres;
   }

   public SearchResult getSearchResult()
   {
      return this.searchResult;
   }

   public boolean hasAccessible()
   {
      return this.accessible;
   }

   public void setAccessible(boolean flag)
   {
      this.accessible = flag;
   }

   public void setLocale(String language)
   {
      if ( ! language.equals("en") && ! language.equals("it") )
         this.locale = DEFAULT_LOCALE;

      if ( language.equals("en") )
         this.locale = new Locale("en", "US");

      if ( language.equals("it") )
         this.locale = new Locale("it", "IT");
   }

   public Locale getLocale()
   {
      return this.locale;
   }

   public String getLanguage()
   {
      return this.locale.getLanguage();
   }

   public void removeClosedBox(String name)
   {
     if ( name == null )
       return;

     String fName = "\\[" + name + "\\]";
     this.closedBoxes = this.closedBoxes.replaceAll(fName, "");
   }

   public void addClosedBox(String name)
   {
     if ( name == null )
       return;

     String fName = "[" + name + "]";
     if ( this.closedBoxes.indexOf(fName) == -1 )
        this.closedBoxes = this.closedBoxes + fName;
   }

   public void setShowAll(String showAll)
   {
      this.showAll = showAll;
   }


   public String getShowAll()
   {
      return this.showAll;
   }

   public void setClosedBoxes(String closedBoxes)
   {
      this.closedBoxes = closedBoxes;
   }


   public String getClosedBoxes()
   {
      return this.closedBoxes;
   }

   // -----------------------------------------

   public String getEmailAddress()
   {
      return this.emailAddress;
   }

   public void setEmailAddress(String email)
   {
      this.emailAddress = email;
   }


   public void addBidToCart(String bid, String title, String author, String year)
   {
      Record record = new Record();
      record.setBid(bid);
      record.setTitle(title);
      record.setAuthor(author);
      record.setYear(year);

      addBidToCart(record);
   }

   public void addBidToCart(Record record)
   {
      if ( record == null )
        return;

      this.carrello.put(record.getBid(), record);
   }

   public void removeBidFromCart(String bid)
   {
      if ( this.carrello.containsKey(bid) )
        this.carrello.remove(bid);
   }

   public void removeBidFromCart(Record record)
   {
      if ( record == null )
        return;

      if ( this.carrello.containsKey(record.getBid()) )
        this.carrello.remove(record.getBid());
   }

   public HashMap<String,Record> getCart()
   {
      return this.carrello;
   }

   public boolean hasBidInCart(String bid)
   {
      if ( bid == null )
        return false;

      return this.carrello.containsKey(bid);
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
