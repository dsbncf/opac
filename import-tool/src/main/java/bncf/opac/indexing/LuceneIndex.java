
package bncf.opac.indexing;

import java.io.File;
import java.io.IOException;

import org.apache.lucene.analysis.Analyzer;
import org.apache.lucene.analysis.WhitespaceAnalyzer;
import org.apache.lucene.document.Document;
import org.apache.lucene.index.IndexReader;
import org.apache.lucene.index.IndexWriter;
import org.apache.lucene.index.IndexWriterConfig;
import org.apache.lucene.store.Directory;
import org.apache.lucene.store.NIOFSDirectory;
import org.apache.lucene.util.Version;


/** This class implements a high level access to Lucene index files.
 *
 *  The following simple example opens an existing index for optimization
 *  and closes it immediatly.
 * <pre>
 *  LuceneIndex luc = new LuceneIndex(LuceneIndex.WRITE,"/u/var/db/lucene/opac/bncf");
 *  luc.open();
 *  luc.setOptimize(true);
 *  luc.close();
 * </pre>
 *
 */

public class LuceneIndex
{
  public final static int INVALID     = 0;
  public final static int READ        = 1;
  public final static int WRITE       = 2;
  public final static int WRITECREATE = 4;
  
  private String      _indexLocation = "index";
  private int         _openmode      = READ;
  private boolean     _optimizeFlag  = false;
  private IndexReader _reader        = null;
  private IndexWriter _writer        = null;
  private Analyzer _analyzer      = null;



  public LuceneIndex()
  {
    _analyzer      = new WhitespaceAnalyzer();
  }

  public LuceneIndex(String indexlocation)
  {
    _indexLocation = indexlocation;
    _analyzer      = new WhitespaceAnalyzer();
  }

  public LuceneIndex(int mode)
  {
    setMode(mode);
  }

  public LuceneIndex(int mode, String indexlocation)
  {
    setMode(mode);
    _indexLocation = indexlocation;
    _analyzer      = new WhitespaceAnalyzer();
  }


  public void setMode(int mode)
  {
    _openmode = ((mode > INVALID) || (mode <= WRITECREATE)) ? mode : INVALID;
  }


  public void open() throws IOException
  {
     close();
     Directory dir = new NIOFSDirectory(new File(_indexLocation));

     if (_openmode == READ)
     {
         _reader = IndexReader.open(dir);
         return;
     }

     IndexWriterConfig conf = new IndexWriterConfig(Version.LUCENE_36,_analyzer);
     switch(_openmode)
     {
      case WRITE:
           conf.setOpenMode(IndexWriterConfig.OpenMode.APPEND);
           break;
      case WRITECREATE:
           conf.setOpenMode(IndexWriterConfig.OpenMode.CREATE_OR_APPEND);
           break;
    }
     _writer = new IndexWriter(dir, conf);
  }

  public void close() throws IOException
  {
      close(_optimizeFlag);
  }

  public void close(boolean optimizeflag) throws IOException
  {
    if (_reader != null)
      _reader.close();

    if (_writer != null)
    {
      if (optimizeflag)
         _writer.optimize();
      _writer.close();
    }
  }


  public void setIndexLocation( String loc )
  {
    _indexLocation = loc;
  }

  public String getIndexLocation( )
  {
    return _indexLocation;
  }


  public void setOptimize( boolean optflag )
  {
    _optimizeFlag = optflag;
  }

  public boolean getOptimize( )
  {
    return _optimizeFlag;
  }


  public void setAnalyzer( Analyzer analyz )
  {
    _analyzer = analyz;
  }

  public Analyzer getAnalyzer( )
  {
    return _analyzer;
  }


  public void addDocument(Document doc)
  {
 
    if (_writer != null)
      try
      {
        _writer.addDocument(doc);
      }
      catch (java.io.IOException ex)
      {
        System.err.println("Errore durante l'aggiunta del documento: " + doc.toString()
                            + "\n" + ex.getMessage() );
      }
  }


} // class //
