
package bncf.opac.indexing;

import bncf.opac.utils.StringUtils;
import java.lang.NumberFormatException;



public class Dewey extends IndexObject
{
     private String  cod = null;
     private String ediz = null;
     private String nome = null;
     private String norm = null;

     public Dewey()
     {
     }

     public String getCod()
     {
       return cod;
     }

     public void setCod( String _cod )
     {
       if (_cod != null)
       {
          this.cod = _cod.replaceAll("\\.","").trim();
          this.cod = this.cod.replaceAll("\\s","");
          if ( this.cod.length() < 3 )
          {
             this.cod = null;
             return;
          }
          try
          {
             Integer.parseInt(this.cod.substring(0,3));
          }
          catch(NumberFormatException ex)
          {
            System.err.println("NumberFormatException for '" + cod.substring(0,3) + "'");
            this.cod = null;
            return;
          }
       }
     }

     public short getPosCod(int pos)
     {
       if ((cod != null) && (pos < 3) && (pos >= 0) && (cod.length() > 2))
       {
            return  (short)Integer.parseInt(cod.substring(pos,pos+1));
       }
       return -1;
     }


     public String getEdiz()
     {
       return ediz;
     }

     public void setEdiz( String _ediz )
     {
       if (_ediz != null)
       {
           this.ediz = _ediz.replaceAll("\\.","").trim();
       }
     }

     public String getDescr()
     {
       return this.nome;
     }

     public void setDescr( String _nome )
     {
       this.nome = (_nome == null) ? null : _nome.trim();
       if ("".equals(this.nome))
           this.nome = null;
     }

     public String getDescrNorm()
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

     public boolean isValid()
     {
        return (cod != null);
     }

     public String toString()
     {
       return( "(ediz=" + ediz + ") " + cod + " : " + getDescrNorm() + " : " + nome );
     }

}
