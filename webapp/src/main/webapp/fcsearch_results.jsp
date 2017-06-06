<%@page language="java" contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="org.w3c.dom.Document" %>
<%@page import="bncf.opac.servlet.SearchServlet" %>
<%@page import="webdev.webengine.solr.SolrResult"%>
<%@include file="inc/no-cache-headers.jsp" %>
<%@include file="inc/setup.jsp" %>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="x" uri="http://java.sun.com/jsp/jstl/xml" %>
<c:set var="lang"><%=locale.getLanguage() %></c:set>
<c:set var="ricerca" value="${requestScope.ricerca}"/>
<%
   boolean isValidSearch = (request.getAttribute("isValidSearch")!=null) ? ((Boolean)request.getAttribute("isValidSearch")).booleanValue() : false;

   SolrResult solrResult = null;
   int numFound = 0;
   int start    = 0;
   int rows     = 0;
   if (isValidSearch)
   {
       solrResult = (SolrResult)request.getAttribute("solrResult");
       numFound   = solrResult.getNumFound();
       start      = solrResult.getStart();
       rows       = solrResult.getRows();
   }

   int minFacetLimit = SearchServlet.getFacetLimitMin();
   int maxFacetLimit = SearchServlet.getFacetLimitMax();
   int maxResultsForExport = SearchServlet.getMaxResultsForExport();
   int queryhash = 0;
   String querystring = null;
   String showAll = "";
   String sort = request.getParameter("sort");
   String closedBoxes = "";
   if (opacuser != null)
   {
      showAll = opacuser.getShowAll();
      closedBoxes = opacuser.getClosedBoxes();
      if (opacuser.getSearchResult() != null)
      {
         queryhash = opacuser.getSearchResult().getHashCode();
         querystring =  opacuser.getSearchResult().getQueryString();
      }
   }
   String ricerca = (String) request.getAttribute("ricerca");
   if (ricerca == null)
      ricerca = "fcsearch";
   String requestURI = contextPath + "/" + ricerca;
%>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN"
"http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" lang="en" xml:lang="en">
<head>
    <title>Opac2 - Prototipo (Solr)</title>
    <meta http-equiv="content-type" content="text/html; charset=UTF-8"/>
    <link rel="stylesheet" href="<%=contextPath%>/css/base.css"    type="text/css" media="screen"/>
    <link rel="stylesheet" href="<%=contextPath%>/css/search.css"  type="text/css" media="screen"/>
    <link rel="stylesheet" href="<%=contextPath%>/css/facebox.css" type="text/css" media="screen"/>
    <style type="text/css">
      #facebox .footer { display: none; visibility: hidden; height: 1px; }
      .noJSScript { display: inline }
      .JSScript { display: none }
    </style>
    <script type="text/javascript">
     //<!--
      document.write('<style type="text/css">.noJSScript { display: none; }</style>');
      document.write('<style type="text/css">.JSScript { display: inline; }</style>');
     //-->
    </script>
</head>
<body>

<%@ include file="inc/testa.jsp" %>

<%@ include file="inc/topmenu.jsp" %>

 <div id="content">

<%if (ricerca.equals("fcsearch")) {%> <%@include file="inc/searchbase.jsp"%> <%}%>
<%if (ricerca.equals("fcsearchm")){%> <%@include file="inc/searchmultipla.jsp"%> <%}%>
<%
    if (isValidSearch)
    {
        if (numFound>0)
        {
%>
    <%@include file="inc/result.jsp"%>
<%
        } else {
%>
    <%@include file="inc/no-result.jsp"%>
<%
        }
    } else {
%>
    <div id="resultcontainer">
        <div id="result">
        </div>
        <%@include file="inc/facetsinfo.jsp"%>
    </div>
<%
    }
%>

<%--
<c:set var="dom" value="${requestScope.resultsDoc}"/>
<c:choose>
 <c:when test="${empty dom}">
	<%@ include file="inc/facetsinfo.jsp" %>
 </c:when>
 <c:otherwise>
    <c:import url="xsl/result_${lang}.xsl"  var="xslt" charEncoding="UTF-8" />
    <x:transform xml="${requestScope.resultsDoc}" xslt="${xslt}">
	<x:param name="requestURI"><%=requestURI%></x:param>
	<x:param name="param.showAll"><%=showAll%></x:param>
	<x:param name="param.facetLimitMin"><%=minFacetLimit%></x:param>
	<x:param name="param.facetLimitMax"><%=maxFacetLimit%></x:param>
	<x:param name="param.queryhash"><%=queryhash%></x:param>
	<x:param name="param.contextPath"><%=contextPath%></x:param>
	<x:param name="param.sort"><%=sort%></x:param>
    </x:transform>
 </c:otherwise>
</c:choose>
--%>

<div class="clearboth"></div>
<br/>



 </div><!--#page-->
<%@ include file="inc/footer.jsp" %>

 <script src="<%=contextPath%>/js/jquery.js"  type="text/javascript"></script>
 <script type="text/javascript">// <!--
    var globalClosedBoxes     = '<%=closedBoxes%>';
    var globalContextPath     = '<%=contextPath%>';
    var globalApriChiudiLabel = '<%=lang.translate("apri_chiudi_box") %>';
 //--></script>
 <script src="<%=contextPath%>/js/facebox.js"          type="text/javascript"></script> 
 <script src="<%=contextPath%>/js/library.js"          type="text/javascript"></script>
 <script src="<%=contextPath%>/js/search.js"           type="text/javascript"></script>

 <c:set var="opendetail" value="param.opendetail"/>
 <c:if test="${param.opendetail > 0}">
 <script type="text/javascript">
  $(function(){
    openDetailByLinkId(<c:out value="${param.opendetail}" />);    
  });
 </script>
 </c:if>

</body>
</html>
