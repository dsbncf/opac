
package bncf.opac.lucene;


import org.apache.lucene.index.IndexReader;
import org.apache.lucene.search.IndexSearcher;
import org.apache.lucene.search.Query;
import org.apache.lucene.search.TermQuery;
import org.apache.lucene.index.Term;
import org.apache.lucene.search.TopDocs;
import org.apache.lucene.store.Directory;
import org.apache.lucene.store.NIOFSDirectory;

import java.io.File;
import java.io.IOException;
import java.text.NumberFormat;
import java.text.SimpleDateFormat;
import java.util.Date;


/**
 * <code>AddressBookSearcher</code> class provides a simple
 * example of searching with Lucene.  It looks for an entry whose
 * 'name' field contains keyword 'Zane'.  The index being searched
 * is called "address-book", located in a temporary directory.
 */
public class OpacNaturaCount
{
    public static void main(String[] args) throws IOException
    {
        String aggdata  = null;

        if (args.length < 1)
        {
           System.err.println("usage:  java OpacNaturaCount index-path [dd/MM/yyyy]" );
           System.exit(1);
        }
        String indexDir = args[0];
        
        if (args.length > 1)
           aggdata  = args[1];
        else
        {
              Date date = new Date();
              SimpleDateFormat formatter = new SimpleDateFormat("dd/MM/yyyy");
              aggdata = formatter.format(date);
        }


        System.err.println("index: " + indexDir );

        Directory dir = new NIOFSDirectory(new File(indexDir));
        IndexReader indexReader   = IndexReader.open(dir);
        IndexSearcher searcher = new IndexSearcher(indexReader);
        int numDocs = indexReader.numDocs();

        Query query = new TermQuery(new Term("natura", "m"));
        TopDocs topDocs = searcher.search(query, numDocs);
        int tot_monografie = topDocs.totalHits;

        query = new TermQuery(new Term("natura", "s"));
        topDocs = searcher.search(query, numDocs);
        int tot_periodici = topDocs.totalHits;

        NumberFormat nf = NumberFormat.getInstance();
        nf.setGroupingUsed( true );
        System.out.println( "<%" );
        System.out.println( "java.text.NumberFormat nf = java.text.NumberFormat.getInstance(locale);" );
        System.out.println( "String aggiornamento_data = \"" + aggdata + "\";");
        System.out.println( "String tot_monografie     = nf.format(" + tot_monografie + ");" );
        System.out.println( "String tot_periodici      = nf.format(" + tot_periodici  + ");" );
        System.out.println( "%>" );
    }
}
