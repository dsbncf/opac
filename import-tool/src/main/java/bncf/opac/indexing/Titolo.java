
package bncf.opac.indexing;

import bncf.opac.utils.StringUtils;

public class Titolo extends IndexObject
{
     private String nome      = null;
     private String norm      = null;
     private String normkey   = null;
     private String normkeysp = null;

     public Titolo()
     {
     }


     public String getNome()
     {
       return this.nome;
     }

     public void setNome( String _nome )
     {
       this.nome = (_nome == null) ? null : _nome.trim();
       if ("".equals(this.nome))
           this.nome = null;
     }

     public String getNomeNoOrderExcl()
     {
         if (nome == null)
           return null;

         //   //
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
       if (nome == null)
          return null;

       if (normkey == null)
       {
         // al 
         if (nome.indexOf("") < 10)
            normkey = nome.replaceFirst(".*\\s*","");
         else
            normkey = nome;

         normkey = StringUtils.utf8ToNorm(normkey);
         if (normkey != null)
            normkey = normkey.toLowerCase();
         else
         {
            //TODO: titolo normalizzato is null //
            normkey = "_";
         }
       }
       return  normkey;
     }


     public boolean isValid()
     {
        return (getNomeNorm() != null);
     }

     public String toString()
     {
       return( getNomeNorm() + " : " + nome );
     }
}

