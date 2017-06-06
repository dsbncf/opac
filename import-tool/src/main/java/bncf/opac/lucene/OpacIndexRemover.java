
package bncf.opac.lucene;

import org.apache.lucene.index.IndexReader;
import org.apache.lucene.index.Term;
import org.apache.lucene.search.IndexSearcher;
import org.apache.lucene.search.TermQuery;
import org.apache.lucene.search.TopDocs;
import org.apache.lucene.store.Directory;
import org.apache.lucene.store.NIOFSDirectory;

import java.io.File;
import java.io.IOException;
import java.util.Properties;


/**
 * Indicizza i records estratti dal file xml come documento Lucene.
 */

public class OpacIndexRemover
{
  private boolean readonly = false;

  private String unimarcindexpath = null;
  private String notiziaindexpath = null;

  private IndexReader notiziareader = null;
  private IndexReader unimarcreader = null;

  private IndexSearcher notiziasearcher = null;
  private IndexSearcher unimarcsearcher = null;


 public OpacIndexRemover( Properties props )
                  throws Exception
 {
    notiziaindexpath = props.getProperty("notizia.index");
    if (notiziaindexpath == null)
        throw new Exception ("Errore: index delle notizie non definito (notizia.index)");

    //unimarcindexpath = (String) props.getProperty("unimarc.index");
    //if (unimarcindexpath == null)
    //    System.err.println("Warning: index dei records unimarcxml non definito");

    init();
 }

 private void init() throws IOException
 {
    Directory dir = new NIOFSDirectory(new File(notiziaindexpath));
     notiziareader   = IndexReader.open(dir);
     notiziasearcher = new IndexSearcher(notiziareader);

     if (unimarcindexpath != null)
     {
        Directory unidir = new NIOFSDirectory(new File(unimarcindexpath));
        unimarcreader   = IndexReader.open(unidir);
        unimarcsearcher = new IndexSearcher(unimarcreader);
     }
 }

 public boolean getReadonly()
 {
    return this.readonly;
 }

 public void setReadonly( boolean flag )
 {
    this.readonly = flag;
 }


 public void close( ) throws IOException
 {
     notiziasearcher.close();
     //notiziareader.commit();
     notiziareader.close();
     if (unimarcsearcher != null)
        unimarcsearcher.close();
     if (unimarcreader != null)
        unimarcreader.close();
 }

 // ! Nota: l'indice notizia utilizza un idn convertito in lower case
 //         l'indice unimarc invece utilizza un idn in upper case.
 public boolean deleteIdn(String idn) throws IOException
 {
   int notizia_id = -1;
   int unimarc_id = -1;
   int maxdel = 1000;

   if (idn == null)
       return false;

   String idnlc = idn.toLowerCase();

   Term idn_term  = new Term("idn", idnlc);
   TermQuery tqlc = new TermQuery(idn_term);

    final TopDocs topDocs = notiziasearcher.search(tqlc, maxdel);
    int hits = topDocs.totalHits;

    if (hits > 1)
   {
         System.err.println("IDN=" + idnlc + ": occorrenza multipla (Notizia): " + hits );
   }
   if (hits < 1)
   {
         System.err.println("IDN=" + idnlc + ": Notizia non presente");
         return false;
   }

   if (! readonly)
      notiziareader.deleteDocuments(idn_term);

   return true;
 }




} // class //
