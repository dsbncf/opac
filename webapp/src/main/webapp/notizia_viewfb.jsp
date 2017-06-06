<%@ page language="java" contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"
        import="org.w3c.dom.Document" %>
<%@ include file="inc/no-cache-headers.jsp" %>
<%@ include file="inc/setup.jsp" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="x" uri="http://java.sun.com/jsp/jstl/xml" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN"
"http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" lang="en" xml:lang="en">
<head>
    <title>Opac2 - Prototipo (Solr)</title>
    <meta http-equiv="content-type" content="text/html; charset=UTF-8">
    <link rel="stylesheet" href="<%=contextPath%>/css/base.css" type="text/css" media="screen"/>
    <link rel="stylesheet" href="<%=contextPath%>/css/notiziafb.css" type="text/css" media="screen"/>
</head>
<body>

<c:set var="lang"><%=locale.getLanguage() %></c:set>

   <div id="content" style="width: 900px; height: 450px; overflow-y: auto;">

   <c:set var="dom" value="${requestScope.record}"/>
   <c:choose>
   <c:when test="${empty dom}">no record found !</c:when>
   <c:otherwise>
    <c:import url="xsl/notizia_${lang}.xsl"  var="xslt" charEncoding="UTF-8" />
    <div id="notizia">
     <x:transform xml="${requestScope.record}" xslt="${xslt}">
      <x:param name="contextpath"       value="<%=contextPath%>"/>
     </x:transform>
    </div><!--#notizia-->
   </c:otherwise>
   </c:choose>

   <c:set var="titolo">
     <x:out select="$dom/rec/df[@t=200]/sf[@c='a']"/><x:if select="$dom/rec/df[@t=200]/sf[@c='e'] != ''">: <x:out select="$dom/rec/df[@t=200]/sf[@c='e']"/></x:if>
   </c:set>
   <c:set var="autore">
     <x:out select="$dom/rec/df[@t=200]/sf[@c='f']"/>
   </c:set>
   <c:set var="dt100sfa">
     <x:out select="$dom/rec/df[@t=100]/sf[@c='a']"/>
   </c:set>

   <c:set var="apo">'</c:set>
   <c:set var="escapedApo">\'</c:set>

   <c:set var="titolo" value="${fn:replace(titolo, apo, escapedApo)}" />
   <c:set var="autore" value="${fn:replace(autore, apo, escapedApo)}" />
   <c:set var="anno" value="${fn:substring(dt100sfa, 9, 13)}" />

   <div class="clearboth"></div>
   <br/>

   </div><!--#page-->

   <div id="fb-control">
    <div id="fb-control-left">
      <a href="<%=contextPath %>/bid/<c:out value="${param.bid}" />?fmt=xml"><img style="vertical-align: center;" src="<%=contextPath%>/img/xml_download.png" alt="scarica il record in formato XML" title="scarica il record in formato XML"/></a>
      &nbsp;&nbsp;
      <%
        boolean bidInCart = (opacuser != null) ? opacuser.hasBidInCart((String) request.getAttribute("bid")) : false;
      %>
      <a href="#" <% if ( bidInCart ) { %>style="display: none;"<% } %> onclick="addBidToCart('<c:out value="${param.bid}" />','<c:out value="${titolo}"/>','<c:out value="${autore}"/>','<c:out value="${anno}"/>'); return false;" id="add-<c:out value="${param.bid}" />-to-cart" class="add-to-cart" title="aggiungi libro al carrello">
        <img style="vertical-align: bottom;" src="<%=contextPath%>/img/add-book.png" alt="aggiungi libro al carrello" />
      </a>
      <a href="#" <% if ( ! bidInCart ) { %>style="display: none;"<% } %> onclick="removeBidFromCart('<c:out value="${param.bid}" />'); return false;" id="remove-<c:out value="${param.bid}" />-to-cart" class="remove-to-cart" title="aggiungi libro al carrello">
        <img style="vertical-align: bottom;" src="<%=contextPath%>/img/added-book.png" alt="rimuovi libro dal carrello" />
      </a>
      <div id="msg-<c:out value="${param.bid}" />-cart" class="msg-cart"></div>
    </div>
    <div id="fb-control-middle">
      <%-- la somma con zero forza il casting a numero intero --%>
      <c:set var="linkid" value="${param.linkid + 0}" />
      <c:set var="numrows" value="${param.numrows + 0}" />

      <c:set var="rstart" value="${param.rstart + 0}" />
      <c:set var="rend" value="${param.rend + 0}" />
      <c:set var="rtot" value="${param.rtot + 0}" />

      &nbsp;&nbsp;&nbsp;&nbsp;
      <button id="prev-button-fb" <c:if test="${linkid == 1 and rstart == 0}">disabled="disabled"</c:if>
              <c:choose>
                <c:when test="${linkid > 1}">onclick="$('#n<c:out value="${linkid - 1}" />').click();"</c:when>
                <c:otherwise>onclick="gotoPrevPage();"</c:otherwise>
              </c:choose>>&lt;&lt; indietro
      </button>

      &nbsp;&nbsp;
      <button id="next-button-fb" <c:if test="${linkid == numrows and rend == rtot}">disabled="disabled"</c:if>
              <c:choose>
                <c:when test="${linkid < numrows}">onclick="$('#n<c:out value="${linkid + 1}" />').click();"</c:when>
                <c:otherwise>onclick="gotoNextPage();"</c:otherwise>
              </c:choose>>avanti &gt;&gt;
      </button>
    </div>

    <div id="fb-control-right">
      <button onclick="$(document).trigger('close.facebox'); return false;"><img src="<%=contextPath%>/img/cross.png" alt="chiudi" style="float: left;" />&nbsp;chiudi</button>
    </div>

   </div>

</body>
</html>
