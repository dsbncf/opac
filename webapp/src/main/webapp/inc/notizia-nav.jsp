<%@page language="java" contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<div id="notizia-nav">

<%
  if (recordCount > 1)
  {
%>

<div class="notizia-nav-left">
<%
     String listpos = "";
     if (position > 0)
     {
        listpos = "/" + (position - 1);
%>
     <%=lang.translate("documento") %>&nbsp;<strong><%=position%></strong>&nbsp;<%=lang.translate("di") %>&nbsp;<strong><%=recordCount%></strong>
<%   } %>
</div>

<%  if ((queryString != null) && !queryString.equals("")) { %>
<div class="notizia-nav-right">

      <a href="<%=contextPath%>/<%=ricerca%><%=listpos%>?<%=queryString%>"
	title="<%=lang.translate("torna_alla_lista_risultati")%> (AccessKey: i )"
	accesskey="i"><%=lang.translate("torna_alla_lista_risultati")%></a>&nbsp;&nbsp;&nbsp;&nbsp;

<%  if (prevBid != null) { %>
  <form action="<%=contextPath %>/bid/<%=prevBid%>" method="GET">
<%
  if ( queryString != null )
  {
    String[] arrQs = queryString.split("&");
    for ( int i = 0; i < arrQs.length; i++ )
    {
      String[] paramsValue = arrQs[i].split("=");
      if (paramsValue.length == 2 )
      {
         String value = paramsValue[1].replaceAll("%22", "&quot;").replaceAll("%20"," ");
%>
  <input type="hidden" name="<%=paramsValue[0]%>" value="<%=value%>" />
<%
      }
    }
  }
%>
  <button type="submit" title="<%=lang.translate("vai_doc_prec") %> (AccessKey: - )" accesskey="-">
	<img alt="<%=lang.translate("vai_doc_prec") %>" src="<%=contextPath %>/img/prev.gif" />
  </button>
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
<%
  if ( queryString != null )
  {
    String[] arrQs = queryString.split("&");
    for ( int i = 0; i < arrQs.length; i++ )
    {
      String[] paramsValue = arrQs[i].split("=");
      if (paramsValue.length == 2 )
      {
         String value = paramsValue[1].replaceAll("%22", "&quot;").replaceAll("%20"," ");
%>
  <input type="hidden" name="<%=paramsValue[0] %>" value="<%=value%>" />
<%
      }
    }
  }
%>
	<button type="submit"	title="<%=lang.translate("vai_doc_succ") %> (AccessKey: + )"
	accesskey="+"><img alt="<%=lang.translate("vai_doc_succ") %>"
	src="<%=contextPath %>/img/next.gif"/>
  </button>
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
