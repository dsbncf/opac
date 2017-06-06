/*
 */

package bncf.opac.db;

import bncf.opac.util.ListItem;
import java.util.ArrayList;


/**
 *
 * @author ds
 */
public class OpacListResult
{
   private ArrayList<ListItem> list = null;
   private int limit = 20;
   private int totale = 0;
   private int position = 0;
   

   public OpacListResult(ArrayList<ListItem> list)
   {
      this(list, 0);
   }
   
   public OpacListResult(ArrayList<ListItem> list, int totale)
   {
      this.list = list;
      this.totale = totale;
   }
   
   public OpacListResult()
   {
      //
   }

   public ArrayList<ListItem> getList()
   {
      return list;
   }


   public void setList(ArrayList<ListItem> list)
   {
      this.list = list;
   }


   public int getLimit()
   {
      return limit;
   }


   public void setLimit(int limit)
   {
      this.limit = limit;
   }

   public int getPosition()
   {
      return position;
   }


   public void setPosition(int position)
   {
      this.position = position;
   }


   public int getTotale()
   {
      return totale;
   }


   public void setTotale(int totale)
   {
      this.totale = totale;
   }


} //class//
