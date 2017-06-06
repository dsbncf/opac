
package bncf.opac.handler;


import bncf.opac.db.OpacListDb;
import bncf.opac.db.OpacListResult;
import bncf.opac.util.ListItem;
import bncf.opac.util.StringUtils;
import bncf.opac.util.XMLUtils;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.io.IOException;
import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.Types;
import java.util.ArrayList;

import javax.servlet.ServletException;
import javax.sql.DataSource;




/**
 * Questa servlet carica il record bibliografico da solr.
 */
public class ListBrowserHandler
{
   private final static Logger logger = LoggerFactory.getLogger(ListBrowserHandler.class);
   private DataSource dataSource = null;
   private ArrayList<ListItem> list = null;
   private int totale = 0;
   private OpacListDb opacDb;


   /**
    * Constructor
    *
    * @param dataSource
    */
   /*
   public ListBrowserHandler(DataSource dataSource)
   {
      logger.debug("System:file.encoding=" + System.getProperty("file.encoding"));
      this.dataSource = dataSource;
   }
   * */


   /**
    * Constructor
    *
    * @param opacDb
    */
   public ListBrowserHandler(OpacListDb opacDb)
   {
      this.opacDb = opacDb;
   }

   
   public ArrayList<ListItem> getList()
   {
      return  (list == null) ? new ArrayList<ListItem>() : list;
   }


   public void close()
   {
      opacDb.close();
   }

   public int getTotale()
   {
      return this.totale;
   }


    /**
     * Processes the search request.
     *
    * @param field
    * @param key
    * @param fulltext
    * @param start
    * @return 
    * @throws bncf.opac.handler.SearchHandlerException 
     */
   public OpacListResult runSearch(String field, String key, int fulltext, int start)
       throws SearchHandlerException
   {
      String keynorm = StringUtils.utf8ToNormWC(key);
      //logger.debug("keynorm = " + keynorm);

      if (fulltext > 0)
      {
	      return opacDb.fulltextSearch(field, keynorm, start);
      }
      else
      {
         // listSearch(field, keynorm, start);
         return opacDb.listSearch(field, keynorm, start);
      }
   }


   // --------------------------- private ----------------------------- //
   
   private void listSearch(String field, String key, String key2, int start)
       throws SearchHandlerException
   {
      // listSearch(field, key, start);
      opacDb.listSearch(field, key, start);
   }

   
    
   private void fulltextSearch(String field, String key, int start)
       throws SearchHandlerException
   {
      // listSearch(field, key, start);
      opacDb.fulltextSearch(field, key, start);
   }

     
   
    /**
     * Ricerca nella lista ordinata alfabeticamente.
     *
     * @param request
     * @param response
     * @throws ServletException
     * @throws IOException
     *
     * Esempio di query:
     *
     * callable-statement: {call FIND_NUMORD(?,?,?,?)}
     *
     * estrazione lista:   select * from $field where id >= 503 order by id limit 20;
     */
   private void listSearchMySql(String field, String sKey, int start)
         throws SearchHandlerException
   {
      Connection conn = null;
      Statement stmt = null;
      CallableStatement cstmt = null;

      if (field == null)
      {
         return;
      }

      String key = (sKey == null) ? null : sKey.trim();

      logger.debug("list " + field + " for key=" + key);
      if ((start < 1) && ((key == null) || key.isEmpty()))
      {
         return;
      }

      try
      {
         conn = dataSource.getConnection();

         int position = start;

	 // ricerca posizione nella lista, solo se position == 0
         //         altrimenti si tratta di una richiesta di paginazione
         if (position == 0)
         {
            cstmt = conn.prepareCall("{call FIND_NUMORD(?,?,?,?)}");
            cstmt.setString(1, field.toUpperCase());
            cstmt.setString(2, key);
            cstmt.registerOutParameter(3, Types.INTEGER);
            cstmt.registerOutParameter(4, Types.VARCHAR);
            boolean isResultSet = cstmt.execute();
            String errmsg = null;
            if (!isResultSet)
            {
               ResultSet rsc = cstmt.getResultSet();
               position = cstmt.getInt(3);
               errmsg = cstmt.getString(4);
               if (rsc != null)
               {
                  rsc.close();
               }
            }
            cstmt.close();
            cstmt = null;

            logger.debug("list-offset: " + position);
            if (errmsg != null)
            {
               logger.info("ERROR on call find_numord: " + errmsg);
            }

            if (position > 0)
            {
               --position; // decrementa per visualizzare 1 record prima dell'attuale match
            }
         }

         // caricamento records della lista
         StringBuilder sbuf = new StringBuilder("select * from ");
         sbuf.append(field.toUpperCase()).append(" where id >= '").append(position);
         sbuf.append("' order by id limit ").append(20);

         String query = sbuf.toString();
         logger.debug("list-query: " + query);

         stmt = conn.createStatement();
         ResultSet rs = stmt.executeQuery(query);
         list = new ArrayList<ListItem>();
         while (rs.next())
         {
            String nome = rs.getString("nome");
            // String nome = new String(rs.getBytes("nome"),"UTF8");
            String display = XMLUtils.protectSpecialCharacters(nome.replaceAll(
                  "|", ""));
            StringBuilder link = new StringBuilder("/fcsearch?");
            link.append(field).append("_fc=%22");
            link.append(nome.replaceAll("\\+", "%2B").replaceAll("&#38;", "%26"));
            link.append("%22");
            int id = rs.getInt("id");
            Integer occorenze = new Integer(rs.getInt("occorenze"));
            list.add(new ListItem(id, display, link.toString(), occorenze));
            // logger.debug(field + ": " + display + " | " + occorenze + " | " + id);
         }
         rs.close();
         stmt.close();
         stmt = null;
         conn.close();
         conn = null;
      }
      catch (SQLException ex)
      {
         logger.error(null, ex);
      }
      finally
      {
         if (cstmt != null)
         {
            try
            {
               cstmt.close();
            }
            catch (SQLException sqlex)
            {
            }
            cstmt = null;
         }
         if (stmt != null)
         {
            try
            {
               stmt.close();
            }
            catch (SQLException sqlex)
            {
            }
            stmt = null;
         }
         if (conn != null)
         {
            try
            {
               conn.close();
            }
            catch (SQLException sqlex)
            {
            }
         }
      }
   }


    /**
     * Ricerca full-text.
     *
     * @param request
     * @param response
     * @throws ServletException
     * @throws IOException
     *
     * Esempio di query:
     *
     * select * from $field where match(NOMENORM)
     *     against('cultura +popolare' in boolean mode) order by OCCORENZE desc;
     */
    private void fulltextSearchMySql(String field, String key, int start) throws SearchHandlerException
    {
        Connection conn = null;
        Statement stmt  = null;
        Statement stmtc = null;
        try
        {
            conn = dataSource.getConnection();

            // stringa da normalizzare per boolean mode
            String match = key;

            // caricamento records della lista
            StringBuffer sbuf = new StringBuffer("from ").append(field.toUpperCase());
            sbuf.append(" where match(NOMENORM) against('").append(match);
            sbuf.append("' in boolean mode)");

            // get number of records found for the query
            StringBuffer querycount = new StringBuffer("select count(*) ").append(sbuf);
            String query = querycount.toString();
            logger.debug("full-text-count: " + query);
            stmtc = conn.createStatement();
            ResultSet rsc = stmtc.executeQuery(query);
            if (rsc.next())
            {
               totale = rsc.getInt(1);
               logger.debug("totale: " + totale );
            }
            rsc.close();   rsc = null;
            stmtc.close(); stmtc = null;

            // lettura dati
            StringBuilder querydata  = new StringBuilder("select * ");
            // querydata.append(sbuf).append(" order by OCCORENZE desc limit ");
            querydata.append(sbuf).append(" order by NOMENORM limit ");
            querydata.append(start).append(",").append(20);
            query = querydata.toString();
            logger.debug("full-text-query: " + query);
            stmt = conn.createStatement();
            ResultSet rs = stmt.executeQuery(query);
            list = new ArrayList<ListItem>();
            while (rs.next())
            {
               String nome = rs.getString("nome");
               // String nome = new String(rs.getBytes("nome"),"UTF8");
               String display = XMLUtils.protectSpecialCharacters(nome.replaceAll("|",""));
               StringBuilder link = new StringBuilder("/fcsearch?");
               link.append(field).append("_fc=%22");
               link.append(nome.replaceAll("\\+","%2B").replaceAll("&#38;","%26"));
               link.append("%22");
               int id  = rs.getInt("id");
               Integer occorenze = new Integer(rs.getInt("occorenze"));
               list.add(new ListItem(id, display, link.toString(),  occorenze));
               // logger.debug(field + ": " + display + " | " + occorenze + " | " + id);
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
            if (stmtc != null) {
                try { stmtc.close(); } catch (SQLException sqlex) { } stmtc = null;
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


}//class//

