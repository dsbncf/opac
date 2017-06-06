<%@ page language="java" contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="inc/setup.jsp" %>
<%
  String key = (String)request.getAttribute("key"); // parole da cercare
  String fld = (String)request.getAttribute("fld"); // selettore della lista
  String ft  = (String)request.getParameter("ft");  // ricerca full-text
  String listurl = contextPath + "/list";
  int pagelength = 20;
%>
<html>
<head>
    <meta http-equiv="content-type" content="text/html; charset=UTF-8">
    <title>Opac2 - Prototipo (consultazione liste)</title>
    <link rel="stylesheet" href="<%=contextPath%>/css/base.css"   type="text/css" media="screen"/>
    <link rel="stylesheet" href="<%=contextPath%>/css/search.css" type="text/css" media="screen"/>
</head>
<body>

<%@ include file="inc/testa.jsp" %>

<%@ include file="inc/topmenu.jsp" %>

<div id="content">

<%@ include file="inc/listbrowser_form.jsp" %>

<%@ include file="inc/fulltextbrowser_result.jsp" %>

 <div class="boxed">
 </div>

</div><!--#page-->

<%@ include file="inc/footer.jsp" %>

</body>
</html>
