<%@ page language="java" pageEncoding="UTF-8" %>
<%
  String sfld1 = request.getParameter("sf1");
  String sval1 = request.getParameter("sv1");

  String[] fields = { "keywords", "titolo_kw", "autore", "idn" };
  String[] labels = { lang.translate("parola_chiave") + "&nbsp", lang.translate("titolo"), lang.translate("autore"), lang.translate("bid") };
%>
<div id="topbox">
 <div class="std-box-grey">
  <div class="std-title-grey"><%=lang.translate("ricerca_libera") %></div>
   <div id="searchform">
    <form action="./fcsearch" method="GET" style="padding: 8px">
     <span><%=lang.translate("parole_chiave") %>&nbsp;&nbsp;<input type="text" name="sv1"
		id="sv1" value="<%=(sval1==null)?"":sval1%>" size="40" title="<%=lang.translate("inserisci_parole_chiave") %>"/>&nbsp;
	<input type="hidden" name="sf1" value="keywords"/>
<%--
     <select name="sf1" title="">
<%for (int k = 0 ; k < fields.length ; ++k ) {
       String selected = fields[k].equals(sfld1) ? " selected" : ""; %>
       <option value="<%=fields[k]%>"<%=selected%>><%=labels[k]%></option>
<%}%>
     </select>
--%>
     </span>
     <button type="submit" name="dosearch" value="true" style="color:#26d;font-weight:bold" title="<%=lang.translate("cerca") %>"><%=lang.translate("cerca") %></button>
    </form>
   </div><!--#searchbase-->
  </div>
</div>


