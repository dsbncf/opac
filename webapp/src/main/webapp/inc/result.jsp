<%@page language="java" contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="java.util.Date"%>
<%@page import="java.util.Arrays"%>
<%@page import="java.util.HashMap"%>
<%@page import="webdev.webengine.solr.SearchTerm"%>
<%@page import="webdev.webengine.solr.SearchTermList"%>
<%@page import="webdev.webengine.solr.FacetInfo"%>
<%@page import="webdev.webengine.solr.FacetEntry"%>
<%@page import="webdev.webengine.solr.SolrResultDocument"%>
<%@page import="webdev.webengine.solr.SolrResult"%>
<%@page import="bncf.opac.util.StringUtils"%>
<%@page import="java.util.ArrayList"%>
<%@include file="result_declaration.jsp" %>
<%
    if (sort==null)
        sort="";
%>

<div id="resultcontainer">
    <div id="result">
<%
    int endrow = start+rows;
    if (endrow>numFound)
        endrow = numFound;
%>
        <%=lang.translate("documenti_trovati") %>:&nbsp;&nbsp;
        <strong><span id="startrow"><%=start+1 %></span>&nbsp;-&nbsp;<span id="endrow"><%=endrow %></span></strong>&nbsp;&nbsp;di&nbsp;&nbsp;<strong><span id="maxrows"><%=numFound %></span></strong>
        <span style="margin-left: 30px;" class="JSScript">
            <%=lang.translate("ordina_per") %>
            <select title="<%=lang.translate("scegli_ordinamento") %>" onchange="document.location=this.value;">
                <option <% if (sort.equals("")) { %>selected="selected"<% } %> value="<%=getURL(request, 0, "sort", "") %>" selected="selected"><%=lang.translate("ord_rilevanza") %></option>
                <option <% if (sort.equals("data")) { %>selected="selected"<% } %> value="<%=getURL(request,0,"sort", "data") %>"><%=lang.translate("ord_anno_decrescente") %></option>
                <option <% if (sort.equals("autore")) { %>selected="selected"<% } %> value="<%=getURL(request,0,"sort", "autore") %>"><%=lang.translate("ord_autore") %></option>
                <option <% if (sort.equals("titolo")) { %>selected="selected"<% } %> value="<%=getURL(request,0,"sort", "titolo") %>"><%=lang.translate("ord_titolo") %></option>
            </select>
        </span>
        <span style="margin-left: 30px;" class="noJSScript"><%=lang.translate("ordina_per") %>
            &nbsp;<strong>|</strong>&nbsp;
            <% if (sort.equals("")) { %>
                <strong><%=lang.translate("ord_rilevanza") %></strong>
            <% } else { %>
                <a href="<%=getURL(request,0,"sort", "") %>" title="<%=lang.translate("ord_rilevanza") %>"><%=lang.translate("ord_rilevanza") %></a>
            <% } %>
            &nbsp;<strong>|</strong>&nbsp;
            <% if (sort.equals("anno")) { %>
                <strong><%=lang.translate("ord_anno_decrescente") %></strong>
            <% } else { %>
                <a href="<%=getURL(request,0,"sort", "anno") %>" title="<%=lang.translate("ord_anno_decrescente") %>"><%=lang.translate("ord_anno_decrescente") %></a
            <% } %>
            &nbsp;<strong>|</strong>&nbsp;
            <% if (sort.equals("autore")) { %>
                <strong><%=lang.translate("ord_autore") %></strong>
            <% } else { %>
                <a href="<%=getURL(request,0,"sort", "autore") %>" title="<%=lang.translate("ord_autore") %>"><%=lang.translate("ord_autore") %></a>
            <% } %>
            &nbsp;<strong>|</strong>&nbsp;
            <% if (sort.equals("titolo")) { %>
                <strong><%=lang.translate("ord_titolo") %></strong>
            <% } else { %>
                <a href="<%=getURL(request,0,"sort", "titolo") %>" title="<%=lang.translate("ord_titolo") %>"><%=lang.translate("ord_titolo") %></a>
            <% } %>
            &nbsp;<strong>|</strong>&nbsp;
        </span>
<% if ((numFound>0) && (numFound<=maxResultsForExport)) { %>
        <span style="margin-left: 30px;" class="JSScript">
            <a href="<%=contextPath %>/exportsearch?<%=request.getQueryString() %>" title="<%=lang.translate("esporta_risultati") %>">
               <%=lang.translate("esporta_risultati") %>&nbsp;<img src="<%=contextPath %>/img/export.gif" title="<%=lang.translate("esporta_risultati") %>" alt="<%=lang.translate("esporta_risultati") %>" />
            </a>
        </span>
<% } %>
        <br><br>
        <hr size="1" noshade="1">
        <table border="1">
            <tr>
                <th><%=lang.translate("th_titolo") %></th><th><%=lang.translate("th_autore") %></th><th><%=lang.translate("th_anno") %></th><th><%=lang.translate("th_tipologia") %></th>
            </tr>

<%
   int docPosition = 0;
   for (SolrResultDocument doc : solrResult.getDocuments())
   {
        docPosition++;
        String categorie = "";
        ArrayList<String> categoriaAL = (ArrayList<String>)doc.getStringList("categoria");
        if (categoriaAL!=null )
        {
            for (int i=0; i<categoriaAL.size(); i++)
            {
                categorie = categorie + lang.translate("categoria_fc."+categoriaAL.get(i));
                if ( i<categoriaAL.size()-1)
                    categorie = categorie + "<br />";
            }
        }
%>
            <tr onMouseOut="this.className='norm'" onMouseOver="this.className='high'" class="norm">
                <td style="width:240px;">
                    <a title="<%=lang.translate("vai_doc") %>" href="<%=request.getContextPath() %>/bid/<%=formatTxt(doc.getString("idn")) %>/<%=queryhash %>/<%=start+docPosition %>?<%=querystring %>" id="n1" class="viewbid">
                        <%=formatTxt(delControlChar(doc.getString("titolo_dp"))) %>
                    </a>
                    <br>
                </td>
                <td class="med-col-wrap"><%=formatTxt(doc.getString("autore_dp")) %></td>
                <td class="min-col-nowrap"><%=formatTxt(doc.getInt("anno1")) %></td>
                <td class="min-col-nowrap small-font"><%=categorie %><br></td>
            </tr>
<%
   }
%>
        </table>
        <hr size="1" noshade="1" />

        <%@include file="didyoumean.jsp" %>

        <%@include file="pager.jsp" %>

    </div> <!-- end #result -->

 </div> <!-- end #resultcontainer -->

 <%@include file="filters.jsp" %>


       

