<%@ page language="java" pageEncoding="UTF-8"
	import="bncf.opac.beans.OpacUser" %>
<%
  OpacUser opacuser  = (OpacUser) session.getAttribute("OpacUser");
  boolean  accessible = (opacuser != null) ? opacuser.hasAccessible() : false;
  String  language = (opacuser != null) ? opacuser.getLanguage() : OpacUser.DEFAULT_LOCALE.getLanguage();
  String   contextPath = request.getContextPath();
%>
