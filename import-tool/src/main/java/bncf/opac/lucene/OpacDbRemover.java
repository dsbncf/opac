
package bncf.opac.lucene;

import java.sql.Connection;
import java.sql.CallableStatement;
import java.sql.DriverManager;
import java.sql.SQLException;




/**
 * Indicizza i records estratti dal file xml come documento Lucene.
 */

public class OpacDbRemover
{
  //private static Logger _logger = Logger.getLogger("UnimarcXmlDbLoader");

  private static final String stmt_delidn = "{call IDN_DELETE(?,?,?)}" ;

  private boolean readonly = false;
  // private boolean verbose  = false;

  private String dbdriver = null;
  private String dbname   = null;
  private String dbhost   = null;
  private String dbuser   = null;
  private String dbpass   = null;
  private String dburl    = null;
  private Connection conn = null;
  private CallableStatement  cs_delidn = null;


 public OpacDbRemover( )
 {
 }


 public void connect( String dbdriver, String dbhost,
                      String dbname, String dbuserpass ) throws Exception
 {
     this.dbdriver = dbdriver;
     this.dbhost   = dbhost;
     this.dbname   = dbname;

     String[] userpass = dbuserpass.split(",");
     this.dbuser   = userpass[0];
     this.dbpass   = userpass[1];
     this.dburl    = "jdbc:sapdb://" + dbhost + "/" + dbname;

     Class.forName("com.sap.dbtech.jdbc.DriverSapDB");
     conn = DriverManager.getConnection(dburl,dbuser, dbpass);
 }


 public boolean getReadonly()
 {
    return this.readonly;
 }

 public void setReadonly( boolean flag )
 {
    this.readonly = flag;
 }


 public Connection getConnection()
 {
    return this.conn;
 }

 public void setConnection( Connection conn )
 {
    this.conn = conn;
 }

 public void close( ) throws SQLException
 {
     if (cs_delidn != null)
        cs_delidn.close();
     conn.commit();
     conn.close();
 }

 public String getDbName( ) { return this.dbname; }
 public String getDbHost( ) { return this.dbhost; }
 public String getDbUser( ) { return this.dbuser; }
 public String getDbUrl ( ) { return this.dburl; }

 // ! Nota: l'indice notizia utilizza un idn convertito in lower case
 //         l'indice unimarc invece utilizza un idn in upper case.
 public boolean deleteIdn(String idn)
 {
   int notizia_id = -1;
   int unimarc_id = -1;

   if (idn == null)
       return false;

   String idnlc = idn.toLowerCase();
   // String idnuc = idn.toUpperCase();

   try
   {
      if (cs_delidn == null)
      {                                  
          cs_delidn = conn.prepareCall( stmt_delidn );
      }
      else
          cs_delidn.clearParameters();

      cs_delidn.setString(1,idnlc);
      cs_delidn.registerOutParameter(2, java.sql.Types.INTEGER);
      cs_delidn.registerOutParameter(3, java.sql.Types.VARCHAR, 255);

      int    ret_id  = 0;
      String ret_msg = null;
      if (! readonly)
      {
         // ! update
         cs_delidn.executeUpdate();
         ret_id  = cs_delidn.getInt(2);
         ret_msg = cs_delidn.getString(3);
      }

      if (ret_id != 1)
      {
        System.err.println(idn + ": [" + ret_id + "] " + ret_msg );
        return false;
      }
   }
   catch (Exception ex)
   {
      System.err.println( "Errore durante la cancellazione del bid (" + idn
                         + "): " + ex.getMessage() );
      return false;
   }
   return true;
 }




} // class //

