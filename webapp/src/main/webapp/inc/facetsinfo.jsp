<%@page language="java" pageEncoding="UTF-8"%>
<%@page	import="bncf.opac.Constants"%>
<%@page import="webdev.webengine.solr.FacetInfo"%>
<%@page import="webdev.webengine.solr.FacetEntry"%>
<%@page import="webdev.webengine.solr.SolrResult"%>
<div id="filterbox-static">
<h4><%=lang.translate("copertura_catalogo_polo_bncf") %></h4>
<%
  SolrResult facetInfoResult  = (SolrResult)application.getAttribute(Constants.AKEY_FACETCOUNTS);

  String[] fcsigle = { "bib", "cat", "ann", "lin" };
  String[] fcnames = { "biblioteca_fc", "categoria_fc", "annopub_fc", "lingua_fc" };
  int[]    minrows = { 10, 25, 20, 20 };  // min rows to show
  int[]    maxrows = { 10, 25, 20, 100 }; // max rows to show
  String  baselink = contextPath + "/" + ricerca + "?";
  for (int k = 0 ; k < fcsigle.length ; k++)
  {
    String facetname  = fcnames[k];
    String facetsigla = fcsigle[k];
%>
 <div class="std-box-grey">
  <div class="std-title-grey js-title-facets" id="title-<%=facetname%>"><%=lang.translate(facetname)%>:</div>
  <div id="container-<%=facetname%>">
<%
   FacetInfo facetinfo = facetInfoResult.getFacetInfo(facetname);
   if (facetsigla.equals("ann") || facetsigla.equals("annopub_fc"))
	facetinfo.sortByName(false);

   int i = 0;
   int max = facetsigla.equals(showAll) ? maxrows[k] : minrows[k];
   if (facetinfo != null)
   {
     for (FacetEntry entry : facetinfo)
     {
       if (i++ >= max)
          break;
       String name = entry.getName();
       String displayName = name;
       if (!facetsigla.equals("ann")) // eccezione "ann"
          displayName = lang.translate(facetname + "." + name);
       else
          name = "%22"+name+"%22";
       String link = baselink + facetname + "=" + name;
       String title = lang.translate("filtra_per") + " " + displayName.replaceAll("\"", "&quot;");
%>
      <p><a href="<%=link%>" title="<%=title %>"><%=displayName%></a>&nbsp;&nbsp;<span class="graynum">(<%=entry.getCount()%>)</span></p>
<%
     }
     if ((max == minrows[k]) && (facetinfo.size() > minrows[k]))
     {
%>
      <p style="text-align: right;">
        <a href="<%=baselink%>exp=<%=facetsigla%>" title="<%=lang.translate("mostra_tutti")%>"><%=lang.translate("mostra_tutti")%></a>
      </p>
<%
     }
   }
%>
  </div>
 </div>
<%
  }//for k..
%>

</div>
<div class="clearboth"></div>
