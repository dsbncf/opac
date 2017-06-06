
package bncf.opac.indexing;



import java.io.IOException;
import java.io.InputStream;

import org.apache.commons.digester.Digester;
import org.apache.lucene.document.Document;

import java.util.Properties;


/** Indicizza i records estratti dal file xml come documento Lucene.
 *
 * @author  $Author: ds $
 * @version $Revision: 1.5 $
 *
 * Utilizza il Digester di Apache
 */

public class OpacIndexReader
{
  private InputStream inps   = null;
  private Digester digester  = null;
  private OpacIndexWriter writer = null;
 
 
 public OpacIndexReader( InputStream  _inps )
 {
   this.inps = _inps;
 }


 public void load( OpacIndexWriter _writer )
 {
   this.writer = _writer;
   this.load(false);
 }



 private void load( boolean readonly )
 {
   if (inps == null)
     return;

   if (writer == null)
   {
     System.err.println("Errore: OpacIndexReader: nessun writer definito.");
     return;
   }

   digester = new Digester();
   digester.push(writer);
   digester.setValidating(false);
   try
   {
     digester.addObjectCreate("collection/notizia", OpacIndexDocument.class );
     digester.addBeanPropertySetter( "collection/notizia/idn", "idn" );

     digester.addCallMethod( "collection/notizia/titolodisplay",       "addTitoloDisplay", 0);
     digester.addCallMethod( "collection/notizia/autoredisplay",       "addAutoreDisplay", 0);
 
     digester.addObjectCreate( "collection/notizia/titoli/titolo", Titolo.class );
     digester.addSetNext(      "collection/notizia/titoli/titolo", "addTitolo" );
     digester.addCallMethod(   "collection/notizia/titoli/titolo", "setNome", 0 );

     digester.addObjectCreate(  "collection/notizia/autori/autore", Autore.class );
     digester.addSetNext(       "collection/notizia/autori/autore", "addAutore" );
     digester.addSetProperties( "collection/notizia/autori/autore", "vid", "vid" );
     digester.addCallMethod(    "collection/notizia/autori/autore", "setNome", 0 );

     digester.addObjectCreate(  "collection/notizia/soggetti/soggetto", Soggetto.class );
     digester.addSetNext(       "collection/notizia/soggetti/soggetto", "addSoggetto" );
     digester.addSetProperties( "collection/notizia/soggetti/soggetto", "cid", "cid" );
     digester.addCallMethod(    "collection/notizia/soggetti/soggetto", "setNome", 0 );

     digester.addObjectCreate ("collection/notizia/classi/dewey",  Dewey.class );
     digester.addSetNext      ("collection/notizia/classi/dewey", "addDewey" );
     digester.addSetProperties("collection/notizia/classi/dewey", "ed", "ediz" );
     digester.addSetProperties("collection/notizia/classi/dewey", "cod", "cod" );
     digester.addCallMethod   ("collection/notizia/classi/dewey", "setDescr" , 0);

     digester.addCallMethod( "collection/notizia/titolokw",       "addTitoloKw" , 0);
     digester.addCallMethod( "collection/notizia/bid_tutti/bid",  "addBidTutti" , 0);

     digester.addCallMethod( "collection/notizia/collana",        "addCollana" , 0);
     digester.addCallMethod( "collection/notizia/editore",        "addEditore" , 0);
     digester.addCallMethod( "collection/notizia/luoghi/luogo",   "addLuogo" , 0);
     digester.addCallMethod( "collection/notizia/marca",          "addMarca" , 0);
     digester.addCallMethod( "collection/notizia/colloc",         "addCollocazione" , 0);
     digester.addCallMethod( "collection/notizia/inventario",     "addInventario" , 0);
     digester.addCallMethod( "collection/notizia/identificatori/identificatore",
                                                                  "addIdentificatore" , 0);
     digester.addCallMethod( "collection/notizia/keywords/kw_titoli", "addKeywords" , 0);
     digester.addCallMethod( "collection/notizia/keywords/mid",    "addKeywords" , 0);//obsol.
     digester.addCallMethod( "collection/notizia/keywords/note",   "addKeywords" , 0);//obsol.
     digester.addCallMethod( "collection/notizia/keywords/kw_mid",    "addKeywords" , 0);
     digester.addCallMethod( "collection/notizia/keywords/kw_note",   "addKeywords" , 0);
     digester.addCallMethod( "collection/notizia/keywords/kw_205",    "addKeywords" , 0);
     digester.addCallMethod( "collection/notizia/keywords/kw_206",    "addKeywords" , 0);
     digester.addCallMethod( "collection/notizia/keywords/kw_207",    "addKeywords" , 0);
     digester.addCallMethod( "collection/notizia/keywords/kw_208",    "addKeywords" , 0);
     digester.addCallMethod( "collection/notizia/keywords/kw_215",    "addKeywords" , 0);
     digester.addCallMethod( "collection/notizia/keywords/kw_686",    "addKeywords" , 0);
     digester.addCallMethod( "collection/notizia/keywords/kw_950e",   "addKeywords" , 0);
     digester.addCallMethod( "collection/notizia/keywords/kw_950e33",   "addKeywords950e33" , 0);

     // filtri //
     digester.addCallMethod( "collection/notizia/categoria",      "addCategoria" , 0);
     digester.addCallMethod( "collection/notizia/categorie",      "addCategorie" , 0);//obsol.
     digester.addCallMethod( "collection/notizia/lingua",         "addLingua" , 0);
     digester.addCallMethod( "collection/notizia/paese",          "addPaese" , 0);
     digester.addCallMethod( "collection/notizia/data_agg",       "addDataAggiornamento" , 0);
     digester.addCallMethod( "collection/notizia/anno1",          "addAnno1" , 0);
     digester.addCallMethod( "collection/notizia/anno2",          "addAnno2" , 0);
     digester.addCallMethod( "collection/notizia/natura",         "addNatura" , 0);
     digester.addCallMethod( "collection/notizia/biblioteca",     "addBiblioteca" , 0);
     digester.addCallMethod( "collection/notizia/tipo_mat",       "addTipoMateriale" , 0);
     digester.addCallMethod( "collection/notizia/tipo_dig",       "addTipoDig" , 0);



     digester.addSetNext("collection/notizia", "indexNotizia" );

     digester.parse(inps);
   }
   catch (IOException ex)
   {
     System.err.println("impossibile leggere il file xmlmarc: " + ex.getMessage());
   }
   catch (org.xml.sax.SAXException ex)
   {
     System.err.println("Errori di formato nel file xmlmarc: " + ex.getMessage());
   }
 }


} // class //
