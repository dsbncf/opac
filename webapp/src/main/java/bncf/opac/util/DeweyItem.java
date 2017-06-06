


package bncf.opac.util;



import java.util.*;

public class DeweyItem
{
   private String cod  = null;
   private String nome = null;

   private int count = 0;
   private int position = 0; 

   public DeweyItem()
   {
   }

   public DeweyItem(int pos, String cod, String nome, int count)
   {
     this.position = pos;
     setCod(cod);
     this.nome = nome;
     this.count = count;
   }

   public String getName()
   {
      return this.nome;
   }

   public void setName(String nome)
   {
      this.nome = nome;
   }

   public String getCod()
   {
      return this.cod;
   }

   public void setCod(String cod)
   {
      this.cod = (cod == null) ? cod : cod.trim();
   }

   public int getCount()
   {
      return this.count;
   }

   public void setCount(int val)
   {
      this.count = val;
   }

   public int getPosition()
   {
      return this.position;
   }

   public void setPosition(int val)
   {
      this.position = val;
   }
}

