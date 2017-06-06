/*
 */

package bncf.opac.db;

import bncf.opac.util.DeweyItem;
import bncf.opac.util.ListItem;
import bncf.opac.util.XMLUtils;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;


/**
 *
 * @author ds
 */
public class OpacListDb extends OpacDb
{
   private static final Logger logger = LoggerFactory.getLogger(OpacListDb.class);
   
   private static final String QUERY_FIND_NUMORD = 
      "SELECT T.ID FROM %s T WHERE T.NOMENORM >= '%s' ORDER BY T.NOMENORM limit 1";

   private static final String QUERY_GET_LIST = 
                               "select * from %s where id >= %d order by id limit %d";
   
   private static final String QUERY_GET_DEWEY_LIST = 
            "select * from DEWEY where cod3 = '%s' limit %d, %d"; 
   
   // query-string,  table-name, table-name, limit, offset
   private static final String QUERY_FULLTEXT = 
      "SELECT T.* FROM FT_SEARCH_DATA('%s', 0, 0) FT, %s T WHERE FT.TABLE = '%s' AND T.ID = FT.KEYS[0] LIMIT %d OFFSET %d";
   //select T.* from FT_SEARCH_DATA('fisica', 0, 0) FT, TITOLO T where FT.TABLE = 'TITOLO' AND T.ID = FT.KEYS[0] LIMIT 10  OFFSET 1
   private static final String[] TABLES = { "AUTORE", "DEWEY", "DESCRITTORE", "SOGGETTO", "TITOLO" };

   private static final int DEFAULT_PAGESIZE = 20;
   
   
   private int pageSize = DEFAULT_PAGESIZE;
   
   

   public OpacListDb(String path, String user, String passwd, int pageSize)
   {
      super(path, user, passwd);
      this.pageSize = pageSize;
      super.readonlyMode = true;
   }

      
   public ArrayList<DeweyItem> getDeweyList(String cod, int start, int limit)
   {
      String query = String.format(QUERY_GET_DEWEY_LIST, cod, start, limit);
      
      ArrayList<DeweyItem> list = new ArrayList<DeweyItem>();
      Statement stm = null;
      try
      {
         logger.debug("executing query: {}", query);
         stm = getConnection().createStatement();
         ResultSet rs = stm.executeQuery(query);
         while (rs.next())
         {
            int id  = rs.getInt("id");
            String nome = XMLUtils.protectSpecialCharacters(rs.getString("nome"));
            Integer occorenze = rs.getInt("occorenze");
            String cdd = rs.getString("cdd");
            logger.debug( cdd + " | " + nome + " | " + occorenze + " | " + id);
            list.add(new DeweyItem(id, cdd, nome, occorenze));
         }
         rs.close();
      }
      catch(SQLException ex)
      {
         logger.error("Query: {}", query, ex);
      }
      finally
      {
         if (stm != null) {
            try { stm.close(); } catch (SQLException ex) { logger.error("", ex);  }
         }
      }
      return list;
   }

   
    /**
     * Ricerca nella lista ordinata alfabeticamente.
     *
    * @param table The table to be listed
    * @param sKey  The search key
    * @param start The start position
    * @return  OpacListResult (lista + totale)
     */
   public OpacListResult listSearch(String table, String sKey, int start)
   {
      // checks
      if (table == null) {
         return null;
      }

      String key = (sKey == null) ? null : sKey.trim();
      logger.debug("list " + table + " for key=" + key  +" start=" + start);
      if ((start < 1) && ((key == null) || key.isEmpty())) {
         return new OpacListResult();
      }

      String keylc = (key == null) ? null : key.toLowerCase();
      int position = (start == 0) ? findNumOrd(table, keylc) : start;
      if (position > 0) {
         --position; // decrementa per visualizzare 1 record prima dell'attuale match
      }
 
      logger.debug("key '{}' starts at position {} ", key, position);
      OpacListResult res = new OpacListResult(getPagedList(table, position));
      res.setPosition(position);
      close();

      return res;
   }
      
   
    /**
     * Ricerca nella lista ordinata alfabeticamente.
     *
    * @param table The table to be listed
    * @param sKey  The search key
    * @param start The start position
    * @return  OpacListResult (lista + totale)
     */
   public OpacListResult fulltextSearch(String table, String sKey, int start)
   {
      // checks
      if (table == null) {
         return null;
      }

      String key = (sKey == null) ? null : sKey.trim();
      logger.debug("list " + table + " for key=" + key  +" start=" + start);
      if ((start < 1) && ((key == null) || key.isEmpty())) {
         return new OpacListResult();
      }

      String keylc = (key == null) ? null : key.toLowerCase();
      int offset = (start < 0) ? 0 : start;
      //int position = (start == 0) ? findNumOrd(table, keylc) : start;
      //if (position > 0) {
      //   --position; // decrementa per visualizzare 1 record prima dell'attuale match
      //}
      logger.debug("key '{}' starts at position {} ", key, offset);
      OpacListResult res = new OpacListResult(getPagedList(table, key, pageSize, offset));
      res.setPosition(offset);
      close();

      return res;
   }
      
   protected ArrayList<ListItem> getPagedList(String tableName, String search, int limit, int offset)
   {
      String table = checkTableName(tableName);
      String query = String.format(QUERY_FULLTEXT, search, table, table, limit, offset);
      
      ArrayList<ListItem> list = new ArrayList<ListItem>();
      Statement stm = null;
      try
      {
         logger.debug("executing query: {}", query);
         stm = getConnection().createStatement();
         ResultSet rs = stm.executeQuery(query);
         while (rs.next())
         {
            String nome = rs.getString("NOME");
            // String nome = new String(rs.getBytes("nome"),"UTF8");
            String display = XMLUtils.protectSpecialCharacters(nome.replaceAll(
              "|", ""));
            StringBuilder link = new StringBuilder("/fcsearch?");
            link.append(tableName).append("_fc=%22");
            link.append(nome.replaceAll("\\+", "%2B").replaceAll("&#38;", "%26"));
            link.append("%22");
            int id = rs.getInt("id");
            Integer occorenze = rs.getInt("occorenze");
            list.add(new ListItem(id, display, link.toString(), occorenze));
            // logger.debug(tableName + ": " + display + " | " + occorenze + " | " + id);
         }
         rs.close();
      }
      catch(SQLException ex)
      {
         logger.error("Query: {}", query, ex);
      }
      finally
      {
         if (stm != null) {
            try { stm.close(); } catch (SQLException ex) { logger.error("", ex);  }
         }
      }
      return list;
   }
      
      
   protected ArrayList<ListItem> getPagedList(String tableName, int position)
   {
      String table = checkTableName(tableName);
      String query = String.format(QUERY_GET_LIST, table, position, pageSize);
      
      ArrayList<ListItem> list = new ArrayList<ListItem>();
      Statement stm = null;
      try
      {
         logger.debug("executing query: {}", query);
         stm = getConnection().createStatement();
         ResultSet rs = stm.executeQuery(query);
         while (rs.next())
         {
            String nome = rs.getString("NOME");
            // String nome = new String(rs.getBytes("nome"),"UTF8");
            String display = XMLUtils.protectSpecialCharacters(nome.replaceAll(
              "|", ""));
            StringBuilder link = new StringBuilder("/fcsearch?");
            link.append(tableName).append("_fc=%22");
            link.append(nome.replaceAll("\\+", "%2B").replaceAll("&#38;", "%26"));
            link.append("%22");
            int id = rs.getInt("id");
            Integer occorenze = rs.getInt("occorenze");
            list.add(new ListItem(id, display, link.toString(), occorenze));
            // logger.debug(tableName + ": " + display + " | " + occorenze + " | " + id);
         }
         rs.close();
      }
      catch(SQLException ex)
      {
         logger.error("Query: {}", query, ex);
      }
      finally
      {
         if (stm != null) {
            try { stm.close(); } catch (SQLException ex) { logger.error("", ex);  }
         }
      }
      return list;
   }

   
   private String checkTableName(String tableName)
   {
      if (tableName == null) {
         return null;
      }
      
      for (String tn : TABLES)
      {
         if (tn.equals(tableName.trim().toUpperCase())) {
            return tn;
         }
      }
      logger.error("invalid table name: {}", tableName);
      return null;
   }
   
   /**
    * ricerca posizione nella lista, solo se position == 0
    * altrimenti si tratta di una richiesta di paginazione
    * @param tableName
    * @param key
    * @return 
    */
   protected int findNumOrd(String tableName, String key)
   {
      String table = checkTableName(tableName);
      String query = String.format(QUERY_FIND_NUMORD, table, key);
      int numord = 0;
      Statement stm = null;
      try
      {
         logger.debug("executing query: {}", query);
         stm = getConnection().createStatement();
         ResultSet rs = stm.executeQuery(query);
         if (rs.next()) {
            numord = rs.getInt(1);
         }
         rs.close();
      }
      catch(SQLException ex)
      {
         logger.error("Query: {}", query, ex);
      }
      finally
      {
         if (stm != null) {
            try { stm.close(); } catch (SQLException ex) { logger.error("", ex);  }
         }
      }
      return numord;
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
/*
   private void fulltextSearch(String field, String key, int start) throws SearchHandlerException
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
            querydata.append(start).append(",").append(limit);
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
*/
     
   
} //class//

