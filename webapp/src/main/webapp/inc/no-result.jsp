<%@page language="java" contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<div id="resultcontainer">
    <div id="result">
<%
  if (solrResult!=null)
  {
%>
        <%=lang.translate("documenti_trovati") %>:&nbsp;&nbsp;
        <strong><%=numFound%></strong>
        <hr noshade="1" size="1">
        <p><%=lang.translate("nessun_documento_trovato") %>.</p>
        <hr noshade="1" size="1">
<%
  }
%>
    <%@include file="didyoumean.jsp" %>
    </div>
</div>

<%@include file="filters.jsp" %>
