
package bncf.opac.handler;


import bncf.opac.db.OpacListDb;
import bncf.opac.util.DeweyItem;
import bncf.opac.util.XMLUtils;

import java.io.IOException;
import java.util.ArrayList;
import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.Statement;
import java.sql.SQLException;

import javax.sql.DataSource;
import javax.servlet.ServletException;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;



/**
 * Questa servlet carica il record bibliografico da solr.
 */
public class DeweyBrowserHandler
{
   private final static Logger logger = LoggerFactory.getLogger(DeweyBrowserHandler.class);
   // private DataSource dataSource = null;
   private ArrayList<DeweyItem> list = null;
   private int totale = 0;
   private int limit = 20;
   private OpacListDb opacDb = null;


   /**
    * Constructor
    */
   public DeweyBrowserHandler(DataSource dataSource)
   {
      logger.debug("System:file.encoding=" + System.getProperty("file.encoding"));
      // this.dataSource = dataSource;
   }

 
    /**
    * Constructor
    *
    */
   public DeweyBrowserHandler(OpacListDb opacDb)
   {
      this.opacDb = opacDb;
   }

   
   
   
   public ArrayList<DeweyItem> getList()
   {
      return list;
   }


   public int getLimit()
   {
      return this.limit;
   }


   public void setLimit(int val)
   {
      this.limit = val;
   }


   public int getTotale()
   {
      return this.totale;
   }


    /**
     * Ricerca nella lista ordinata alfabeticamente.
     *
     * @param request
     * @param response
     * @throws ServletException
     * @throws IOException
     *
     */
    public ArrayList<DeweyItem> listSearch(String cod, int start) throws SearchHandlerException
    {
       return opacDb.getDeweyList(cod, start, limit + 1);
    }

    
    /*
    public void listSearch(String cod, int start) throws SearchHandlerException
    {
        Connection conn = null;
        Statement stmt = null;
        CallableStatement cstmt = null;

        try
        {
            // conn = dataSource.getConnection();
            conn = null;

            int position = start;

            // caricamento records della lista
            StringBuilder sbuf = new StringBuilder("select * from DEWEY");
            sbuf.append(" where cod3 = '").append(cod);
            sbuf.append("' limit ").append(start).append(",").append(limit+1);

            String query = sbuf.toString();
            logger.debug("list-query: " + query);

            stmt = conn.createStatement();
            ResultSet rs = stmt.executeQuery(query);
            list = new ArrayList<DeweyItem>();
            while (rs.next())
            {
               int id  = rs.getInt("id");
               String nome = XMLUtils.protectSpecialCharacters(rs.getString("nome"));
               Integer occorenze = new Integer(rs.getInt("occorenze"));
               String cdd = rs.getString("cdd");
               // logger.debug( cdd + " | " + nome + " | " + occorenze + " | " + id);
               list.add(new DeweyItem(id, cdd, nome, occorenze));
            }
            rs.close();   rs = null;
            stmt.close(); stmt = null;
            conn.close(); conn = null;
        }
        catch (SQLException ex)
        {
           logger.info(null, ex);
        }
        finally
        {
            if (cstmt != null) {
                try { cstmt.close(); } catch (SQLException sqlex) { } cstmt = null;
            }
            if (stmt != null) {
                try { stmt.close(); } catch (SQLException sqlex) { } stmt = null;
            }
            if (conn != null) {
                try { conn.close(); } catch (SQLException sqlex) { }
                conn = null;
            }
        }
    }
    */


} //class//

