
package bncf.opac.lists;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.io.File;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.sql.Statement;


public class H2Db
{
   private static final Logger logger = LoggerFactory.getLogger(H2Db.class);

   private static final String SQL_TRUNCATE  = "truncate table %s";
   private static final String SQL_INDEXNORM = "create index on %s(%s)";
   private static final String SQL_BUILD_FT  = "CALL FT_CREATE_INDEX('PUBLIC', '%s', '%s')";
   private static final String SQL_DROP_FT   = "CALL FT_DROP_INDEX('PUBLIC', '%s')";

   
   public static boolean deleteDatabase(String dbPath)
   {
      boolean ok = false;
      File file = new File(dbPath + ".mv.db");
      if (file.exists()) {
         ok &= file.delete();
      }

      file = new File(dbPath + ".trace.db");
      if (file.exists()) {
         ok &= file.delete();
      }
      
      return ok;
   }
   
   private final String dbPath;
   private final String dbUser;
   private final String dbPass;
   private boolean allowCreate = true;

   private Connection connection = null;
   
   
   public H2Db(String dbPath, String user, String password)
   {
      this.dbPath = dbPath;
      this.dbUser = user;
      this.dbPass = password;
   }
   
   public void setAllowCreate(boolean allow)
   {
      this.allowCreate = allow;
   }
   
   public Connection getConnection() throws SQLException
   {
      if (connection == null)
      {
         try
         {
            Class.forName("org.h2.Driver");
         }
         catch (ClassNotFoundException ex)
         {
            throw new SQLException(ex);
         }
         String dbUrl = "jdbc:h2:" + dbPath;
         if (!allowCreate) {
            dbUrl += ";IFEXISTS=TRUE";
         }
         connection = DriverManager.getConnection(dbUrl, dbUser, dbPass);
      }
      return connection;
   }

   
   /**
    * Runs a SQL script from a file.
    * The script is a text file containing SQL statements;
    * each statement must end with ';'.
    * This command can be used to restore a database from a backup.
    * The password must be in single quotes; it is case sensitive and can contain spaces.
    * Instead of a file name, an URL may be used. To read a stream from the classpath,
    * use the prefix 'classpath:'. See the Pluggable File System section on the Advanced page.
    * The compression algorithm must match the one used when creating the script.
    * Instead of a file, an URL may be used.
    * Admin rights are required to execute this command.
    * Example:
    *     RUNSCRIPT FROM 'backup.sql'
    *     RUNSCRIPT FROM 'classpath:/com/acme/test.sql'
    * 
    * @param scriptPath
    * @return
    * @throws SQLException 
    */
   public boolean runScript(String scriptPath) throws SQLException
   {
      Connection conn = getConnection();
      Statement stm = conn.createStatement();
      String sql = "RUNSCRIPT FROM '%s'";
      return stm.execute(String.format(sql, scriptPath));
   }
   
   public void commit() throws SQLException
   {
      if (connection != null)
      {
         connection.commit();
         logger.debug("database committed: {}", dbPath);
      }
   }
   
   public void close()
   {
      if (connection != null)
      {
         try
         {
            connection.close();
            connection = null;
            logger.debug("database closed: {}", dbPath);

         }
         catch (SQLException ex)
         {
            logger.error("Could not close db H2 {}", dbPath, ex);
         }
      }
   }
   
 
   protected void truncateTable(String tablename) throws SQLException
   {
      Statement stm = null;
      String qry = String.format(SQL_TRUNCATE, tablename);
      logger.debug("truncating table: {}", tablename);
      execQuery(qry);
   }

   protected void buildIndex(String tableName, String columnName) throws SQLException
   {
      Statement stm = null;
      String qry = String.format(SQL_INDEXNORM, tableName, columnName);
      logger.debug("indexing {}.{}", tableName, columnName);
      execQuery(qry);
   }

   

   protected void buildFulltextIndex(String tableName, String columnName) throws SQLException
   {
      Statement stm = null;
      String qry = String.format(SQL_BUILD_FT, tableName, columnName);
      logger.debug("building full-text index {}.{}", tableName, columnName);
      execQuery(qry);
   }

   
   protected void dropFulltextIndex(String tableName) throws SQLException
   {
      String qry = String.format(SQL_DROP_FT, tableName);
      logger.debug("dropping full-text index on {}", tableName);
      execQuery(qry);
   }
   
   
   protected void execQuery(String query) throws SQLException
   {
      Statement stm = null;
      try
      {
         logger.debug("executing query: {}", query);
         stm = getConnection().createStatement();
         stm.execute(query);
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
   }
     
   
} //class//
