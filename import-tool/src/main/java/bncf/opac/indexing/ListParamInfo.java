
package bncf.opac.indexing;


import java.util.Properties;
import java.util.regex.Pattern;


public class ListParamInfo
{
   private String name = null;
   private String path = null;
   private boolean enabled = true;
   private boolean overwrite = true;
   private boolean optimize = true;
   private boolean useUnimarc = true;
   private boolean usedb = false;
   private LuceneIndex index = null;
   private static Pattern booltrue = Pattern.compile("[Yy][Ee][Ss]|[Tt][Rr][Uu][Ee]|1");


   public ListParamInfo(String _name, Properties props)
   {
      this.name = _name;
      if (this.name != null)
         setProperties(props);
   }


   public boolean hasIndexInfo()
   {
      return ((path != null) && (name != null));
   }

   public boolean hasLuceneIndex()
   {
      return (index != null);
   }

   public String getName()
   {
      return this.name;
   }

   public void setName(String _name)
   {
      this.name = _name;
   }

   public boolean isEnabled()
   {
      return this.enabled;
   }

   public void setEnabled(boolean _enabled)
   {
      this.enabled = _enabled;
   }

   public boolean getOverwrite()
   {
      return this.overwrite;
   }

   public void setOverwrite(boolean _flag)
   {
      this.overwrite = _flag;
   }

   public boolean getUseUnimarc()
   {
      return this.useUnimarc;
   }

   public void setUseUnimarc(boolean _flag)
   {
      this.useUnimarc = _flag;
   }

   public boolean getOptimize()
   {
      return this.optimize;
   }

   public void setOptimize(boolean _flag)
   {
      this.optimize = _flag;
   }

   public boolean getUseDb()
   {
      return this.usedb;
   }

   public void setUseDb(boolean _flag)
   {
      this.usedb = _flag;
   }

   public String getPath()
   {
      return this.path;
   }

   public void setPath(String _path)
   {
      this.path = _path;
   }

   public LuceneIndex getLuceneIndex()
   {
      return this.index;
   }

   public void setLuceneIndex(LuceneIndex _idx)
   {
      this.index = _idx;
   }


   private void setProperties(Properties props)
   {
      String p = props.getProperty(name + ".enabled");
      if ((p != null) && (!booltrue.matcher(p).matches()))
      {
         enabled = false;
         System.err.println("Warning: indice " + name + " non attivo.");
      }

      if (enabled)
      {
         p = props.getProperty(name + ".create");
         if ((p != null) && (!booltrue.matcher(p).matches()))
         {
            overwrite = false;
         }

         p = props.getProperty(name + ".unimarc");
         if ((p != null) && (!booltrue.matcher(p).matches()))
         {
            useUnimarc = false;
         }

         p = props.getProperty(name + ".optimize");
         if ((p != null) && (!booltrue.matcher(p).matches()))
         {
            optimize = false;
         }

         p = props.getProperty(name + ".usedb");
         if ((p != null) && (booltrue.matcher(p).matches()))
            usedb = true;

         path = props.getProperty(name + ".path");
      }
   }
}

