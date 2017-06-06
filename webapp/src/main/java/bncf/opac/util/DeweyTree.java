

package bncf.opac.util;


import webdev.webengine.solr.FacetInfo;

import java.util.HashMap;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import webdev.webengine.solr.FacetEntry;


public class DeweyTree
{
   private final static Logger logger = LoggerFactory.getLogger(DeweyTree.class);

   private HashMap<String,DeweyInfo> deweyinfoMap = null;


   public DeweyTree()
   {
      deweyinfoMap = new HashMap<String,DeweyInfo>();
   }


/*
   public void addDeweyInfo(DeweyInfo dwinfo)
   {
      deweyinfoMap.put(dwinfo.getCod(),dwinfo);
   }
   */


   public void addDeweyInfo(String cod, String descr)
   {
      if ((cod == null) || (descr == null))
         return;

      DeweyInfo ckinfo = deweyinfoMap.get(cod);
      if (ckinfo == null)
      {
         deweyinfoMap.put(cod,new DeweyInfo(cod,descr));
         //if (logger.isDebugEnabled())
         //   logger.debug("new: [" + cod + ", " + descr + "]");
      }
      else
      {
         String ckdescr = ckinfo.getDescr();
         if (descr.length() > ckdescr.length())
         {
            ckinfo.setDescr(descr);
            if (logger.isDebugEnabled())
               logger.debug("modified: [" + cod + ", " + ckdescr + " -> " + descr + "]");
         }
      }
   }


   public DeweyInfo[] getDeweyInfoList()
   {
     DeweyInfo[] arr = new DeweyInfo[10];
     boolean valid[] = new boolean[10];
     int count = 0;
     for (int k = 0 ; k < 10 ; k++)
     {
        arr[k] = deweyinfoMap.get(Integer.toString(k));
        valid[k] = ((arr[k] != null) && (arr[k].getCount() > 0));
        if (valid[k]) count++;
     }
     DeweyInfo[] res = new DeweyInfo[count];
     int resoff = 0;
     for (int k = 0 ; k < 10 ; k++)
        if (valid[k])
           res[resoff++] = arr[k];
     return res;
   }


   public DeweyInfo[] getDeweyInfoList(String ini)
   {
     if ((ini == null) || (ini.length() > 3))
        return null;

     DeweyInfo[] arr = new DeweyInfo[10];
     boolean valid[] = new boolean[10];
     int count = 0;
     for (int k = 0 ; k < 10 ; k++)
     {
        arr[k] = deweyinfoMap.get(ini+k);
        valid[k] = ((arr[k] != null) && (arr[k].getCount() > 0));
        if (valid[k]) count++;
     }
     DeweyInfo[] res = new DeweyInfo[count];
     int resoff = 0;
     for (int k = 0 ; k < 10 ; k++)
        if (valid[k])
           res[resoff++] = arr[k];
     return res;
   }


   public DeweyInfo[] getDeweyInfoListAll(String ini)
   {
     if ((ini == null) || (ini.length() > 3))
        return null;

     DeweyInfo[] arr = new DeweyInfo[10];
     for (int k = 0 ; k < 10 ; k++)
     {
        arr[k] = deweyinfoMap.get(ini+k);
     }
     return arr;
   }



   public DeweyInfo getDeweyInfo(String ini)
   {
      if ((ini == null) || (ini.length() > 3))
        return null;

      return deweyinfoMap.get(ini);
   }

   
   public void updateCount(FacetInfo facetInfo)
   {
      for (FacetEntry fe: facetInfo)
      {
         String cod = fe.getName();
         Integer count = fe.getCount();
         for (int k = cod.length() ; k > 0 ; k--)
         {
            DeweyInfo dwy = deweyinfoMap.get(cod.substring(0,k));
            if (dwy != null)
               dwy.setCount(count);
         }
      }
   }

}//class//

