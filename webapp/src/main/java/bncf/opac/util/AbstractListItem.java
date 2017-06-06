


package bncf.opac.util;




public class AbstractListItem<N,V>
{
   private int position = 0; 
   private N key = null;
   private V val = null;

   public AbstractListItem()
   {
   }

   public AbstractListItem(int pos, N key, V val)
   {
     this.position = pos;
     this.key = key;
     this.val = val;
   }

   public N getKey()
   {
      return this.key;
   }

   public void setKey(N key)
   {
      this.key = key;
   }

   public V getValue()
   {
      return this.val;
   }

   public void setValue(V val)
   {
      this.val = val;
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

