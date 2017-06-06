/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package webdev.webengine.solr;


import java.text.ParseException;
import java.util.HashMap;
import java.util.Date;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

/**
 *
 * @author ds
 */
public class SolrResultDocument extends HashMap<String,Object>
{
    private static final Logger logger = LoggerFactory.getLogger(SolrResultDocument.class);
    private final SimpleDateFormat dtf = new SimpleDateFormat("yyyy-MM-dd'T'HH:mm:ss'Z'");
    private final SimpleDateFormat tsf = new SimpleDateFormat("yyyy-MM-dd'T'HH:mm:ss.S'Z'");
    private HashMap<String,ArrayList<String>> lists = new HashMap<String,ArrayList<String>>();

    public void put(String type, String name, String value)
    {
        // logger.debug("attibute [" + type + "]: " + name + " = " + value );
        if (type.equals("str"))
            super.put(name, value);
        else
          if (type.equals("float"))
             super.put(name, Float.parseFloat(value));
        else
          if (type.equals("int"))
             super.put(name, Integer.parseInt(value));
        else
          if (type.equals("long"))
             super.put(name, Long.parseLong(value));
        else
          if (type.equals("date"))
          {
              super.put(name, parseDate(value));
          }
        else
              throw new UnsupportedOperationException("Not yet implemented: " + type);
    }

    public String getString(String name)
    {
        return (String) get(name);
    }

    public String getString(String name, String def)
    {
        String s = (String) get(name);
        return (s == null) ? def : s;
    }

    public ArrayList<String> getStringList(String name)
    {
       return lists.get(name);
    }

    public void addStringList(String name, ArrayList<String> list)
    {
       lists.put(name,list);
    }

    public int getInt(String name)
    {
       Integer val = (Integer)get(name);
       return ((val == null) ? 0 : val.intValue());
       /*
       Object obj = get(name);
       if (obj == null)
          return 0;

       String clname = obj.getClass().getSimpleName();
       logger.debug("field-name: " + name + " ; class: " + clname);

       if (clname.equals("Integer"))
          return ((Integer)obj).intValue();

       // type: String
       int res = 0;
       try { res = Integer.parseInt((String) obj); }
       catch (Exception ex) { }
       return res;
        *
        */
    }


    public boolean getBoolean(String name)
    {
       boolean res = false;
       // try { res = (Integer.parseInt((String) get(name)) > 0); }
       //catch (NumberFormatException ex)  { }
       Integer val = (Integer)get(name);
       return ((val != null) && (val.intValue() > 0));
       //return res;
    }


    public Date getDate(String name)
    {
       return (Date) get(name);
    }



    protected StringBuilder toStringBuilder()
    {
        StringBuilder sb = new StringBuilder();
        String[] keys = this.keySet().toArray(new String[0]);
        for (String key : keys)
        {
           sb.append("\n").append(key).append(": ").append(this.get(key));
        }
        for (Map.Entry<String,ArrayList<String>> e : lists.entrySet())
        {
           sb.append("\n").append(e.getKey()).append(": ");
           int c = 0;
           for (String le : e.getValue())
           {
              if (c > 0) sb.append(", ");
              sb.append(le);
           }
        }

        sb.append("\n");
        return sb;
    }


    private Date parseDate(String sdate)
    {
        if (sdate == null)
            return null;
        try
        {
            return (sdate.indexOf('.') > 0) ? tsf.parse(sdate) : dtf.parse(sdate);
        }
        catch (ParseException ex)
        {
            logger.info("data non valida: " + sdate);
            return null;
        }

    }

}
