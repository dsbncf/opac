
package bncf.opac.lists;

import bncf.opac.tools.Config;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;


public class OpacTermsDb extends H2Db
{
   private static final Logger logger = LoggerFactory.getLogger(OpacTermsDb.class);

   private static final String SQL_NOMENORM = "NOMENORM";
   private static final String SQL_INSERT = "insert into %s(NOMENORM,NOME,OCCORENZE) values(?,?,?)";
   private static final String SQL_SELECT = "select NOMENORM,NOME,OCCORENZE from %s";
   private static final String SQL_COPYTABLE = "insert into %s(OCCORENZE,NOMENORM,NOME) select OCCORENZE,NOMENORM,NOME from %s order by NOMENORM";
   private static final String SQL_COPY_DEWEY =
   "insert into %s(OCCORENZE, NOME, NOMENORM, FULLNORM, CDD, CDDNORM, COD3) "
   + "select  OCCORENZE, substring(NOME,31), substring(NOMENORM,locate(' ',NOMENORM)+1), "
   + "NOMENORM, trim(substring(NOME,1,30)), trim(substring(NOMENORM,1,locate(' ',NOMENORM))), "
   + "substring(NOMENORM,1,3) from %s order by NOMENORM";
   
   
   private static final int NORM_MAX_LENGTH = 200;
   
   private String mainTable;
   private String tempTable;   
   
   
   public OpacTermsDb(Config config)
   {
      super(config.getDbPath(), config.getDbUser(), config.getDbPass());
   }
   
   protected OpacTermsDb(String dbPath, String dbUser, String dbPass)
   {
      super(dbPath, dbUser, dbPass);
   }

   
   public void setMainTable(String mainTable)
   {
      this.mainTable = mainTable;
   }

   
   public void setTempTable(String tempTable)
   {
      this.tempTable = tempTable;
   }

   
   public void setTables(String mainTable, String tempTable)
   {
      this.mainTable = mainTable;
      this.tempTable = tempTable;
   }
   
      
   public List<LukeTerm> getTerms()
   {
      return getTerms(mainTable);
   }

   
   public void loadTerms(List<LukeTerm> terms) throws SQLException
   {
      // TODO: log "eseguito" con tempi di esecuzione
      truncateTable(tempTable);
      insertTempTerms(terms);
      buildIndex(tempTable, SQL_NOMENORM);
      truncateTable(mainTable);
      dropFulltextIndex(mainTable);
      copyTempToMain();
      buildIndex(mainTable, SQL_NOMENORM);
      buildFulltextIndex(mainTable, SQL_NOMENORM);
      truncateTable(tempTable);
      commit();
   }

   
   public void loadDeweyTerms(List<LukeTerm> terms) throws SQLException
   {
      // TODO: log "eseguito" con tempi di esecuzione
      
      logger.info("loading Dewey Terms");
      truncateTable(tempTable);
      insertTempTerms(terms);
      buildIndex(tempTable, SQL_NOMENORM);
      truncateTable(mainTable);
      dropFulltextIndex(mainTable);
      copyDeweyTempToMain();
      buildFulltextIndex(mainTable, SQL_NOMENORM);
      truncateTable(tempTable);
      commit();
   }


   
   protected void insertTempTerms(List<LukeTerm> terms) throws SQLException
   {
      if ((terms == null) || terms.isEmpty())
         return;
      
      String qry = String.format(SQL_INSERT, tempTable);

      logger.debug("loading temp table: {}", tempTable);
      Connection conn = getConnection();
      PreparedStatement stm = conn.prepareStatement(qry);
      try
      {
         for (LukeTerm term : terms)
         {
            stm.clearParameters();
            String norm = term.getNorm();
            if (norm.length() > NORM_MAX_LENGTH) {
               norm = norm.substring(0, NORM_MAX_LENGTH);
            }
            stm.setString(1, norm);
            stm.setString(2, term.getText());
            stm.setInt(3, term.getCount());
            int upd = stm.executeUpdate();
         }
      }
      finally
      {
         if (stm != null) {
            try { stm.close(); } catch(SQLException ex) { logger.error("", ex); }
         }
      }
   }

   
   protected List<LukeTerm> getTempTerms()
   {
      return getTerms(tempTable);
   }


   protected void copyDeweyTempToMain() throws SQLException
   {
      String qry = String.format(SQL_COPY_DEWEY, mainTable, tempTable); 
      logger.debug("copying temp table: {}", tempTable);
      execQuery(qry);
   }

   
   protected void copyTempToMain() throws SQLException
   {
      String qry = String.format(SQL_COPYTABLE, mainTable, tempTable); 
      logger.debug("copying temp table: {}", tempTable);
      execQuery(qry);
   }

   
   protected void truncateTempTable() throws SQLException
   {
      truncateTable(tempTable);
   }

   
   protected void truncateTable() throws SQLException
   {
      truncateTable(mainTable);
   }

    
   protected List<LukeTerm> getTerms(String tableName)
   {
      ArrayList<LukeTerm> terms = new ArrayList<>();
      String qry = String.format(SQL_SELECT, tableName);
      Statement stm = null;
      try
      {
         stm = getConnection().createStatement();
         ResultSet rs = stm.executeQuery(qry);
         if (rs != null)
         {
            while (rs.next())
            {
               terms.add(new LukeTerm(rs.getString(1), rs.getString(2), rs.getInt(3)));
            }
         }
      }
      catch(SQLException ex)
      {
         logger.error("Query: {}", qry, ex);
      }
      finally
      {
         if (stm != null) {
            try { stm.close(); } catch (SQLException ex) { logger.error("", ex);  }
         }
      }
      return terms;
   }
   

} //class//
