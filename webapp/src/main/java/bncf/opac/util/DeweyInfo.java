


package bncf.opac.util;





public class DeweyInfo
{
   private String cod = null; 
   private String descr = null;
   private int count = 0;

   public DeweyInfo() { }

   public DeweyInfo(String cod, String descr)
   {
     this.cod = cod;
     this.descr = descr;
   }

   public String getCod()           { return this.cod; }
   public void   setCod(String cod) { this.cod = cod; }

   public String getDescr()             { return this.descr; }
   public void   setDescr(String descr) { this.descr = descr; }

   public int  getCount()
   {
      return this.count;
   } 

   public void setCount(Integer val)
   {
      if (val != null) this.count += val.intValue();
   }

   public String toString()
   {
      StringBuilder sb = new StringBuilder();
      sb.append(cod).append(" : ").append(descr).append(" [").append(count).append("]");
      return sb.toString();
   }
}

