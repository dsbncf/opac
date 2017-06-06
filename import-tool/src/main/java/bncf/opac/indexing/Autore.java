
package bncf.opac.indexing;

import bncf.opac.utils.StringUtils;




public class Autore extends IndexObject
{
     private String vid       = "";
     private String nome      = null;
     private String norm      = null;
     private String normkey   = null;
     private String normkeysp = null;

     public Autore()
     {
     }

     public String getVid()
     {
       return vid;
     }

     public void setVid( String vid )
     {
       this.vid = (vid == null) ? "" : vid.trim() ;
     }

     public String getNome()
     {
       return this.nome;
     }

     public void setNome( String nome )
     {
       this.nome = (nome == null) ? null : nome.trim();
       if ("".equals(this.nome))
           this.nome = null;
     }

     public String getNomeNoOrderExcl()
     {
         if (nome == null)
           return null;
         String s = nome.replaceFirst("","");
         return s.replaceFirst("","");
     }


     public String getNomeNorm()
     {
       if (nome == null)
          return null;

       if (norm == null)
       {
         norm = StringUtils.utf8ToNorm(nome);
         norm = norm.toLowerCase();
       }
       return norm;
     }

     public String getNomeNormkey()
     {
       return getNomeNormkey(false);
     }
     public String getNomeNormkey(boolean underscoreToSpace)
     {
       if (nome == null)
       {
          System.err.println("Autore: nome == null");
          return null;
       }

       if (normkey == null)
       {
         if (nome.indexOf("") < 10)
            normkey = nome.replaceFirst(".*\\s*","");
         else
            normkey = nome;

         normkeysp = normkey.replaceFirst("_"," "); // TODO: attenzione Unicode!
         if (normkeysp.equals(normkey))
            normkeysp = null;
         else
         {
           normkeysp = StringUtils.utf8ToNorm(normkeysp);
           normkeysp = normkeysp.toLowerCase();
         }
         normkey = StringUtils.utf8ToNorm(normkey);
         normkey = normkey.toLowerCase();
       }
       return underscoreToSpace ? normkeysp : normkey;
     }

     public String getKeywords()
     {
       if (normkey == null)
          getNomeNormkey(false);
       if (normkeysp == null)
          return normkey;
       String keywords = normkey;
       String kw1[] = normkey.split("\\s+");
       String kw2[] = normkeysp.split("\\s+");
       for ( int k = 0; k < kw2.length ; ++k)
       {
          String s = kw2[k];
          for ( int j = 0; j < kw1.length ; ++j)
          {
             if (kw1[j].equals(s))
             {
                s = null;
                break;
             }
          }
          if ( s != null )
            keywords += " " + s;
       }
       return keywords;
     }

     public boolean isValid()
     {
        return (getNomeNorm() != null);
     }

     public String toString()
     {
       return( vid + " : " + getNomeNorm() + " : " + nome );
     }

}

