/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package webdev.webengine.solr;

import java.util.regex.Matcher;
import java.util.regex.Pattern;

/**
 *
 * @author ds
 */
public class FacetEntry
{
   private static final String RANGEQUERY_REGEX = "\\[(\\*|\\d+)\\sTO\\s(\\*|\\d+)\\]";
   private static final Pattern rangePattern = Pattern.compile(RANGEQUERY_REGEX);
   
   private String id = null;
   private String name = null;
   private int count = 0;
   long[] range = null;
    
    public FacetEntry(String name, int count)
    {
        setName(name);
        this.count = count;
    }

    public FacetEntry(String name, String count)
    {
        setName(name);
        this.count = Integer.parseInt(count);
    }
    
    public FacetEntry(String id, String name, int count)
    {
        this.id = id;
        setName(name);
        this.count = count;
    }
    
    public final void setName(String name)
    {
        this.name = name;
        extractLuceneRangeValues(name);
    }
    
    public String getName()
    {
        return this.name;
    }
    
    public int getCount()
    {
        return this.count;
    }
    
    public void setId(String id)
    {
        this.id = id;
    }
    
    public String getId()
    {
        return this.id;
    }
    
    
    public long getFromValue(long def)
    {
        return (range == null) ? def : range[0];
    }

    public long getToValue(long def)
    {
        return (range == null) ? def : range[1];
    }

   private void extractLuceneRangeValues(String str)
   {
      Matcher m = rangePattern.matcher(str);
      if (m.matches())
      {
         range = new long[2];
         try
         {
            range[0] = Long.parseLong(m.group(1));
            range[1] = Long.parseLong(m.group(2));
         }
         catch(NumberFormatException ex)
         {
             range = null;
             System.err.println("invalid range values: " + m.group(1) + " , " + m.group(2));
         }
      }
   }
    
    
}//class//
