<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="inc/no-cache-headers.jsp" %>
<%@ include file="inc/setup.jsp" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.Iterator" %>
<%@ page import="bncf.opac.beans.Record" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" lang="en" xml:lang="en">
<head>
  <meta http-equiv="content-type" content="text/html; charset=UTF-8" />
  <title>SBN OPAC - <%=lang.translate("il_tuo_carrello") %></title>
  <link rel="stylesheet" href="css/base.css"    type="text/css" media="screen"/>
  <link rel="stylesheet" href="css/cart.css"    type="text/css" media="screen"/>
</head>
<body>

  <%@ include file="inc/testa.jsp" %>
  <%@ include file="inc/topmenu.jsp" %>

  <div id="main">
  
    <div id="cart">

    <%
      if ( opacuser != null )
      {
        HashMap carrello = (HashMap) opacuser.getCart();
        int ndoc = carrello.size();

        if ( ndoc > 0 ) 
        {
    %>

      <div id="topbox">
        <div class="std-box-grey">
          <div class="std-title-grey"><%=lang.translate("il_tuo_carrello") %></div>

          <p id="msg-ndoc"><i><%=lang.translate("numero_documenti_tuo_carrello") %>: <span id="ndoc"><%=ndoc %></span>.</i></p>
          <p id="export-cart">
            <%=lang.translate("esporta_documenti_carrello_in_formato") %>:
            <select id="cart-format" title="<%=lang.translate("scegli_formato") %>">
              <option value="txt"><%=lang.translate("txt") %></option>
              <option value="xml"><%=lang.translate("xml") %></option>
            </select>
            <button onclick="document.location='<%=contextPath %>/exportcart?fmt=' + $('#cart-format').val()" title="<%=lang.translate("esporta") %>"><%=lang.translate("esporta") %></button>
          </p>
        </div>
      </div>

      <hr noshade="1" size="1" />
      <table border="1" id="table-cart">
        <tbody>
          <tr>
            <th><%=lang.translate("titolo") %></th><th><%=lang.translate("autore") %></th><th><%=lang.translate("anno") %></th><th>&nbsp;</th>
          </tr>
    <%
          Iterator iterator = carrello.keySet().iterator();
          int i = 0;
          while ( iterator.hasNext() ) 
          { 
            Record record = (Record) carrello.get(iterator.next());
    %>
          <tr id="<%=record.getBid() %>">
            <td style="width: 80%; white-space: normal;">
              <a href="<%=contextPath %>/bid/<%=record.getBid() %>?cart=true" name="<%=record.getBid() %>" class="viewbid" title="<%=lang.translate("dettaglio_record") %>">
                <%=record.getTitle() %>
              </a>
            </td>
            <td>
              <% if ( record.getAuthor() != null ) { %><%=record.getAuthor() %><% } %>
            </td>
            <td>
              <% if ( record.getYear() != null ) { %><%=record.getYear() %><% } %>
            </td>
            <td>
              <strong><a href="#" onclick="removeBidFromCart('<%=record.getBid() %>'); return false;" title="<%=lang.translate("elimina") %>"><img src="<%=contextPath %>/img/trash.png" alt="<%=lang.translate("elimina") %>" /></a></strong>
            </td>
          </tr>
    <%
          }
    %>
        </tbody>
      </table>
    <%
        }
        else
        {
    %>
      <div id="topbox">
        <div class="std-box-grey">
          <div class="std-title-grey"><%=lang.translate("il_tuo_carrello") %></div>
          <p><%=lang.translate("non_hai_salvato_documento_carrello") %>.</p>
        </div>
      </div>
      <hr noshade="1" size="1" />
    <%
        }
      }
      else
      {
    %>
      <div id="topbox">
        <div class="std-box-grey">
          <div class="std-title-grey"><%=lang.translate("il_tuo_carrello") %></div>
          <p><%=lang.translate("non_hai_salvato_documento_carrello") %>.</p>
        </div>
      </div>
      <hr noshade="1" size="1" />
    <%
      }
    %>
    </div>
  
  </div><!--#main-->

  <script src="js/jquery.js"  type="text/javascript"></script>
  <script type="text/javascript">
    /* carrello temporaneo - in fase di completamento, le funzioni
       javascript andrebbero spostate in un file esterno e poi incluse */

    $(function() {
      $('.viewbid').each(
        function(ind, vl)
        {
          i = ind + 1;
          $(this).attr('id', 'n'+i);
        }
      );
     });

    function removeBidFromCart(bbid)
    {
      if ( bbid == null )
        return;

      $.ajax({
        type: 'GET',
        url: '<%=contextPath %>/removebidfromcart',
        data: 'bid=' + bbid,
        success: function(msg) {
          if ( msg == bbid )
          {
            $('#' + bbid).remove();
            var ndoc = $('#ndoc').html();
            ndoc = ndoc - 1;
            $('#ndoc').html(ndoc);
            if ( ndoc <= 0 )
            {
              $('#export-cart').hide();
              $('#table-cart').hide();
            }

            /* renumerazione id dei tag a per avanti / indietro */
            $('.viewbid').each(
              function(ind, vl)
              {
                i = ind + 1;
                $(this).attr('id', 'n'+i);
              }
            );

          }
          else if ( msg == 'error' )
          {
            $('#msg-ndoc').css('color', 'red');
            $('#msg-ndoc').html('<%=lang.translate("errore_ritenta") %>.');
          }
          else
          {
            $('#msg-ndoc').css('color', 'red');
            $('#msg-ndoc').html('<%=lang.translate("errore_ritenta") %>.');
          }
        }
      });
    }
  </script>

</body>
</html>


