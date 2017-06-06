<%@page language="java" contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="java.util.Arrays"%>
<%-- inizio filtri (TUTTI) --%>

<%
    //ordine faccette da mostrare
    String[] fcsequence = { "biblioteca_fc", "categoria_fc", "lingua_fc", "soggetto_fc", "annopub_fc", "autore_fc", "opera_fc", "editore_fc" };
    //faccette i cui valori hanno bisogno del translate
    String[] fctranslate = { "biblioteca_fc", "categoria_fc", "lingua_fc", "tiposogg", "paese_fc" };
%>

    <div id="filterbox">
<%
  SearchTermList allTerms    = solrResult.getAllTermsList();

  boolean hasFilters = allTerms.size()>0;
  if (hasFilters)
  {
%>
    <div class="std-box-grey">
        <div class="std-title-grey"><%=lang.translate("la_tua_ricerca") %></div>
<%
        for (SearchTerm term: allTerms)
        {
            String field = term.getField();
            String value = term.getValue();
            String valueDisplay = delControlChar(value);
            if ( Arrays.asList(fctranslate).contains(field) )
              valueDisplay = lang.translate(field + "." + value);

%>
            <p>
            <strong><%=lang.translate(field)%></strong>:<br>
            <span style="padding-left: 3em"><%=valueDisplay %><a href="<%=getCleanURL(request, 0, field, value) %>" title="<%=lang.translate("elimina_il_filtro") %>">&nbsp;[x]</a></span>
            </p>
<%
        }
  }
%>
    </div>
<%
     SearchTermList filterTerms = solrResult.getFilterTermList();
     HashMap<String,String> appliedFilter = new HashMap<String,String>();
     for (SearchTerm searchTerm : filterTerms)
        appliedFilter.put(searchTerm.getField(),searchTerm.getValue());
     boolean filterIntro = false;

     for (String facetname : fcsequence)
     {
         //se il numero dei risultati e' 2, non vengono mostrati i filtri
         //biblioteca_fc, descrittore_fc e editore_fc (controllare se il numero
         //di risultati e' "1" e' inutile perche' la servlet rimanda direttamente
         //alla visualizzazione della notizia)
         if ((numFound<=2) && (facetname.equals("biblioteca_fc") || facetname.equals("descrittore_fc") || facetname.equals("editore_fc")))
             continue;
         //se il numero dei risultati e' inferiore al numero dei risultati mostrati
         //in una pagina, non vengono mostrati i filtri categoria_fc, lingua_fc e annopub_fc
         if ((numFound<=rows) && (facetname.equals("categoria_fc") || facetname.equals("lingua_fc") || facetname.equals("annopub_fc")))
             continue;
         //se il numero dei risultati e' inferiore al al numero dei risultati mostrati
         //in due pagine, non vengono mostrati i filtri categoria_fc, lingua_fc e annopub_fc
         if ((numFound<=(rows*2)) && (facetname.equals("autore_fc") || facetname.equals("opera_fc")))
             continue;

         String sigla = lang.translate("sigla."+facetname);
         FacetInfo fcinfo = solrResult.getFacetInfo(facetname);
	 if ("annopub_fc".equals(facetname))
	    fcinfo.sortByName(false);

         //se una facetta ha un solo filtro possibile o zero, non viene mostrata
         if (fcinfo.size() < 2)
            continue;

         //Eliminazione faccette se applicate come filtri nella ricerca
         if (appliedFilter.containsKey(facetname))
            continue;

         if (!filterIntro)
         {
%>
    <h4><%=lang.translate("filtra_ricerca_per") %></h4>
<%
            filterIntro = true;
         }
%>
    <div class="std-box-grey">
      <div class="std-title-grey js-title-facets" id="title-<%=facetname %>"><%=lang.translate(facetname)%></div>
      <div id="container-<%=facetname %>">
<%
         boolean show = false;
         if (showAll!=null && sigla.equals(showAll))
            show = true;
         int maxdisplay = minFacetLimit;
         if(show)
             maxdisplay = maxFacetLimit;
         int position   = 0;
         for (FacetEntry fcentry: fcinfo)
         {
            if (maxdisplay--==0)
            {
               if(!show && fcinfo.size()>minFacetLimit)
               {
%>
        <p style="text-align: right;">
          <a href="<%=getURL(request, sigla) %>" title="<%=lang.translate("mostra_tutti")%>"><%=lang.translate("mostra_tutti")%></a>
        </p>
<%
               }
 	       break;
           }
	   String feName = fcentry.getName();
 	   int   feCount = fcentry.getCount();
 	   if ((feCount < 1) || "".equals(feName)) // skip 0 counts and null labels
              continue;
 	   position++; // incrementa row count
 	   String feNameDisplay = feName;
           if (Arrays.asList(fctranslate).contains(facetname))
              feNameDisplay = lang.translate(facetname + "." + feName);
           else
           {
              feName = "%22" + feNameDisplay.replace("&","%26").replace("#","%23") + "%22";
           }
           feNameDisplay = delControlChar(feNameDisplay);
           String title = lang.translate("filtra_ricerca_per") + feNameDisplay.replace("\"","");
           String url = getURL(request,0,facetname,feName);
           // display single row
           //String urlValue = (isDateRange) ? feId : feName;
%>
        <p>
	<a href="<%=url%>" title="<%=title%>"><%=feNameDisplay %></a>&nbsp;&nbsp;<span class="graynum">(<%=feCount %>)</span>
	<br>
        </p>
<%
         }
%>
        </div>
    </div>
<%
     }
%>

    </div> <!-- end #filterbox -->

<%-- fine filtri (tutti) --%>
