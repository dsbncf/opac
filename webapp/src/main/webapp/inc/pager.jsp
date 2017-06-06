<%@page language="java" contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%
  {
    int defaultPageRange = 9;
    int currentPage = (int)Math.round(Math.floor(start / rows)) + 1;
    int pageRange = defaultPageRange;
    if (currentPage > 9995)
       pageRange = defaultPageRange - 5;
    else if (currentPage > 995)
         pageRange = defaultPageRange - 3;
       else if (currentPage > 95)
            pageRange = defaultPageRange - 2;

    int halfRange = (int)Math.round(Math.floor(pageRange / 2));
    currentPage = (int)Math.round(Math.floor(start / rows)) + 1;
    int maxPage = ((numFound % rows) == 0) ? (int)(numFound / rows) : (int)Math.round(Math.floor(numFound / rows)) + 1;

    if (maxPage > 1)
    {
        int lpgs = maxPage - pageRange + 1;
        int lastpagestart = (lpgs < 1) ? 1 : lpgs;
        int firstPage = 1;
        if (currentPage > lastpagestart)
           firstPage = lastpagestart;
        else
           if (currentPage > halfRange)
              firstPage = currentPage - halfRange;
        int lpg = firstPage + pageRange -1;
        int lastPage = (lpg > maxPage) ? maxPage : lpg;
	long offsetLastPage = (maxPage - 1) * rows;
%>
<%--
<br/>
<div style="background:yellow;clear:both">
	maxPage: <%=maxPage%> <br/>
	currentPage: <%=currentPage%> <br/>
	lastpagestart: <%=lastpagestart%> <br/>
	firstPage: <%=firstPage%> <br/>
	lastPage: <%=lastPage%> <br/>
	lpg: <%=lpg%> <br/>
	lpgs: <%=lpgs%> <br/>
	pageRange: <%=pageRange%> <br/>
	<br/>
</div>
--%>

<div id="pager">
<div>
<%      if (currentPage > 1) { %>
	<!-- goto first page -->
	<a class="std-page" href="<%=getURL(request,0)%>" title="<%=lang.translate("vai_alla_prima_pagina") %> (AccessKey: i)" accesskey="i">
		<img src="<%=contextPath%>/img/first.gif" alt="<%=lang.translate("icona_vai_alla_prima_pagina") %>" /></a>
	<!-- goto previous page -->
	<a class="std-page" id="previous-page" href="<%=getURL(request,start - rows)%>" title="<%=lang.translate("vai_alla_pagina_precedente") %> (AccessKey: -)" accesskey="-">
		<img src="<%=contextPath%>/img/prev.gif" alt="<%=lang.translate("icona_vai_alla_pagina_precedente") %>" /></a>
<%      } %>
<%
        for (int pg = firstPage ; pg <= lastPage ; pg++)
        {
	    long offset = (pg - 1) * rows;
            if (currentPage == pg)
            {
%>
	<b class="std-page"><%=pg%></b>
<%           } else { %>
	<a class="std-page" href="<%=getURL(request,offset)%>" title="<%=lang.translate("pagina") %> <%=pg%>"><%=pg%></a>
<%           }
         }
%>

<%      if (currentPage < maxPage) { %>
	<!-- goto next page -->
	<a class="std-page" id="next-page" href="<%=getURL(request,start+rows)%>" title="<%=lang.translate("vai_alla_pagina_successiva") %> (AccessKey: +)" accesskey="+">
		<img src="<%=contextPath%>/img/next.gif" alt="<%=lang.translate("vai_alla_pagina_successiva") %>" /></a>
	<!-- goto last page -->
	<a class="std-page" href="<%=getURL(request,offsetLastPage)%>" title="<%=lang.translate("vai_all_ultima_pagina") %> (AccessKey: f)" accesskey="f">
		<img src="<%=contextPath%>/img/last.gif" alt="<%=lang.translate("icona_vai_all_ultima_pagina") %>" /></a>
<%      } %>

  <div class="clearboth"></div>
</div>
</div>
<div class="clearboth"></div>

<%  }//if maxPage > 1
  } %>
