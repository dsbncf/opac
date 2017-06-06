<%@page language="java" contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@page import="org.w3c.dom.Document,java.util.HashMap" %>
<%@include file="inc/no-cache-headers.jsp" %>
<%@include file="inc/setup.jsp" %>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="x" uri="http://java.sun.com/jsp/jstl/xml" %>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN"
"http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" lang="en" xml:lang="en">
<head>
    <title>Opac2 - Prototipo (Solr)</title>
    <meta http-equiv="content-type" content="text/html; charset=UTF-8">
    <script src="<%=contextPath%>/js/jquery.js"   type="text/javascript"></script>
    <script src="<%=contextPath%>/js/opac.js"     type="text/javascript"></script>
    <script src="<%=contextPath%>/js/facebox.js"  type="text/javascript"></script>
    <link rel="stylesheet" href="<%=contextPath%>/css/base.css" type="text/css" media="screen"/>
    <link rel="stylesheet" href="<%=contextPath%>/css/notizia.css" type="text/css" media="screen"/>
    <link rel="stylesheet" href="<%=contextPath%>/css/facebox.css" type="text/css" media="screen"/>
    <script type="text/javascript">
      var globalContextPath = '<%=contextPath%>';
      var cartAddSuccessMsg = '<%=lang.translate("doc_aggiunto_ai_preferiti").replaceAll("'", "\\\\'") %>';
      var cartRemSuccessMsg = '<%=lang.translate("doc_rimosso_dai_preferiti").replaceAll("'", "\\\\'") %>';
      var cartErrorMsg      = '<%=lang.translate("errore_preferiti").replaceAll("'", "\\\\'") %>';
    </script>
    <script type="text/javascript">

      function insertSuggestion()
      {
        $('.suggest-error').html('');
        $('.suggest-error').hide();
        $('.suggest-buttons').attr('disabled','disabled');
        $('#suggest-loading-image').show();

        var url  = '<%=contextPath %>/insertsuggestion';

        var pars = 'bid=' + encodeURIComponent($('#fld_bid').val());
        pars    += '&email=' + encodeURIComponent($('#fld_email').val());
        pars    += '&testo=' + encodeURIComponent($('#fld_testo').val());
        pars    += '&captcha=' + encodeURIComponent($('#fld_captcha').val());
        pars    += '&' + urlTimestamp;

        var callAjax = $.ajax({
                    url: url,
                    data: pars,
                    async: false
                  }).responseText;

        if ( callAjax == null || callAjax == '' )
        {
          $('#suggest-main-error').html('<%=lang.translate("errore_nella_richiesta").replaceAll("'","\\\\'") %>');
          $('#suggest-main-error').show();
          $('.suggest-buttons').removeAttr('disabled');
          $('#suggest-loading-image').hide();
          return;
        }

        var arrCallAjax = callAjax.split('|');
        if ( arrCallAjax[0] == 'ok' )
        {
          $('#bid-suggest').html('<p style="text-align: center; padding: 40px 0px;"><%=lang.translate("suggerimento_salvato").replaceAll("'", "\\\\'") %></p>');
          return;
        }
        else
        {
          if ( arrCallAjax.length == 1 && arrCallAjax[0] == 'ko' )
          {
            $('#suggest-main-error').html('<%=lang.translate("errore_nella_richiesta").replaceAll("'", "\\\\'") %>');
            $('#suggest-main-error').show();
            $('.suggest-buttons').removeAttr('disabled');
            $('#suggest-loading-image').hide();
            return;
          }
          else if ( arrCallAjax.length == 3 && arrCallAjax[0] == 'ko' )
          {
            // Formato in cui restituisce errori:
            // status|numeroCampiObbligatori:nomecampo1,nomecampo2,|numeroCampiErrati:nomecampo1,nomecampo2
            // ko|0:|0:';
            // ko|1:email,|2:testo,email,';
            // ko|0:|2:testo,email,';
            // ko|1:email,|0:';

            var mainMessage = '<%=lang.translate("impossibile_salvataggio").replaceAll("'", "\\\\'") %><br />';

            var arrObbligatori = arrCallAjax[1].split(':');
            var intObbligatori = arrObbligatori[0];
            if ( intObbligatori > 0 )
            {
              mainMessage += '<%=lang.translate("campi_obbligatori").replaceAll("'", "\\\\'") %>: ' + intObbligatori + '<br />';
              var arrObbName = arrObbligatori[1].split(',');
              for (var key = 0; key < arrObbName.length-1; key++)
              {
                $('#suggest-fld_' + arrObbName[key] + '-error').html('<%=lang.translate("obbligatorio").replaceAll("'", "\\\\'") %>');
                $('#suggest-fld_' + arrObbName[key] + '-error').show();
              }
            }

            var arrErrati = arrCallAjax[2].split(':');
            var intErrati = arrErrati[0];

            if ( intErrati > 0 )
            {
              mainMessage += '<%=lang.translate("campi_formato_errato").replaceAll("'", "\\\\'") %>: ' + intErrati + '<br />';
              var arrErrName = arrErrati[1].split(',');
              for (var key = 0; key < arrErrName.length-1; key++)
              {
                $('#suggest-fld_' + arrErrName[key] + '-error').html('<%=lang.translate("modificare").replaceAll("'", "\\\\'") %>');
                $('#suggest-fld_' + arrErrName[key] + '-error').show();
              }
            }

            $('#suggest-main-error').html(mainMessage);
            $('#suggest-main-error').show();
            $('.suggest-buttons').removeAttr('disabled');
            $('#suggest-loading-image').hide();
            return;
          }
          else
          {
            $('#suggest-main-error').html('<%=lang.translate("errore_nella_richiesta").replaceAll("'", "\\\\'") %>');
            $('#suggest-main-error').show();
            $('.suggest-buttons').removeAttr('disabled');
            $('#suggest-loading-image').hide();
            return;
          }
        }
      }

    </script>
    <script src="<%=contextPath%>/js/library.js" type="text/javascript"></script>
</head>
<body>

<c:set var="lang"><%=locale.getLanguage() %></c:set>
<%
   String queryString = null;
   String nextBid = null;
   String prevBid = null;
   int recordCount = 0;
   int position = 0;
   int queryhash = 0;
   String currentBid = (String) request.getAttribute("bid");
   String titolo     = (String) request.getAttribute("titolo");
   String autore     = (String) request.getAttribute("autore");
   String annopub    = (String) request.getAttribute("annopub");
   if (opacuser != null)
   {
      SearchResult searchResult = opacuser.getSearchResult();
      if (searchResult != null)
      {
         queryString = searchResult.getQueryString();
         recordCount = searchResult.getRecordCount();
         queryhash = searchResult.getHashCode();
         if (currentBid != null)
         {
            position = searchResult.getPosition(currentBid);
            nextBid = searchResult.getNextBid(currentBid);
            if ((nextBid != null) && (queryhash > 0) && (position > 0))
               nextBid = nextBid + "/" + queryhash + "/" + (position+1);
            prevBid = searchResult.getPreviousBid(currentBid);
            if ((prevBid != null) && (queryhash > 0) && (position > 1))
               prevBid = prevBid + "/" + queryhash + "/" + (position-1);
         }
      }
   }
%>

<%@ include file="inc/testa.jsp" %>
<div id="page">

<%@ include file="inc/topmenu.jsp" %>

<div id="content">

<c:set var="requestURI"	value="fcsearch"/>

<c:set var="dom" value="${requestScope.record}"/>
<c:choose>
 <c:when test="${empty dom}">no record found !</c:when>
 <c:otherwise>
  <div id="notizia">
<%@ include file="inc/notizia-nav.jsp" %>
    <c:import url="xsl/notizia_${lang}.xsl"  var="xslt" charEncoding="UTF-8" />
    <x:transform xml="${requestScope.record}" xslt="${xslt}">
	<x:param name="contextpath"	value="<%=contextPath%>"/>
    </x:transform>
  </div><!--#notizia-->
 </c:otherwise>
</c:choose>

<div class="clearboth"></div>
<br/>
<br/>

  <div id="links">

   <div class="links-left">
      <a href="#" onclick="$.facebox({ ajax: '<%=contextPath%>/inc/suggest.jsp?bid=<%=currentBid %>' }); return false;" title="<%=lang.translate("aggiungi_suggerimento") %>" id="open-close-suggest">
        <img style="vertical-align: bottom;" src="<%=contextPath%>/img/add_suggest.png" alt="<%=lang.translate("aggiungi_suggerimento") %>" />
      </a>
      <a href="?fmt=xml" title="<%=lang.translate("scarica_record_formato_xml")%>"><img src="<%=contextPath%>/img/xml_download.png" alt="<%=lang.translate("scarica_record_formato_xml")%>"/></a>
      &nbsp;&nbsp;
      <%
        boolean bidInCart = (opacuser == null) ? false : opacuser.hasBidInCart(currentBid);
        String tit  = (titolo == null)  ? "" : titolo.replaceAll("'", "\\'");
        String aut  = (autore == null)  ? "" : autore.replaceAll("'", "\\'");
        String anno = (annopub == null) ? "" : annopub.replaceAll("'", "\\'");
      %>
      <a href="javascript://" <%if(bidInCart){%>style="display: none;"<%}%> id="add-<%=currentBid %>-to-cart" class="add-to-cart"
	onclick="addBidToCart('<%=currentBid %>',<%=tit%>,<%=aut%>,<%=anno%>); return false;
	title="<%=lang.translate("aggiungi_doc_al_carrello")%>"><img style="vertical-align: bottom;"
	src="<%=contextPath%>/img/add-book.png" alt="<%=lang.translate("aggiungi_doc_al_carrello") %>" /></a>

      <a href="javascript://" <%if(!bidInCart){%>style="display: none;"<%}%>
	id="remove-<%=currentBid%>-to-cart" class="remove-to-cart"
	onclick="removeBidFromCart('<%=currentBid %>'); return false;"
	title="<%=lang.translate("rimuovi_doc_dal_carrello")%>"><img style="vertical-align: bottom;"
	src="<%=contextPath%>/img/added-book.png" alt="<%=lang.translate("rimuovi_doc_dal_carrello")%>"/></a>
      <div id="msg-<%=currentBid %>-cart" class="msg-cart"></div>
   </div>

   <!-- AddThis Button BEGIN -->
   <div class="addthis_toolbox addthis_default_style links-right">
      <a class="addthis_button_facebook"
	addthis:url="http://opac.bncf.firenze.sbn.it/bid/<%=currentBid%>"></a>
      <a class="addthis_button_twitter"></a>
      <a class="addthis_button_google"></a>
      <a class="addthis_button_googlebuzz"></a>
      <a class="addthis_button_friendfeed"></a>
      <a class="addthis_button_email"></a>
      <span class="addthis_separator">|</span>
      <a href="http://www.addthis.com/bookmark.php?v=250&amp;pubid=xa-4d9aceb53098b460"
		class="addthis_button_compact">Share</a>
   </div>
   <script type="text/javascript"
	src="http://s7.addthis.com/js/250/addthis_widget.js#pubid=xa-4d9aceb53098b460"></script>
   <!-- AddThis Button END -->

   <div class="clearboth"></div>

  </div><!--#links-->

 </div><!--#content-->
<%@ include file="inc/footer.jsp" %>
 </div><!--#page-->
</body>
</html>
