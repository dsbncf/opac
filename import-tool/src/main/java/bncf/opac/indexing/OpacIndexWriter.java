

package bncf.opac.indexing;

import java.io.File;
import java.io.IOException;
import java.io.InputStream;

import org.apache.commons.digester.Digester;
import org.apache.lucene.document.Document;
import org.apache.lucene.document.Field;
import org.apache.lucene.index.IndexReader;
import org.apache.lucene.index.Term;
import org.apache.lucene.search.IndexSearcher;
import org.apache.lucene.search.TermQuery;

import java.util.Collection;
import java.util.Iterator;
import java.util.HashMap;
import java.util.Properties;
import java.util.regex.Pattern;

import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

import bncf.opac.utils.StringUtils;
import org.apache.lucene.search.TopDocs;
import org.apache.lucene.store.Directory;
import org.apache.lucene.store.NIOFSDirectory;


/**
 *  Indicizza i records estratti dal file xml come documento Lucene.
 */


public class OpacIndexWriter
{
  // private Digester digester = null;
  private HashMap dblists  = null;
  private String  unimarcindexpath = null;

  private Connection         dbconn      = null;
  private CallableStatement  cs_autore   = null;
  private CallableStatement  cs_soggetto = null;
  private CallableStatement  cs_titolo   = null;
  private CallableStatement  cs_dewey    = null;

  private LuceneIndex  notiziaindex      = null;
  private LuceneIndex  deweyindex        = null;
  private IndexSearcher umcsearcher    = null;

  //private boolean         useunimarc     = false;
  //private boolean         dummyrun       = false;
  private boolean         usedb          = false;
  
  private String[] listnames = { "autore", "dewey", "soggetto", "titolo" };

 
 public OpacIndexWriter()
 {
 }
 

 public void init( Properties props ) throws Exception
 {
   //Pattern booltrue = Pattern.compile("[Yy][Ee][Ss]|[Tt][Rr][Uu][Ee]|1");

   unimarcindexpath = props.getProperty("unimarcindex");
   if (unimarcindexpath == null)
      throw new Exception ("Errore: unimarc index non definito");


   String indexname = "notizia";
   ListParamInfo indexinfo = new ListParamInfo(indexname,props);
   if (indexinfo.isEnabled())
   {
     if (indexinfo.hasIndexInfo())
     {
       System.err.println("Indice delle notizie: " );
       System.err.println("   sostituzione indice esistente: " + indexinfo.getOverwrite() );
       System.err.println("           ottimizzazione indice: " + indexinfo.getOptimize() );
       notiziaindex = openIndex( indexname, indexinfo.getPath(),
                                    indexinfo.getOverwrite(),indexinfo.getOptimize() );
       if (notiziaindex == null)
           throw new Exception( "Errore di apertura dell'indice: " + indexinfo.getPath() );

       indexinfo.setLuceneIndex(notiziaindex);
       openUnimarcIndex(unimarcindexpath);
     }
   }
   if (notiziaindex == null)
   {
     System.err.println( "WARNING: L'indice delle notizia non verra' aggiornato." );
   } 

   for (int j = 0 ; j < listnames.length ; ++j)
   {
      String listname = listnames[j];
      ListParamInfo listinfo = new ListParamInfo(listname,props);
      if (listinfo.isEnabled())
      {
          if (dblists == null)
             dblists = new HashMap();
          dblists.put(listname,listinfo);
          if (listinfo.getUseDb() == true)
            usedb = true;
      }
   }

   if (usedb)
       this.connectDB(props);
   else
      System.err.println( "WARNING: Il database non verra' aggiornato." );
 }


 public LuceneIndex openIndex(String name,  String indexpath,
                               boolean create, boolean optimize )
 {
   int flag = (create) ? LuceneIndex.WRITECREATE : LuceneIndex.WRITE ; 

   LuceneIndex lucidx = new LuceneIndex(flag, indexpath);
   lucidx.setOptimize(optimize);
   try
   {
     lucidx.open();
     return lucidx;
   }
   catch(java.io.IOException ex)
   {
     System.err.println( "Errore: impossibile aprire il file '"
                          + indexpath + "': " + ex.getMessage() );
   }
   return null;
 }
 

 private void connectDB(Properties props) throws Exception
 {
     String driver = props.getProperty("dbdriver");
     if (driver == null)
        throw new Exception ("Errore: database driver non definito");

     String driverid = props.getProperty("dbdriverid");
     if (driverid == null)
        throw new Exception ("Errore: database driverid non definito");

     String dbuser = props.getProperty("dbuser");
     if (dbuser == null)
        throw new Exception ("Errore: database user non definito");

     String dbpass = props.getProperty("dbpass");
     if (dbpass == null)
        throw new Exception ("Errore: database password non definito");

     String dbhost = props.getProperty("dbhost");
     if (dbhost == null)
        throw new Exception ("Errore: database host non definito");

     String dbname = props.getProperty("dbname");
     if (dbname == null)
        throw new Exception ("Errore: database name non definito");

     String dburl = driverid + "//" + dbhost + "/" + dbname;

     Class.forName(driver);
     dbconn = DriverManager.getConnection(dburl, dbuser, dbpass);

     System.err.println("Databases connected: " + dburl );
 }



 public void close()
 {
   try
   {
      if (umcsearcher != null)
         umcsearcher.close();
      if (notiziaindex != null)
         notiziaindex.close();
   }
   catch(java.io.IOException ex)
   {
         System.err.println( "Errore durante la chiusura dell'indice"
                             + notiziaindex.getIndexLocation() );
   }
   try
   {
      if (dbconn != null)
      {
         dbconn.commit();
         System.err.println("Databases committed.");
         dbconn.close();
      }
   }
   catch(java.sql.SQLException ex)
   {
         System.err.println( "Errore durante la chiusura della connessione al database: "
                             + ex.getMessage() );
   }
 }



 public void indexNotizia(Object obj)
 {
   if (obj == null)
   {
     System.err.println("Errore: indexDocument(doc): argomento non valido.");
     return;
   }

   OpacIndexDocument oid = (OpacIndexDocument)obj;
   String   idn = oid.getIdn();
   Document doc = oid.getDocument();
   if ( (doc == null) || (idn == null) )
   {
      System.err.println("document is null");
      return;
   }
   System.err.println(idn);


   if (notiziaindex != null)
   {
          if (umcsearcher != null)
          {
             try
             {
               String umc = getUnimarcXml(oid.getIdn());
               if (umc != null)
               {
                 doc.add(new Field("unimarcxml", umc, Field.Store.YES, Field.Index.NO));

               }
             }
             catch (Exception ex)
             {
                System.err.println("Error getting UnimarcXml data: " + ex.getMessage());
             }
          }
          notiziaindex.addDocument(doc);
   }


   if (dblists != null)
   {
        ListParamInfo pinfo;
        pinfo = (ListParamInfo) dblists.get("autore");
        if ( (pinfo != null) && pinfo.isEnabled() )
        {
          saveAutori( oid.getIdn(), oid.getAutori(), pinfo.getUseDb() );
        }

        pinfo = (ListParamInfo) dblists.get("soggetto");
        if ((pinfo != null) && pinfo.isEnabled() )
        {
          saveSoggetti( oid.getIdn(), oid.getSoggetti(), pinfo.getUseDb() );
        }

        pinfo = (ListParamInfo) dblists.get("titolo");
        if ((pinfo != null) && pinfo.isEnabled() )
        {
          saveTitoli( oid.getIdn(), oid.getTitoli(), pinfo.getUseDb() );
        }

        pinfo = (ListParamInfo) dblists.get("dewey");
        if ((pinfo != null) && pinfo.isEnabled() )
        {
          saveDeweys( oid.getIdn(), oid.getDeweys(), pinfo.getUseDb() );
        }
   }
 }


 private void saveAutori(String idn, Collection autori, boolean dbwrite )
 {
   if ((autori != null) && (idn != null))
   {
     Iterator iter = autori.iterator();
     while (iter.hasNext())
     {
        Autore autore = (Autore)iter.next();
        if (!autore.isValid())
          continue;

        if (dbwrite)
        try
        {
          if (cs_autore == null)
          {                                  // idn, autore, autorenorm //
            cs_autore = dbconn.prepareCall( "{call autorenotizia_add(?,?,?,?,?,?)}" );
          }
          else
            cs_autore.clearParameters();

          String aoe   = autore.getNomeNoOrderExcl();
          String ank   = autore.getNomeNormkey();
          String anksp = autore.getNomeNormkey(true);

          System.err.println(idn +"\t" + aoe + "\n\t" + ank + "\n\t" + anksp);

          if (aoe.length() > 194)   aoe   = aoe.substring(0,194);
          if (ank.length() > 200)   ank   = ank.substring(0,200);
          if (anksp != null)
            if (anksp.length() > 200) anksp = anksp.substring(0,200);

          cs_autore.setString(1, idn);
          cs_autore.setBytes(2, aoe.getBytes());
          cs_autore.setString(3, ank );
          cs_autore.setString(4, anksp );
          cs_autore.registerOutParameter(5, java.sql.Types.INTEGER);
          cs_autore.registerOutParameter(6, java.sql.Types.VARCHAR, 255);
          cs_autore.executeUpdate();

          int ret_id = cs_autore.getInt(5);
          String ret_msg = cs_autore.getString(6);
          System.err.println("[" + ret_id + "] " + ret_msg);
        }
        catch (SQLException ex)
        {
          System.err.println("\nErrori durante l'aggiornamento del DB autorenotizia_add(IDN = " + idn + "): "
                              + ex.getMessage());
          System.exit(1);
        }
     }//while iter...//
   } // if conn ... //
 }




 private void saveSoggetti( String idn, Collection soggetti, boolean dbwrite )
 {
   if ((soggetti != null) && (idn != null))
   {
     Iterator iter = soggetti.iterator();
     while (iter.hasNext())
     {
        Soggetto soggetto = (Soggetto)iter.next();
        if (!soggetto.isValid())
          continue;

        if (dbwrite)
        try
        {
          if (cs_soggetto == null)
          {                                  // idn, soggetto, soggettonorm //
            cs_soggetto = dbconn.prepareCall( "{call soggettonotizia_add(?,?,?,?,?,?)}" );
          }
          else
            cs_soggetto.clearParameters();

          //System.err.println(idn +"\t" + soggetto + "\n\t" + soggettonorm); 

          String oe   = soggetto.getNomeNoOrderExcl();
          String nk   = soggetto.getNomeNormkey();

          if (oe.length() > 194) oe = oe.substring(0,194);
          if (nk.length() > 200) nk = nk.substring(0,200);

          cs_soggetto.setString(1, idn);
          cs_soggetto.setString(2, soggetto.getCid() );
          cs_soggetto.setBytes(3, oe.getBytes() );
          cs_soggetto.setString(4, nk );
          cs_soggetto.registerOutParameter(5, java.sql.Types.INTEGER);
          cs_soggetto.registerOutParameter(6, java.sql.Types.VARCHAR, 255);

          cs_soggetto.executeUpdate();
      }
        catch (Exception ex)
        {
          System.err.println("\nErrori durante l'aggiornamento del DB soggettonotizia_add(IDN = " + idn + "): "
                              + ex.getMessage());
          System.exit(1);
        }
     }//while iter...//
   } // if conn ... //
 }


 private void saveTitoli( String idn, Collection titoli, boolean dbwrite )
 {
   if ((titoli != null) && (idn != null))
   {
     Iterator iter = titoli.iterator();
     while (iter.hasNext())
     {
        Titolo titolo = (Titolo)iter.next();
        if (!titolo.isValid())
          continue;

        if (dbwrite)
        try
        {
          if (cs_titolo == null)
          {                                  // idn, titolo, titolonorm //
            cs_titolo = dbconn.prepareCall( "{call titolonotizia_add(?,?,?,?,?)}" );
          }
          else
            cs_titolo.clearParameters();

          String oe   = titolo.getNomeNoOrderExcl();
          String nk   = titolo.getNomeNormkey();

          if (oe.length() > 970) oe = oe.substring(0,970);
          if (nk.length() > 250) nk = nk.substring(0,250);

          cs_titolo.setString(1, idn);
          cs_titolo.setBytes(2, oe.getBytes() );
          cs_titolo.setString(3, nk );
          cs_titolo.registerOutParameter(4, java.sql.Types.INTEGER);
          cs_titolo.registerOutParameter(5, java.sql.Types.VARCHAR, 255);
          cs_titolo.executeUpdate();
      }
        catch (Exception ex)
        {
          System.err.println("\nErrori durante l'aggiornamento del DB titolonotizia_add(IDN = " + idn + "): "
                              + ex.getMessage());
          System.exit(1);
        }
     }//while iter...//
   } // if conn ... //
 }


 private void indexDeweys(String idn, Collection deweys )
 {
   if ((deweys != null) && (idn != null))
   {
     if (deweyindex == null)
     {
        System.err.println("Errore: indice dewey non definito (nessun indice)");
        return;
     }
     Document deweydoc = null;

     Iterator iter = deweys.iterator();
     while (iter.hasNext())
     {
        Dewey dewey = (Dewey)iter.next();
        if (!dewey.isValid())
          continue;

        if (deweydoc == null)
          deweydoc = new Document();

        String s = StringUtils.utf8ToNorm(dewey.getCod());
        if (s != null)
        {
           deweydoc.add(new Field("classe", s, Field.Store.YES, Field.Index.NOT_ANALYZED));

        }

        short k = dewey.getPosCod(0);
        if (k >= 0)
        {
           deweydoc.add(new Field("c1", Short.toString(k), Field.Store.NO, Field.Index.ANALYZED));

        }
        k = dewey.getPosCod(1);
        if (k >= 0)
        {
           deweydoc.add(new Field("c2", Short.toString(k), Field.Store.NO, Field.Index.ANALYZED));
        }
        k = dewey.getPosCod(2);
        if (k >= 0)
        {
           deweydoc.add(new Field("c3", Short.toString(k), Field.Store.NO, Field.Index.ANALYZED));
        }

        s = dewey.getEdiz();
        if (s != null)
        {
           s = StringUtils.utf8ToNorm(s);
           deweydoc.add(new Field("edizione", s, Field.Store.YES, Field.Index.NOT_ANALYZED));
        }
        s = dewey.getDescr();
        if (s != null)
        {
           deweydoc.add(new Field("descrizione", s, Field.Store.YES, Field.Index.NO));
        }
        s = dewey.getDescrNorm();
        if (s != null)
        {
           deweydoc.add(new Field("keywords", s, Field.Store.NO, Field.Index.ANALYZED));
        }
        deweyindex.addDocument(deweydoc);
     }
   }
 }

 private void saveDeweys(String idn, Collection deweys, boolean dbwrite )
 {
   if ((deweys != null) && (idn != null))
   {
     Iterator iter = deweys.iterator();
     while (iter.hasNext())
     {
        Dewey dewey = (Dewey)iter.next();
        if (!dewey.isValid())
        {
          System.err.println("Dewey non valid: " + dewey.toString());
          continue;
        }

        if (dbwrite)
        try
        {
          if (cs_dewey == null)
          {                                  // idn, cod, ediz, class_descr, norm //
            cs_dewey = dbconn.prepareCall( "{call deweynotizia_add(?,?,?,?,?,?,?,?,?,?)}" );
          }
          else
            cs_dewey.clearParameters();

          String de   = dewey.getDescr();

          byte[] debytes = null; 
          if (de != null)
          {
            if (de.length() > 249) de = de.substring(0,249);
            debytes = de.getBytes();
          }

          cs_dewey.setString(1, idn);
          cs_dewey.setShort (2, dewey.getPosCod(0) );
          cs_dewey.setShort (3, dewey.getPosCod(1) );
          cs_dewey.setShort (4, dewey.getPosCod(2) );
          cs_dewey.setString(5, dewey.getCod() );
          cs_dewey.setString(6, dewey.getEdiz() );
          cs_dewey.setString(7, de );
          cs_dewey.setBytes (8, debytes );
          cs_dewey.registerOutParameter(9, java.sql.Types.INTEGER);
          cs_dewey.registerOutParameter(10, java.sql.Types.VARCHAR, 255);
          cs_dewey.executeUpdate();
        }
        catch (Exception ex)
        {
          System.err.println("\nErrori durante l'aggiornamento del DB deweynotizia_add(IDN = "
                               + idn + "): " + ex.getMessage());
        }
     }//while iter...//
   } // if conn ... //
 }

 private void openUnimarcIndex(String umcidx) throws IOException
 {
     Directory dir = new NIOFSDirectory(new File(umcidx));
     IndexReader umcreader   = IndexReader.open(dir);
     umcsearcher = new IndexSearcher(umcreader);
     System.err.println("apertura dell'indice " + umcidx + " (ro)");
 }

 
 /** Ritorna il documento che corrisponde all idn.
  *  @returns  il documento che corrisponde all'idn specificato, altrimenti null.
  *   Se sono presenti occorenze multiple viene ritornato l'ultimo della hitlist.
  *                
  */
 private Document getDocument(String idn) throws IOException
 {
    if (umcsearcher == null)
       return null;

    TermQuery tq = new TermQuery(new Term("idn", idn));
    TopDocs topDocs = umcsearcher.search(tq, 1000);
    int num_hits = topDocs.totalHits;
                                                                                                              
   if (num_hits < 1)
   {
         System.err.println("IDN non presente nel indice.");
         return null;
   }
   if (num_hits > 1)
   {
         System.err.println("Warning: IDN occorrenze multiple: " + num_hits );
   }

    int docId = topDocs.scoreDocs[topDocs.scoreDocs.length - 1].doc;
    return umcsearcher.doc(docId);
 }
 
 private String getUnimarcXml(String idn) throws Exception
 {
   if (umcsearcher == null)
     throw new Exception("Lucene searcher non definito");
   
   Document doc = getDocument(idn);
   if (doc == null)
   {
       System.err.println("Documento unimarc non trovato: " + idn);
       return null;
   }

   Field    fld = doc.getField("unimarc");
   if (fld == null)
   {
       System.err.println("Field unimarc non trovato: " + idn);
       return null;
   }
    
   return fld.stringValue();
 }
 

} // class //
