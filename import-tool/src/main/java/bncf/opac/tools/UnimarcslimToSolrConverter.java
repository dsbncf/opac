
package bncf.opac.tools;


import bncf.opac.utils.RelazioniSoggetti;
import bncf.opac.utils.UnimarcslimToSolrConverterImpl;

import java.io.File;
import java.io.FileInputStream;



/**
 * Classe per la conversione da formato unimarcslim
 * in formato "opacindex" per la indicizzazione delle
 * notize con Lucene.
 */
public class UnimarcslimToSolrConverter
{
    private static void usage(String msg)
    {
        System.err.println("usage: java UnimarcslimToSolrConverterImpl (options) uri ...");
        System.err.println();
        System.err.println("options:");
        System.err.println("  -i input filename (documento da trasformare).");
        System.err.println("  -o output filename (documento risultante).");
        System.err.println("  -s filename  XSLT stylesheet for transformation.");
        System.err.println("  -t print tempi di conversione.");
        System.err.println("  -c numero massimo di record da leggere.\n");
        System.err.println("N.B.: ogni riga '<rec>...</rec>' deve contenere un record intero");
        System.err.println();
        if (msg != null)
           System.err.println(msg);
    }


   /** Main program entry point. */
   public static void main(String argv[])
   {
       if (argv.length == 0)
       {
           usage(null);
           System.exit(1);
       }

       String     inputfilename = null;
       UnimarcslimToSolrConverterImpl converter = new UnimarcslimToSolrConverterImpl();
       try
       {
          // process arguments
          for (int i = 0; i < argv.length; i++)
          {
            String arg = argv[i];
            if (arg.startsWith("-"))
            {
              String option = arg.substring(1);
              if (option.equals("i"))
              {
                // set input filename
                if (++i == argv.length)
                {
                   usage("errore: argomento per l'opzione -i non specificato.");
                   System.exit(1);
                }
                inputfilename = argv[i];
              }
              else
              if (option.equals("s"))
              {
                // set xslt stylesheet filename
                if (++i == argv.length)
                {
                   usage("errore: argomento per l'opzione -s non specificato.");
                   System.exit(1);
                }
                converter.setXsltForAdd(argv[i]);
              }
              else
              if (option.equals("o"))
              {
                // set output filename
                if (++i == argv.length)
                {
                   usage("errore: argomento per l'opzione -o non specificato.");
                   System.exit(1);
                }
                converter.setOutputAdd(new File(argv[i]));
              }
              else
              if (option.equals("d"))
              {
                // set xslt stylesheet filename for records to delete
                if (++i == argv.length)
                {
                   usage("errore: argomento per l'opzione -s non specificato.");
                   System.exit(1);
                }
                converter.setXsltForDeletion(new FileInputStream(argv[i]));
              }
              else
              if (option.equals("D"))
              {
                // set output filename
                if (++i == argv.length)
                {
                   usage("errore: argomento per l'opzione -D non specificato.");
                   System.exit(1);
                }
                converter.setOutputDel(new File(argv[i]));
              }
              if (option.equals("S"))
              {
                // set input file delle relazioni fra soggetti
                if (++i == argv.length)
                   usage("errore: argomento per l'opzione -S non specificato.");
                converter.setRelazioniSoggetti(new RelazioniSoggetti(new File(argv[i])));
              }
              else
              if (option.equals("c"))
              {
                // set max records to process.
                if (++i == argv.length)
                {
                   usage("errore: argomento per l'opzione -c non specificato.");
                   System.exit(1);
                }
                long maxreccount = 0;
                try
                {
                     maxreccount = Long.parseLong(argv[i]);
                }
                catch (NumberFormatException ex)
                {
                   usage("errore: argomento per l'opzione -c non valido.");
                   System.exit(1);
                }
                converter.setMaxCount(maxreccount);
              }
              else
              if (option.equals("t"))
              {
                // trace conversion times //
                int     tracefrequency = 0;// default
                if (++i == argv.length)
                {
                   usage("errore: argomento per l'opzione -t non specificato.");
                   System.exit(1);
                }
                try
                {
                     tracefrequency = Integer.parseInt(argv[i]);
                }
                catch (NumberFormatException ex)
                {
                   usage("errore: argomento per l'opzione -t non valido.");
                   tracefrequency = 0;
                }
                converter.setTrace(true);
                converter.setTraceFrequency(tracefrequency);
              }
            }
          }
       }
       catch(Exception ex)
       {
           ex.printStackTrace();
           System.exit(1);
       }

       long transformstart = System.currentTimeMillis();

       try
       {
           converter.transform(inputfilename);
       }
       catch (Exception ex)
       {
           ex.printStackTrace();
           System.exit(1);
       }

       long finish   = System.currentTimeMillis();
       long duration = (finish - transformstart) / 1000;
       System.err.println("durata: " + duration + " sec.\n");

       System.err.println("  records added: " + converter.getCountAdded());
       System.err.println("records deleted: " + converter.getCountDeleted());

   }

} //class//

