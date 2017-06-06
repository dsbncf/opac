
package bncf.opac.db;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.sql.Statement;


public class OpacDb
{

   
   private static final Logger logger = LoggerFactory.getLogger(OpacDb.class);

   private final boolean allowCreate = true;
   private String dbPath;
   private String dbUser;
   private String dbPass;

   private Connection connection = null;
   protected boolean readonlyMode = false;


   
   public OpacDb(String path, String user, String passwd)
   {
      this.dbPath = path;
      this.dbUser = user;
      this.dbPass = passwd;
   }
   
   
   public String getDbPass()
   {
      return dbPass;
   }


   public void setDbPass(String dbPass)
   {
      this.dbPass = dbPass;
   }


   public String getDbUser()
   {
      return dbUser;
   }


   public void setDbUser(String dbUser)
   {
      this.dbUser = dbUser;
   }
   


   public String getDbPath()
   {
      return dbPath;
   }

   public void setDbPath(String dbPath)
   {
      this.dbPath = dbPath;
   }


   
   public Connection getConnection() throws SQLException
   {
      if (connection == null)
      {
         String dbUrl = "jdbc:h2:" + dbPath;
         if (!allowCreate) {
            dbUrl += ";IFEXISTS=TRUE";
         }
         connection = DriverManager.getConnection(dbUrl, dbUser, dbPass);
      }
      return connection;
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
   
   protected void closeSql(Statement stm)
   {
      if (stm == null)
      {
         return;
      }
      try
      {
         stm.close();
      }
      catch (SQLException ex)
      {
         logger.error(null, ex);
      }
   }

   
   protected void execSql(String query) throws SQLException
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

