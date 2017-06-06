
package bncf.opac.db;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.sql.PreparedStatement;
import java.sql.SQLException;


public class OpacUserDb extends OpacDb
{
   private static final Logger logger = LoggerFactory.getLogger(OpacUserDb.class);
   private static final String INSERT_STATEMENT = "INSERT INTO SEGNALAZIONE(IDN,TESTO,EMAIL,IP) VALUES(?,?,?,?)";


   public OpacUserDb(String path, String user, String passwd)
   {
      super(path, user, passwd);
   }

     
   public boolean insertSegnalazione(String idn, String testo, String email, String ip)
   {
      // String sql = String.format(INSERT_STATEMENT, idn, testo, email, ip);
      String sql = INSERT_STATEMENT;
      int numord = 0;
      PreparedStatement stm = null;
      int upd = 0;
      try
      {
         logger.debug("executing insert statement: {}", sql);
         stm = getConnection().prepareStatement(sql);
         stm.setString(1, idn);
         stm.setString(2, testo);
         stm.setString(3, email);
         stm.setString(4, ip);
         upd = stm.executeUpdate();
         logger.debug("result from executeUpdate(): {}", upd);
      }
      catch(SQLException ex)
      {
         logger.error("Insert Statement: {}", sql, ex);
      }
      finally
      {
         if (stm != null) {
            try { stm.close(); } catch (SQLException ex) { logger.error("", ex);  }
         }
      }
      return (upd > 0);
   }
   
} //class//

