<%@page language="java" contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@include file="no-cache-headers.jsp" %>
<%@include file="setup.jsp" %>
<% String currentBid = (String) request.getParameter("bid"); %>

  <div class="clearboth"></div>
  <div id="bid-suggest">

    <form id="bid-suggest-form" onsubmit="insertSuggestion(); return false;">

      <input name="bid" id="fld_bid" type="hidden" value="<%=currentBid %>" />

      <fieldset>

       <legend><%=lang.translate("aggiungi_suggerimento") %>&nbsp;&nbsp;(<%=lang.translate("tutti_campi_obb") %>)</legend>

       <div class="suggest-error" id="suggest-main-error"></div>

       <div class="clearboth"></div>

        <div class="left-label">
          <label for="fld_email"><%=lang.translate("email") %>*</label>
        </div>
        <div class="left">
          <input name="email" id="fld_email" type="text" maxlength="255" value="" title="<%=lang.translate("inserisci_email") %>" />
          <span class="suggest-error" id="suggest-fld_email-error"></span>
        </div>

        <div class="clearboth"></div>

        <div class="left-label">
          <label for="fld_testo"><%=lang.translate("testo") %>*</label>
        </div>
        <div class="left">
          <textarea name="testo" id="fld_testo" title="<%=lang.translate("inserisci_testo") %>"></textarea>
          <span class="suggest-error" id="suggest-fld_testo-error"></span>
        </div>

        <div class="clearboth"></div>

        <div class="left-label">
          <label for="fld_captcha"><%=lang.translate("codice_verifica") %>*</label>
        </div>
        <div class="left" style="width: 300px;">
          <input type="text" id="fld_captcha" name="captcha" maxlength="8" style="width: 80px;" title="<%=lang.translate("inserisci_captcha") %>"/>&nbsp;&nbsp;<img id="fld_captcha" src="<%=contextPath %>/inc/captchaimage.jsp?<%=(new java.sql.Timestamp((new java.util.Date()).getTime())) %>" alt="This Is CAPTCHA Image" style="vertical-align: middle;" />
          <span class="suggest-error" id="suggest-fld_captcha-error"></span>
          <div class="clearboth"></div>
          <span style="font-size: 10px;"><%=lang.translate("help_captcha") %></span>
        </div>

        <div class="clearboth"></div>

        <div class="buttons">
          <button type="submit" style="font-weight: bold; float: left;" class="suggest-buttons" title="<%=lang.translate("salva") %>"><%=lang.translate("salva") %></button>
          <button type="reset" onclick="$.facebox.close(); return false;" style="float: left;" class="suggest-buttons" title="<%=lang.translate("annulla") %>"><%=lang.translate("annulla") %></button>
          <div style="width: 30px; height: 30px; float: left; text-align: center;"><img src="<%=contextPath %>/img/ajaxload.gif" alt="loading" id="suggest-loading-image" style="display: none; vertical-align: middle;" alt="loading" /></div>
        <div class="clearboth"></div>
        </div>

      </fieldset>
    </form>
  </div>
