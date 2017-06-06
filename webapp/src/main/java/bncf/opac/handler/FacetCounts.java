

package bncf.opac.handler;

import java.util.ArrayList;

import webdev.webengine.solr.FacetInfo;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import webdev.webengine.solr.FacetEntry;


public class FacetCounts extends ArrayList<FacetInfo>
{
  private Logger  logger = LoggerFactory.getLogger(FacetCounts.class);


  public FacetCounts()
  {
     super();
  }


  public void add(String facetname, String key, Integer count)
  {
     //SetEntry<String,Integer> se = new SetEntry<String,Integer>(key, count);
     FacetEntry fentry = new FacetEntry(key, facetname, count);
     FacetInfo finfo = getFacetInfo(facetname,true);
     finfo.add(fentry);
     //finfo.add(se);
     //if (logger.isDebugEnabled())
     //   logger.debug("added FacetInfo: " + facetname + "[" + key + ":" + count + "]");
  }


  public ArrayList<String> getNames()
  {
     ArrayList<String> result = new ArrayList<String>(this.size());
     for (FacetInfo finfo: this)
        result.add(finfo.getName());
     return result;
  }


  public FacetInfo getFacetInfo(String name)
  {
     return getFacetInfo(name,false);
  }



  // ------------------------------------------------------------

  private FacetInfo getFacetInfo(String name, boolean create)
  {
     FacetInfo result = null;
     if (name != null)
     {
        for (FacetInfo finfo: this)
        {
           if (name.equals(finfo.getName()))
           {
              return finfo; 
           }
        }
        // not present in list, so create and add it.
        if ((result == null) && create)
        {
           result = new FacetInfo(name);
           this.add(result);
        }
     }
     return result;
  }



}//class//
