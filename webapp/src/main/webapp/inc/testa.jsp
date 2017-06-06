<%@ page language="java" pageEncoding="UTF-8" %>

<div id="testa">

 <div id="img">
        <img src="<%=contextPath%>/img/logo.jpg" alt="sbn opac" style="margin:0px;" alt="logo" />
 </div>

 <span id="acc">
<%--
 <br/>
 <a href="<%=contextPath%>"><%=lang.translate("home") %></a><br/>
<% if (!accessible) { %>
  <a href="<%=contextPath%>/options?accessible=1"
	title="<%=lang.translate("scegli_versione_accessibile") %>"><%=lang.translate("versione_accessibile") %></a>
<% } %>
 <br/>
--%>
 </span><!--#acc-->

<div style="overflow:hidden; height:52px; float: left;">
 <span class="polo"><%=lang.translate("catalogo_polo_bncf") %></span>
 <br/>
 <span class="top-bncf"><%=lang.translate("biblioteca_nazionale_centrale_fi") %></span>
 <br/>
</div>

<% String altlang  = locale.getLanguage().equals("it") ? "en" : "it"; %>
<div style="float: right">
<span style="font-size:0.8em;">
<a href="<%=contextPath %>/?lang=<%=altlang%>" title="<%=lang.translate("select_lang_"+altlang)%>"><%=lang.translate("select_lang_"+altlang)%></a>
</span>
</div>

</div><!--#testa-->
