<%@ page language="java" pageEncoding="UTF-8" import="java.util.ArrayList,bncf.opac.util.ListItem" %>
<%
  String[] fields = { "descrittore", "titolo", "autore", "soggetto" };
  String[] labels = { " " + lang.translate("descrittore_fc"), " " + lang.translate("titolo"), " " + lang.translate("autore_fc"), " " + lang.translate("soggetto_fc") };
%>
<%-- input box --%>
<div id="topbox">
 <div class="std-box-grey">
  <div class="std-title-grey">Cerca</div>
   <div id="browserform">
    <form action="<%=listurl%>/" method="GET">
     <input type="text" name="key" value="<%=(key==null)?"":key%>" size="24" title="<%=lang.translate("inserire_testo_da_cercare") %>"/> &nbsp;&nbsp;
     <select name="fld" title="<%=lang.translate("scegliere_canale") %>">
<%for (int k = 0 ; k < fields.length ; ++k ) {
       String selected = fields[k].equals(fld) ? " selected" : ""; %>
       <option value="<%=fields[k]%>"<%=selected%>><%=labels[k]%></option>
<%}%>
     </select>&nbsp;&nbsp;
     <input type="submit" value="cerca" title="<%=lang.translate("cerca") %>"/><br/>
     <input type="checkbox" name="ft" value="1" <%=("1".equals(ft))?"checked='yes'":""%> title="<%=lang.translate("cerca_per_parole_contenute") %>"><%=lang.translate("cerca_per_parole_contenute") %></input>
    </form>
   </div><!--#searchbase-->
  </div>
</div>
