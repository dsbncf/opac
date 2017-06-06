
package bncf.opac.util;

import java.util.HashMap;
import java.util.Map;


public class ParameterMap extends HashMap<String, String[]>
{
   public ParameterMap()
   {
      super();
   }


   public void put(String key, String val)
   {
      this.put(key, new String[]{ val });
   }


   public ParameterMap(Map<String, String[]> map)
   {
      super(map);
   }


   public String get(String key)
   {
      String arr[] = super.get(key);
      if (arr == null)
      {
         return null;
      }
      int len = arr.length;
      if (len == 0)
      {
         return null;
      }

      for (String s : arr)
      {
         if (s == null)
         {
            continue;
         }
         s = s.trim();
         if (s.equals(""))
         {
            continue;
         }
         return s;
      }
      return null;
   }


   public String get(String key, String dflt)
   {
      String ret = this.get(key);
      return (ret == null || ret.equals("")) ? dflt : ret;
   }


   public String[] getValues(String key)
   {
      return super.get(key);
   }
}//class//

