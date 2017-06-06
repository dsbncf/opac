<%@page language="java" contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@page import="java.util.Set"%>
<%@page import="java.util.Map"%>
<%@page import="java.util.HashMap"%>
<%@page import="bncf.opac.beans.Record"%>
<div id="notizia-nav">
<%
  if ( opacuser != null )
  {
    HashMap carrello = (HashMap) opacuser.getCart();
    recordCount = carrello.size();

    Set<Map.Entry<String, Record>> set = carrello.entrySet();
    int i = 0;

    boolean found = false;
    prevBid = null;
    nextBid = null;

    for (Map.Entry<String, Record> entry : set)
    {
      i++;

      if (found)
      {
        nextBid = entry.getKey();
        break;
      }

      if (entry.getKey().equals(currentBid))
      {
        position = i;
        found = true;
      }

      if (!found)
        prevBid = entry.getKey();
    }

    if ( recordCount > 0 ) 
    {
%>

<div class="notizia-nav-left">
<%
     String listpos = "";
     if (position > 0)
     {
%>
     <%=lang.translate("documento") %>&nbsp;<strong><%=position%></strong>&nbsp;<%=lang.translate("di") %>&nbsp;<strong><%=recordCount%></strong>
<%   } %>
</div>

<div class="notizia-nav-right">

      <a href="<%=contextPath%>/cart.jsp"
	title="<%=lang.translate("torna_al_carrello")%> (AccessKey: i )"
	accesskey="i"><%=lang.translate("torna_al_carrello")%></a>&nbsp;&nbsp;&nbsp;&nbsp;

<%  if (prevBid != null) { %>
  <form action="<%=contextPath %>/bid/<%=prevBid%>" method="GET">
  <button type="submit" title="<%=lang.translate("vai_doc_prec") %> (AccessKey: - )"
  accesskey="-">
	<img alt="<%=lang.translate("vai_doc_prec") %>"
	src="<%=contextPath %>/img/prev.gif" />
  </button>
  <input type="hidden" name="cart" value="true" />
  </form>
<%    } else {%>
  <form class="disabled">
  <button type="button" disabled="disabled" title="<%=lang.translate("nessun_doc_prec") %>">
	<img alt="<%=lang.translate("nessun_doc_prec") %>"
	src="<%=contextPath %>/img/prev.gif" />
  </button>
  </form>
<%    }%>

<%  if (nextBid != null) { %>
  <form action="<%=contextPath %>/bid/<%=nextBid%>" method="GET">
	<button type="submit"	title="<%=lang.translate("vai_doc_succ") %> (AccessKey: + )"
	accesskey="+"><img alt="<%=lang.translate("vai_doc_succ") %>"
	src="<%=contextPath %>/img/next.gif"/>
  </button>
  <input type="hidden" name="cart" value="true" />
  </form>
<%    } else {%>
  <form class="disabled">
  <button type="button" disabled="disabled" title="<%=lang.translate("nessun_doc_succ") %>">
	<img alt="<%=lang.translate("nessun_doc_succ") %>"
	src="<%=contextPath %>/img/next.gif" />
  </button>
  </form>
<%    }%>

</div><!--#notizia-nav-right-->
<%  }%>

<% } %>
 <div class="clearboth"></div>
</div>
<div class="clearboth"></div>
