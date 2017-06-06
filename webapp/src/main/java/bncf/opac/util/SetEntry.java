


package bncf.opac.util;



import java.util.*;

public class SetEntry<K,V>
{
   private K key = null;
   private V val = null;

   public SetEntry()
   {
   }

   public SetEntry(K key, V val)
   {
     this.key = key;
     this.val = val;
   }

   public K getKey()
   {
      return this.key;
   }

   public void setKey(K key)
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
}

