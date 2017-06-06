<%@ page language="java" pageEncoding="UTF-8" %>
<%
   response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");  //HTTP 1.1
   response.setHeader("Pragma","no-cache");   //HTTP 1.0
   response.setDateHeader ("Expires", -1);    //prevents caching at the proxy server
%>
