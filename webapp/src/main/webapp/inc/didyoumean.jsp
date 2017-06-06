<%@page language="java" contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="java.net.URLEncoder"%>
<%
  String[] similarTerms = (String[])request.getAttribute("didyoumean");
  if ((similarTerms != null) && (similarTerms.length > 0))
  {
%>
<div id="didyoumean">
<strong><%=lang.translate("forse_cercavi") %>:</strong>&nbsp;&nbsp;
<%
   for (int i=0; i<similarTerms.length; i++)
   {
     String similarTerm = similarTerms[i];
     String url = contextPath + "/" + ricerca + "?" + "sf1=keywords&amp;sv1="
               + URLEncoder.encode(similarTerm, "UTF-8") + "&amp;start=0";
     String separator = (i<similarTerms.length-1) ? ",&nbsp;" : "";
%>
 <a title="<%=lang.translate("forse_cercavi") %>&nbsp;<%=similarTerm.replace("\"","&quot;") %>"
	href="<%=url%>" style="font-weight: bold; font-size: 1.2em;" ><%=similarTerm%></a><%=separator%>
<% } %>
</div>
<% } %>
