<%@page language="java" pageEncoding="UTF-8"%>
<%@page import="bncf.opac.Constants"%>
<%@page import="bncf.opac.beans.OpacUser"%>
<%@page import="java.util.Locale"%>
<%@page import="bncf.opac.util.Translator"%>
<%@page import="bncf.opac.util.SearchResult"%>
<%
  String contextPath = request.getContextPath();
  OpacUser opacuser  = (OpacUser) session.getAttribute(Constants.SKEY_OPACUSER);
  Locale locale = (opacuser != null) ? opacuser.getLocale() : OpacUser.DEFAULT_LOCALE;
  Translator lang = new Translator(locale);

  // boolean  accessible = (opacuser != null) ? opacuser.hasAccessible() : false;
  // String language = (opacuser != null) ? opacuser.getLanguage() : OpacUser.DEFAULT_LOCALE.getLanguage();
%>
