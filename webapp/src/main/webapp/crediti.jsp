<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="inc/no-cache-headers.jsp" %>
<%@ include file="inc/setup.jsp" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" lang="en" xml:lang="en">
<head>
  <meta http-equiv="content-type" content="text/html; charset=UTF-8">
  <title>SBN OPAC - <%=lang.translate("crediti") %></title>
  <link rel="stylesheet" href="css/base.css"    type="text/css" media="screen"/>
  <style type="text/css">
    table#credits { width: 600px; margin: 0px auto 30px auto; background-color: #B8CDD8; }
    table#credits td { font-face: Verdana, Arial, Helvetica, sans-serif; font-size: .8em; }
    table#credits td.td-label { white-space: nowrap; background-color: #FFF; padding: 10px; }
    table#credits td.td-value { white-space: nowrap; background-color: #FFF; padding: 10px; text-align: center; }
    table#credits td.td-note { background-color: #FFF; padding: 10px; }
  </style>
</head>
<body>

  <%@ include file="inc/testa.jsp" %>
  <%@ include file="inc/topmenu.jsp" %>

  <div id="main" style="padding-top: 30px;">

    <table cellpadding="2" cellspacing="1" id="credits">
      <tr>
        <td colspan="2">
          <strong><%=lang.translate("ideazione_e_coordinamento") %></strong>
        </td>
      </tr>
      <tr>
        <td colspan="2" class="td-label">
          <%=lang.translate("servizi_informatici_bncf") %>
        </td>
      </tr>
      <tr>
        <td colspan="2">
        <strong><%=lang.translate("tecnologie_utilizzate") %></strong></font>
        </td>
      </tr>
      <tr>
        <td class="td-label">
        Web Server - Apache
        </td>
        <td class="td-value">
          <a href="http://httpd.apache.org" target="_blank" title="<%=lang.translate("vai_al_sito_di_apache") %> <%=lang.translate("si_apre") %>"><img alt="Logo Web Server - Apache" border="0" src="<%=contextPath %>/img/logo_apache.gif"></a>
        </td>
      </tr>
      <tr>
        <td class="td-label">
        Text search engine - Solr
        </td>
        <td class="td-value">
        <a href="http://lucene.apache.org/solr/" target="_blank" title="<%=lang.translate("vai_al_sito_di_solr") %> <%=lang.translate("si_apre") %>"><img alt="Logo Solr - Text search engine" border="0" src="<%=contextPath %>/img/logo_solr.gif"></a>
        </td>
      </tr>
      <tr>
        <td class="td-label">
        Database Server - MySQL</font>
        </td>
        <td class="td-value">
        <a href="http://www.mysql.com" target="_blank" title="<%=lang.translate("vai_al_sito_di_mysql") %> <%=lang.translate("si_apre") %>"><img alt="Logo MySql - Database Server" border="0" src="<%=contextPath %>/img/logo_mysql.gif"></a>
        </td>
      </tr>
      <tr>
        <td class="td-label">
        <font size="2" face="Verdana, Arial, Helvetica, sans-serif">Application Server - Tomcat</font>
        </td>
        <td class="td-value">
        <a href="http://jakarta.apache.org/tomcat/" target="_blank" title="<%=lang.translate("vai_al_sito_di_tomcat") %> <%=lang.translate("si_apre") %>"><img alt="Logo Tomcat - Application Server" border="0" src="<%=contextPath %>/img/logo_tomcat.gif"></a>
        </td>
      </tr>
      <tr>
        <td colspan="2">
        <strong><%=lang.translate("sviluppo_ed_integrazione") %></strong>
        </td>
      </tr>
      <tr>
        <td class="td-label">
        WebDev Srl
        </td>
        <td class="td-value">
        <a href="http://www.webdev.it" target="_blank" title="Webdev <%=lang.translate("si_apre") %>"><img alt="Logo Webdev - sviluppo opac java lucene maxdb" border="0" src="<%=contextPath %>/img/logo_webdev.gif"></a>
        </td>
      </tr>
      <tr>
        <td colspan="2">
        <strong><%=lang.translate("note") %></strong>
        </td>
      </tr>
      <tr>
        <td bgcolor="#FFFFFF" style="padding:10px;" colspan="2" class="td-note">
        <%=lang.translate("il_navigatore_dewey_e") %>
        </td>
      </tr>
    </table>

  </div><!--#main-->

</body>
</html>
