<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="inc/no-cache-headers.jsp" %>
<%@ include file="inc/setup.jsp" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="x" uri="http://java.sun.com/jsp/jstl/xml" %>

<%-- <c:out value="${pageContext.request.contextPath}"/> --%>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN"
"http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" lang="en" xml:lang="en">
<head>
 <meta http-equiv="content-type" content="text/html; charset=UTF-8">
 <title>SBN OPAC - opzioni utente</title>
 <link rel="stylesheet" href="./css/base.css" type="text/css" media="screen"/>
</head>
<body>

<%@ include file="inc/testa.jsp" %>
  
<%@ include file="inc/topmenu.jsp" %>

<div id="main">

<br/>
<br/>
<br/>

<div id="opacuser">
versione accessibile: <strong><%=accessible%></strong>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
<% if (accessible) { %>
  <a href="<%=contextPath%>/options?accessible=0">scegli la versione avvanzata (JavaScript enabled)</a>
<% } else { %>
  <a href="<%=contextPath%>/options?accessible=1">scegli la versione accessibile</a>
<% } %>
<br/>
lingua: <strong><%=language%></strong>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
<% if (language.equals("it")) { %>
  <a href="<%=contextPath%>/options?language=en">passa alla lingua inglese</a>
<% } else { %>
  <a href="<%=contextPath%>/options?language=it">passa alla lingua italiana</a>
<% } %>
<br/>
</div>

</div><!--#main-->
</body>
</html>


