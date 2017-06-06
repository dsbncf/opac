<%@ page language="java" contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="inc/setup.jsp" %>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html;charset=UTF-8"> 
	<title>Documento in lavorazione </title>
	<link rel="stylesheet" href="<%=contextPath%>/css/base.css" type="text/css" media="screen"/>
</head>
<body>
<%@ include file="/inc/testa.jsp" %>
<%@ include file="/inc/topmenu.jsp" %>
<div id="main">
<%@ include file="/inc/menu.jsp" %>
  <br/><br/><br/>
  <table width="700" align="center" cellpadding="20" cellspacing="1" bgcolor="#B8CDD8">
   <tr>
    <td bgcolor="#FFFFFF">
     <br>
	<b><%=lang.translate("pubblicazione_non_disponibile") %></b>
      <br>
      <br>
	<i><%=lang.translate("info_pubblicazione_non_disponibile") %></i>
      <br/><br/><br/><br/>
      <center><a title="<%=lang.translate("torna_indietro") %>" href="javascript:history.back();"><img alt="<%=lang.translate("indietro") %>"
			src="<%=contextPath%>/img/indietro.gif"></a></center>
      </td>
    </tr>
  </table>
  <br/><br/>
</div><!--#main-->
<%@ include file="inc/footer.jsp" %>
</body>
</html>
