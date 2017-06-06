<%@ page language="java" pageEncoding="UTF-8" import="java.util.ArrayList,bncf.opac.util.ListItem" %>
<%
  ArrayList<ListItem> list = (ArrayList<ListItem>)request.getAttribute("list");
  // String facetfield = (String)request.getAttribute("facetfield");
  String facetfield = fld + "_fc";
%>
<div id="lista">
<table border="1">
<% for (ListItem item : list) { %>
<tr class="norm" onMouseOver="this.className='high'" onMouseOut="this.className='norm'">
  <td><a href="<%=contextPath%><%=item.getLink()%>" title="<%=lang.translate("vai al documento") %> <%=item.getDisplay().replaceAll("\"","") %>"><%=item.getDisplay()%></a></td><td style="text-align:right"><%=item.getCount()%></td>
</tr>
<%}%>
</table>

<br>

<% //output dei bottoni "precedenti" "successivi"
   int start  = ((Integer)request.getAttribute("start")).intValue();
   int totale = ((Integer)request.getAttribute("totale")).intValue();
   int prev   = (start > pagelength) ? start - pagelength : 1;
   int next   = (start < (totale - pagelength)) ? start + pagelength : 0;
   boolean hasPrev = (start > 1);
   boolean hasNext = (next > 0);
   String btnPrevStyle    = hasPrev ? "style=\"color:#26b;\"" : "";
   String btnPrevDisabled = hasPrev ? "" : "disabled";
   String btnNextStyle    = hasNext ? "style=\"color:#26b;\"" : "";
   String btnNextDisabled = hasNext ? "" : "disabled";
   String btnPrevTitle    = hasPrev ? lang.translate("vai_ai_doc_prev") : lang.translate("nessun_doc_prev");
   String btnNextTitle    = hasNext ? lang.translate("vai_ai_doc_succ") : lang.translate("nessun_doc_succ");
   String imgPrevStyle    = hasPrev ? "" : "class=\"disabled\"";
   String imgNextStyle    = hasNext ? "" : "class=\"disabled\"";

   if (hasPrev || hasNext)
   {
%>

<form action="<%=listurl%>/<%=fld%>" style="margin-bottom:0px;line-height: 1.3em;" class="list-form">
<input type="hidden" name="ft" value="1"/>
<input type="hidden" name="key" value="<%=key%>"/>
<input type="hidden" name="fld" value="<%=fld%>"/>
&nbsp;&nbsp;
<button type="submit" name="start" value="<%=prev%>" <%=btnPrevStyle%> <%=btnPrevDisabled%> title="<%=btnPrevTitle %> (AccessKey: - )" accesskey="-">
  <img <%=imgPrevStyle%> alt="<%=lang.translate("precedenti") %>"	src="<%=contextPath %>/img/prev-blue.gif"/>&nbsp;<%=lang.translate("precedenti") %>
</button>
&nbsp;&nbsp;&nbsp;
<button type="submit" name="start" value="<%=next%>" <%=btnNextStyle%> <%=btnNextDisabled%> title="<%=btnNextTitle %> (AccessKey: + )" accesskey="+">
  <%=lang.translate("successivi") %>&nbsp;<img <%=imgNextStyle%> alt="<%=lang.translate("successivi") %>"	src="<%=contextPath %>/img/next-blue.gif" />
</button>
</form>
<%  } %>

</div><!--#lista-->

