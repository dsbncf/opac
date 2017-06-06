<%@ page language="java" pageEncoding="UTF-8" import="java.util.ArrayList,bncf.opac.util.ListItem,java.net.URLEncoder" %>
<%
  ArrayList<ListItem> list = (ArrayList<ListItem>)request.getAttribute("list");
  String facetfield = fld + "_fc";
%>
<div id="lista">
<% if (list != null) { %>
<table border="1">
<% for (ListItem item : list) { %>
<tr class="norm" onMouseOver="this.className='high'" onMouseOut="this.className='norm'">
  <td><a href="<%=contextPath%><%=item.getLink()%>" title="<%=lang.translate("vai al documento") %> <%=item.getDisplay().replaceAll("\"","") %>"><%=item.getDisplay()%></a></td>
  <td style="text-align:right"><%=item.getCount()%></td></tr>
<% } %>
</table>
<br/>

<% //output dei bottoni "precedenti" "successivi"
   int pagelength = 20;
   boolean hasMoreItems = false;
   int sz = 0, offs = 0, prev = 0, next = 0;
   if ((list != null) && ((sz = list.size()) > 0))
   {
      next = list.get(sz-1).getPosition() + 1;
      offs = list.get(0).getPosition();
      prev = (offs > pagelength) ? offs -pagelength : 1;
      if (prev < 0) prev = 0;
      hasMoreItems = (next == offs + pagelength);
   }
   String btnPrevStyle    = (offs < 2) ? "" : "style=\"color:#26b;\"";
   String btnPrevDisabled = (offs < 2) ? "disabled" : "";
   String imgPrevStyle    = (offs < 2) ? "class=\"disabled\"" : "";
   String btnNextStyle    = hasMoreItems ? "style=\"color:#26b;\"" : "";
   String btnNextDisabled = hasMoreItems ? "" : "disabled";
   String imgNextStyle    = hasMoreItems ? "" : "class=\"disabled\"";
%>

&nbsp;&nbsp;
<form action="<%=listurl%>/<%=fld%>" class="list-form" title="<%=lang.translate("precedenti") %>">
  <input type="hidden" name="start" value="<%=prev%>" />
  <button type="submit" <%=btnPrevStyle%> <%=btnPrevDisabled%> title="<%=lang.translate("precedenti") %> (AccessKey: - )" accesskey="-">
    <img <%=imgPrevStyle%> alt="<%=lang.translate("precedenti") %>"	src="<%=contextPath %>/img/prev-blue.gif"/>&nbsp;<%=lang.translate("precedenti") %>
  </button>
</form>
&nbsp;&nbsp;
<form action="<%=listurl%>/<%=fld%>" class="list-form" title="<%=lang.translate("successivi") %>">
  <input type="hidden" name="start" value="<%=next%>" />
  <button type="submit" <%=btnNextStyle%> <%=btnNextDisabled%> title="<%=lang.translate("successivi") %> (AccessKey: + )" accesskey="+">
    <%=lang.translate("successivi") %>&nbsp;<img <%=imgNextStyle%> alt="<%=lang.translate("successivi") %>"	src="<%=contextPath %>/img/next-blue.gif" />
  </button>
</form>

<% }//list!=null %>
</div><!--#lista-->