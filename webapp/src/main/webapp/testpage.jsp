<%@page language="java" pageEncoding="UTF-8" contentType="text/html;charset=UTF-8" %>
<%@page import="bncf.opac.Constants"%>
<%@page import="bncf.opac.beans.OpacUser"%>
<%@page import="bncf.opac.util.SearchResult"%>
<%@ page import="java.util.HashMap" %>
<%@taglib prefix="c"   uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%
   String thisPage = "/testpage.jsp";
   String contextPath = request.getContextPath();
   OpacUser opacUser = null;
   SearchResult searchResult = null;
   if (session != null)
   {
      String action = request.getParameter("action");
      if ((action != null) && action.equals("clear"))
      {
          session.invalidate();
          response.sendRedirect(contextPath + thisPage);
          return;
      }
      opacUser = (OpacUser) session.getAttribute(Constants.SKEY_OPACUSER);
      searchResult = (opacUser == null) ? null : opacUser.getSearchResult();
   }
   HashMap carrello = (opacUser == null) ? null : (HashMap)opacUser.getCart();
%>
<html>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" 
                    "http://www.w3.org/TR/html4/loose.dtd">
<head>
 <title>Session Info</title>
 <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
 <script type="text/javascript" src="js/jquery.js"></script>
 <style type="text/css">
	body { font-family: arial,helvetica,verdana; font-size: 9pt;}
	table { font-family: arial,helvetica,verdana; font-size: 9pt; border-collapse: collapse; }
	h2 { border-bottom: 2px solid blue; background: #e0e0f0; padding-left: 4px }
	td { padding: 1px 2px; }
	th { padding: 1px 2px; }
	td.rlinfo { white-space: nowrap; padding: 1px 3em 0px 8px; }
	.val { padding-left: 1em; font-weight: normal; }
	th.tit { text-align: left; font-size: 1.5em; padding-left:8pt; }
	.datatbl { display: none; width: 100%; overflow:auto }
	.tdlbl { vertical-align: top; white-space:nowrap; width: 5%; padding-right:8px }
	.sid { font-family: courier; font-size: 1.2em; letter-spacing:2px }
 </style>
</head>

<body>
<div>
Session-ID: <span class="sid"><%=session.getId()%></span>
</div>
<br/>
<br/>

<% if (opacUser != null) { %>
 <table border="1" width="80%">
  <thead>
   <tr><th class="tit" colspan="90">OpacUser</th></tr>
  </thead>
  <tbody>
   <tr>
	<td class="tdlbl">accessibile:</td>
	<td><span class="val"><%=opacUser.hasAccessible()%></span></td>
   </tr>
  </tbody>
 </table>
<br/>
<% } %>


<% if (searchResult != null) { %>
 <table border="1" width="80%">
  <thead>
   <tr><th class="tit" colspan="90">SearchResult</th></tr>
  </thead>
  <tbody>
   <tr> <td class="tdlbl">query string:</td>
	<td><span class="val"><%=searchResult.getQueryString()%></span></td>
  </tr>
   <tr> <td class="tdlbl">record count:</td>
	<td><span class="val"><%=searchResult.getRecordCount()%></span></td>
  </tr>
   <tr> <td class="tdlbl">start:</td>
	<td><span class="val"><%=searchResult.getStart()%></span></td>
  </tr>
   <tr> <td class="tdlbl">rows:</td>
	<td><span class="val"><%=searchResult.getNumRows()%></span></td>
  </tr>
   <tr> <td class="tdlbl">bids:</td>
	<td style="font-family: courier"><%for (String bid : searchResult.getBids()){%><%=bid%><br/><%}%></td>
  </tr>
  </tbody>
 </table>
<br/>
<% } %>


<% if (carrello != null) { %>
 <table border="1" width="80%">
  <thead>
   <tr><th class="tit" colspan="90">Carrello</th></tr>
  </thead>
  <tbody>
   <tr> <td class="tdlbl">num doc:</td>
	<td><span class="val"><%=carrello.size()%></span></td>
  </tr>
  </tbody>
 </table>
<br/>
<% } %>


<div>
<form>
 <input type="submit" name="action" value="reload"/>
 <input type="submit" name="action" value="clear"/>
</form>
</div>


</body>
</html>



