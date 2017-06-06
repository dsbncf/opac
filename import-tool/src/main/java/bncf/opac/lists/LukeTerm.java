
package bncf.opac.lists;


public class LukeTerm
{

   private final String norm;
   private final String text;
   private int count = 0;

   public LukeTerm(String norm, String text, int count)
   {
      this.norm = norm;
      this.text = text;
      this.count = count;
   }
   
   public LukeTerm(String norm, String text, String count)
   {
      this.norm = norm;
      this.text = text;
      try {
         this.count = Integer.parseInt(count);
      }
      catch (NumberFormatException ex) { }
   }

   public String getNorm()
   {
      return norm;
   }


   public String getText()
   {
      return text;
   }


   public int getCount()
   {
      return count;
   }


} //class//
