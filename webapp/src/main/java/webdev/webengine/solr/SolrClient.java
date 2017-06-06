
package webdev.webengine.solr;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;


/**
 * Utility per lo scambio dati con Amazon Marketplace Web Service (AMWS).
 *
 */


public class SolrClient  extends Runner
{
   private static final Logger logger = LoggerFactory.getLogger(SolrClient.class);
   
   private String url = null;
   private String keywords = null;

   public SolrClient(String[] args) throws Exception
   {
      super();
      if (args.length < 2)
      {
          usage();
          System.exit(1);
      }
      super.init(args);
   }


  /**
   *  program execution.
   *
   * @param args the command line arguments
   */

   @Override
   protected void run() throws Exception
   {
      logger.debug("running SolrClient...");
      logger.debug("url: " + url);
      logger.debug("keyword: " + keywords);
      
      // invio richiesta verso Solr
      SolrClientImpl client = new SolrClientImpl(url);
      String result = client.runSearch(keywords);
      logger.debug(result);
      
      // parsing del risultato Solr
      SolrResult solrResult = new SolrResult();
      solrResult.parse(result);
      
      logger.debug(solrResult.toText());
      
      logger.debug("Done");
   }


   
  // -------------------------------------------

  @Override
   protected final void usage()
   {
      System.err.println("Usage: java SolrClient [URL] keyword");
      String help = "Usage: " + this.getClass().getName()
                              + " -p properties-file\n"
                              + " URL keyword"
                              + " -usage or -help = this message\n" ;
      System.err.println(help);
      System.exit(1);
   }


 /**
  * parse command line arguments.
  */

    @Override
 protected final void parseArgs(String args[])
 {
    String  inputfile   = null;
    String  logfile     = null;

    for (int i = 0; i < args.length; i++)
    {
       if (args[i].equals("-usage")) usage();
       if (args[i].equals("-help"))  usage();
 
       if (args[i].equals("-p"))
       {
          if (i == args.length - 1) usage();
          propertiesfile = args[++i].trim();
       }
       else
       if (args[i].equals("-sid"))
       {
          if (i == args.length - 1) usage();
             requestProperties.setProperty("submissionId", args[++i].trim());
       }
       else
       if (args[i].equals("-url"))
       {
          if (i == args.length - 1) usage();
          url = args[++i].trim();
       }
       if (args[i].equals("-kw"))
       {
          if (i == args.length - 1) usage();
             keywords = args[++i].trim();
       }
       else	// inputfile file must be last arg //
       {
          // if (i == args.length - 1) usage();
          //inputfile = args[i].trim();
          // System.err.println("args[" + i + "/" + args.length + "] = " + inputfile );
       }
    } // for .. args //
 }


  

  /**
   * Main program.
   *
   * @param args the command line arguments
   */
  public static void main(String args[]) throws Exception
  {
        new SolrClient(args).run();
  }


  
}//class//
