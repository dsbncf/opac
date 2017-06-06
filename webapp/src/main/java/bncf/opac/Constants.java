
package bncf.opac;


public class Constants
{
  public static final String BASEENV        = "java:/comp/env";

  //// session keys
  public static final String SKEY_APPCONFIG = "AppConfig";
  public static final String SKEY_OPACUSER  = "opacUser"; //Presente anche in OpacuserServlet

  // attribute keys for application context attributes
  public final static String AKEY_FACETCOUNTS = "facetCounts";

  ///// servlet config init parameters
  public static final String IPARAM_LOADCONTEXT        = "load-context";
  public static final String IPARAM_LOG4JPROPERTIES    = "log4j-properties";
  public static final String IPARAM_LOG4JWATCH         = "log4j-watch";
  public static final String IPARAM_APPCONFIGKEY       = "appconfig-key";
  public static final String IPARAM_DATASOURCE         = "DataSource";
  public static final String IPARAM_DEFAULTLOCALE      = "default-locale";
  public static final String IPARAM_DATASOURCES        = "datasources";
  public static final String IPARAM_MESSAGEFILE        = "message-file";
  public static final String IPARAM_SOLRRESULT_NUMROWS = "solr-result-num";

  //// default values
  public static final int DEF_SOLRRESULT_NUMROWS = 20;
  // num max di termini da cercare (sf1, sf2, ... sfX)
  public static final int  DEF_SEARCHTERMSMAX    = 8;
  // config
  public static final String SERVLETPATH_BID = "/bid";


  //// AppConfig
  public static final String CFG_LOCALE = "Locale";

}//class//

