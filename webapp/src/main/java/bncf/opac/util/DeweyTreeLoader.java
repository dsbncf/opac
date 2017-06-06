
package bncf.opac.util;



import java.io.BufferedReader;
import java.io.File;
import java.io.FileReader;
import java.io.IOException;

import javax.servlet.ServletException;

import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.Statement;
import java.sql.SQLException;

import javax.sql.DataSource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;




/**
 * Questa servlet carica il record bibliografico da solr.
 */


public class DeweyTreeLoader
{
    private final static Logger  logger = LoggerFactory.getLogger(DeweyTreeLoader.class);

    private static final String deweytreeQuery = "select distinct COD3, NOME from dewey where COD3 = CDDNORM";

    private DeweyTree deweytree = null;

    private DataSource dataSource = null;
    private File       inputFile  = null;


    /**
     * Constructor.
     *
     * @param  location of Solr search engine.
     */
    public DeweyTreeLoader()
    {
      deweytree = new DeweyTree();
    }


    /**
     * loads DeweyTree from resource.
     *
     * The resource has to be initialized by the constructor.
     *
     * @param  location of Solr search engine.
     */

    public DeweyTree getDeweyTree() throws ServletException
    {
      return deweytree;
    }


   /**
    * Carica i dati relativi al tree delle classi Dewey dal Database.
    *
    * @throws ServletException
    */
   public void loadDeweyTree(DataSource dataSource) throws ServletException
   {
        Connection conn = null;
        Statement stmt = null;

        try
        {
            conn = dataSource.getConnection();
            stmt = conn.createStatement();
            ResultSet rs = stmt.executeQuery(deweytreeQuery);

            while (rs.next())
            {
                String cod3  = rs.getString(1);
                String descr = rs.getString(2);
                deweytree.addDeweyInfo(cod3,descr);
                // logger.debug(cod3 + " : " + descr);
            }
            rs.close();     rs = null;
            stmt.close(); stmt = null;
            conn.close(); conn = null;
        }
        catch (SQLException ex)
        {
           logger.error(null, ex);
        }
        finally
        {
            if (stmt != null) {
                try { stmt.close(); } catch (SQLException sqlex) { } stmt = null;
            }
            if (conn != null) {
                try { conn.close(); } catch (SQLException sqlex) { }
                conn = null;
            }
        }
   }



   /**
    * Carica i dati relativi al tree delle classi Dewey da un file.
    *
    * @throws ServletException
    */
   public void loadDeweyTree(File inputFile) throws ServletException
   {
      try
      {
         BufferedReader inp = new BufferedReader(new FileReader(inputFile));
         String str;
         while ((str = inp.readLine()) != null)
         {
            if (str.equals(""))
               continue;
            String[] values = str.split("\\|");
            String descr = ((values.length > 1) ? values[1] : "?");
            deweytree.addDeweyInfo(values[0],descr);
            //logger.debug ( "dewey: " + values[0] + " -> " + descr);
         }
         inp.close();
      }
      catch (IOException ex)
      {
         throw new ServletException(ex);
      }
   }


















}//class//

