


package bncf.opac.util;



public class ListItem
{
   private int position = 0; 
   private String  link    = null;
   private String  display = null;
   private Integer count   = null;

   public ListItem()
   {
   }

   public ListItem(int pos, String display, String link, Integer count)
   {
     this.position = pos;
     this.link = link;
     this.display = display;
     this.count = count;
   }

   public String getDisplay()
   {
      return this.display;
   }

   public void setDisplay(String display)
   {
      this.display = display;
   }

   public String getLink()
   {
      return this.link;
   }

   public void setLink(String link)
   {
      this.link = link;
   }

   public Integer getCount()
   {
      return this.count;
   }

   public void setCount(Integer count)
   {
      this.count = count;
   }

   public int getPosition()
   {
      return this.position;
   }

   public void setPosition(int pos)
   {
      this.position = pos;
   }
}

