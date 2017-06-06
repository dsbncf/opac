<%@ page language="java" pageEncoding="UTF-8" %>
<%!
   String getRequestParameter(HttpServletRequest req, String name, String value)
   {
     String s = req.getParameter(name);
     return (s == null) ? value : s;
   }
%>
<%
  String sfld1 = getRequestParameter(request,"sf1","autore_kw");
  String sfld2 = getRequestParameter(request,"sf2","titolo_kw");
  String sfld3 = getRequestParameter(request,"sf3","descrittore_kw");
  String sfld4 = getRequestParameter(request,"sf4","collana_kw");
  String sval1 = getRequestParameter(request,"sv1","");
  String sval2 = getRequestParameter(request,"sv2","");
  String sval3 = getRequestParameter(request,"sv3","");
  String sval4 = getRequestParameter(request,"sv4","");

  String anno1_to     = getRequestParameter(request,"anno1_to","");
  String anno1_from   = getRequestParameter(request,"anno1_from","");
  String dataagg_to   = getRequestParameter(request,"dataagg_to","");
  String dataagg_from = getRequestParameter(request,"dataagg_from","");

  String paese_fc      = getRequestParameter(request,"paese_fc","");
  // String natura_fc     = getRequestParameter(request,"natura_fc","");
  String tiposogg      = getRequestParameter(request,"tiposogg","");
  String categoria_fc  = getRequestParameter(request,"categoria_fc","");
  String lingua_fc     = getRequestParameter(request,"lingua_fc","");
  String deweyediz_fc  = getRequestParameter(request,"deweyediz_fc","");
  String biblioteca_fc = getRequestParameter(request,"biblioteca_fc","");


  String[] fields = {
		"autore_kw",
		"titolo_kw",
		"descrittore_kw",
		"collana_kw",
		"dewey_cod",
		"dewey_kw",
		"luogo_kw",
		"editore_kw",
		"identificatore_kw",
		"marca_kw",
		"collocazione_kw",
		"keywords",
		"bid",
		"vid",
		"cid",
		"inventario_kw"
		};
  String[] labels = {
		lang.translate("autore"),
		lang.translate("titolo"),
		lang.translate("soggetto"),
		lang.translate("collana"),
		lang.translate("classe_numero_cdd"),
		lang.translate("classe_parola_chiave"),
		lang.translate("luogo"),
		lang.translate("editore"),
		lang.translate("identificatori_standard"),
		lang.translate("marca"),
		lang.translate("collocazione"),
		lang.translate("parole_chiave"),
		lang.translate("identificativo_titolo"),
		lang.translate("identificativo_autore"),
		lang.translate("identificativo_soggetto"),
		lang.translate("inventario")
		};

  String[] edizioniDewey = { "22","21","20","19","18","17","16","15","14","13","12","11","1" };

  String[] siglaBib = { "CF", "MF", "ML", "RF", "AS", "FT", "FC", "IG" } ;
  String[] nomeBib  = {
			lang.translate("nazionale_centrale_firenze"),
			lang.translate("marucelliana_firenze"),
			lang.translate("medicea_laurenziana"),
			lang.translate("riccardiana"),
			lang.translate("dell_archivio_di_stato"),
			lang.translate("fondazione_turati_pertini"),
			lang.translate("del_conservatorio_luigi_cher"),
			lang.translate("attilio_mori_istituto_geo")
			};

  String[] siglaSogg = { "nsogi", "fir" };
  String[] nomeSogg  = {
			lang.translate("nuovo"),
			lang.translate("vecchio")
			};

  String[] siglaMat = { "CB", "SO", "CS", "CM",
			"CL", "DI", "DC", "GR",
			"LI", "MS", "RM", "SS",
			"SM", "AT", "PE", "CO",
			"ED", "EL", "MM", "TD",
			"AV", "AL"
			 } ;
  String[] nomeMat  = {
			lang.translate("categoria_fc.CB"),
			lang.translate("categoria_fc.SO"),
			lang.translate("categoria_fc.CS"),
			lang.translate("categoria_fc.CM"),
			lang.translate("categoria_fc.CL"),
			lang.translate("categoria_fc.DI"),
			lang.translate("categoria_fc.DC"),
			lang.translate("categoria_fc.GR"),
			lang.translate("categoria_fc.LI"),
			lang.translate("categoria_fc.MS"),
			lang.translate("categoria_fc.RM"),
			lang.translate("categoria_fc.SS"),
			lang.translate("categoria_fc.SM"),
			lang.translate("categoria_fc.AT"),
			lang.translate("categoria_fc.PE"),
			lang.translate("categoria_fc.CO.short"),
			lang.translate("categoria_fc.ED"),
			lang.translate("categoria_fc.EL"),
			lang.translate("categoria_fc.MM"),
			lang.translate("categoria_fc.TD"),
			lang.translate("categoria_fc.AV"),
			lang.translate("categoria_fc.AL")
			};

  String[] siglaLingua = {
			"ara", "arc", "arm", "bul", "cat", "che",
			"chi", "cop", "dan", "heb", "esp", "eth",
			"fin", "fre", "fro", "frm", "jpn", "grc",
			"gre", "eng", "enm", "ita", "lat", "lin",
			"lit", "nor", "dut", "per", "pol", "por",
			"pro", "roh", "rum", "rus", "san", "scc",
			"scr", "sla", "slo", "slv", "spa", "swe",
			"ger", "tib", "tur", "hun"
			};
  String[] nomeLingua  = {
			lang.translate("lingua_fc.ara"), lang.translate("lingua_fc.arc"), lang.translate("lingua_fc.arm"), lang.translate("lingua_fc.bul"),	lang.translate("lingua_fc.cat"), lang.translate("lingua_fc.che"),
			lang.translate("lingua_fc.chi"), lang.translate("lingua_fc.cop"), lang.translate("lingua_fc.dan"), lang.translate("lingua_fc.heb"),	lang.translate("lingua_fc.esp"), lang.translate("lingua_fc.eth"),
			lang.translate("lingua_fc.fin"), lang.translate("lingua_fc.fre"),	lang.translate("lingua_fc.fro"), lang.translate("lingua_fc.frm"),	lang.translate("lingua_fc.jpn"),	lang.translate("lingua_fc.grc"),
			lang.translate("lingua_fc.gre"), lang.translate("lingua_fc.eng"), lang.translate("lingua_fc.enm"),	lang.translate("lingua_fc.ita"), lang.translate("lingua_fc.lat"), lang.translate("lingua_fc.lin"),
			lang.translate("lingua_fc.lit"), lang.translate("lingua_fc.nor"), lang.translate("lingua_fc.dut"),	lang.translate("lingua_fc.per"), lang.translate("lingua_fc.pol"), lang.translate("lingua_fc.por"),
			lang.translate("lingua_fc.pro"),	lang.translate("lingua_fc.roh"), lang.translate("lingua_fc.rum"), lang.translate("lingua_fc.rus"), lang.translate("lingua_fc.san"), lang.translate("lingua_fc.scc"),
			lang.translate("lingua_fc.scr"), lang.translate("lingua_fc.sla"), lang.translate("lingua_fc.slo"), lang.translate("lingua_fc.slv"),	lang.translate("lingua_fc.spa"), lang.translate("lingua_fc.swe"),
			lang.translate("lingua_fc.ger"), lang.translate("lingua_fc.tib"), lang.translate("lingua_fc.tur"), lang.translate("lingua_fc.hun")
			};
  String[] siglaPaese = {
			"za", "al", "sa", "ar", "at", "be", "bo", "br",
			"bg", "ca", "cz", "cn", "co", "cr", "cu", "dk",
			"et", "fi", "fr", "de", "jp", "gr", "in", "ir",
			"ie", "il", "it", "yu", "li", "lu", "mg", "my",
			"mt", "ma", "mx", "mc", "ne", "ng", "no", "pe",
			"pl", "pt", "gb", "ro", "sm", "so", "es", "us",
			"se", "ch", "tr", "ua", "ru", "uy", "ve"
			};

  String[] nomePaese = {
			lang.translate("paese_fc.za"), lang.translate("paese_fc.al"), lang.translate("paese_fc.sa"), lang.translate("paese_fc.ar"), lang.translate("paese_fc.at"), lang.translate("paese_fc.be"), lang.translate("paese_fc.bo"), lang.translate("paese_fc.br"),
			lang.translate("paese_fc.bg"), lang.translate("paese_fc.ca"), lang.translate("paese_fc.cz"), lang.translate("paese_fc.cn"), lang.translate("paese_fc.co"), lang.translate("paese_fc.cr"), lang.translate("paese_fc.cu"), lang.translate("paese_fc.dk"),
			lang.translate("paese_fc.et"), lang.translate("paese_fc.fi"), lang.translate("paese_fc.fr"), lang.translate("paese_fc.de"), lang.translate("paese_fc.jp"), lang.translate("paese_fc.gr"), lang.translate("paese_fc.in"), lang.translate("paese_fc.ir"),
			lang.translate("paese_fc.ie"), lang.translate("paese_fc.il"), lang.translate("paese_fc.it"), lang.translate("paese_fc.yu"), lang.translate("paese_fc.li"), lang.translate("paese_fc.lu"), lang.translate("paese_fc.mg"), lang.translate("paese_fc.my"),
			lang.translate("paese_fc.mt"), lang.translate("paese_fc.ma"), lang.translate("paese_fc.mx"), lang.translate("paese_fc.mc"), lang.translate("paese_fc.ne"), lang.translate("paese_fc.ng"), lang.translate("paese_fc.no"), lang.translate("paese_fc.pe"),
			lang.translate("paese_fc.pl"), lang.translate("paese_fc.pt"), lang.translate("paese_fc.gb"), lang.translate("paese_fc.ro"), lang.translate("paese_fc.sm"), lang.translate("paese_fc.so"), lang.translate("paese_fc.es"), lang.translate("paese_fc.us"),
			lang.translate("paese_fc.se"), lang.translate("paese_fc.ch"), lang.translate("paese_fc.tr"), lang.translate("paese_fc.ua"), lang.translate("paese_fc.ru"), lang.translate("paese_fc.uy"), lang.translate("paese_fc.ve")
			};
%>
<div id="topbox">
 <div class="std-box-grey" style="min-width: 950px;">

  <div class="std-title-grey"><%=lang.translate("ricerca_base_title") %></div>

<div style="width: 980px;">
  <form action="./fcsearchm" method="GET">

   <div class="searchform" style="float:left;">
     <span class="spacebottom">
     <select name="sf1" title="<%=lang.translate("seleziona_primo_canale_ricerca") %>">
<%for (int k = 0 ; k < fields.length ; ++k ) {
       String selected = fields[k].equals(sfld1) ? " selected=\"yes\"" : ""; %>
       <option value="<%=fields[k]%>"<%=selected%>><%=labels[k]%></option>
<%}%>
     </select>
     <input type="text" name="sv1" value="<%=(sval1==null)?"":sval1%>" title="<%=lang.translate("inserisci_parole_chiave") %>"/>
     </span>
<br/>
     <span class="spacebottom">
     <select name="sf2" title="<%=lang.translate("seleziona_secondo_canale_ricerca") %>">
<%for (int k = 0 ; k < fields.length ; ++k ) {
       String selected = fields[k].equals(sfld2) ? " selected=\"yes\"" : ""; %>
       <option value="<%=fields[k]%>"<%=selected%>><%=labels[k]%></option>
<%}%>
     </select>
     <input type="text" name="sv2" value="<%=(sval2==null)?"":sval2%>" title="<%=lang.translate("inserisci_parole_chiave") %>"/>
     </span>
<br/>
     <span class="spacebottom">
     <select name="sf3" title="<%=lang.translate("seleziona_terzo_canale_ricerca") %>">
<%for (int k = 0 ; k < fields.length ; ++k ) {
       String selected = fields[k].equals(sfld3) ? " selected=\"yes\"" : ""; %>
       <option value="<%=fields[k]%>"<%=selected%>><%=labels[k]%></option>
<%}%>
     </select>
     <input type="text" name="sv3" value="<%=(sval3==null)?"":sval3%>" title="<%=lang.translate("inserisci_parole_chiave") %>"/>
     </span>
<br/>
     <span class="spacebottom">
     <select name="sf4" title="<%=lang.translate("seleziona_quarto_canale_ricerca") %>">
<%for (int k = 0 ; k < fields.length ; ++k ) {
       String selected = fields[k].equals(sfld4) ? " selected=\"yes\"" : ""; %>
       <option value="<%=fields[k]%>"<%=selected%>><%=labels[k]%></option>
<%}%>
     </select>
     <input type="text" name="sv4" value="<%=(sval4==null)?"":sval4%>" title="<%=lang.translate("inserisci_parole_chiave") %>"/>
     </span>

     <div style="margin-top:0.2em;margin-right:2em;text-align:right">
      <button type="reset" name="canc" value="true" style="color:#26d;font-weight:bold" title="<%=lang.translate("cancella") %>"><%=lang.translate("cancella") %></button>
      <button type="submit" name="dosearch" value="true" style="color:#26d;font-weight:bold" title="<%=lang.translate("cerca") %>"><%=lang.translate("cerca") %></button>
     </div>

   </div><!--.searchform-->

<div class="searchform" style="float:left;">

<div style="background:#B0D0F0;">&nbsp;<%=lang.translate("filtri") %>:</div>
<table>

 <tr>
  <td class="label"><%=lang.translate("paese") %></td>
  <td class="input" style="width:150px">
       <select name="paese_fc" title="<%=lang.translate("scegli_paese_prov") %>">
      	<option value=""><%=lang.translate("tutti") %></option>
	<% for (int k = 0; k < siglaPaese.length ; k++)
           {   String sel = (siglaPaese[k].equals(paese_fc)) ? " selected=\"yes\"" : ""; %>
	<option value="<%=siglaPaese[k]%>"<%=sel%>><%=nomePaese[k]%></option>
	<% } %>

      </select>                                                                                 
  </td>
  <td class="label"><%=lang.translate("lingua") %></td>
  <td colspan="4" class="input">
       <select name="lingua_fc" title="<%=lang.translate("scegli_lingua") %>">
      	<option value=""><%=lang.translate("tutte") %></option>
	<% for (int k = 0; k < siglaLingua.length ; k++)
           {   String sel = (siglaLingua[k].equals(lingua_fc)) ? " selected=\"yes\"" : ""; %>
	<option value="<%=siglaLingua[k]%>"<%=sel%>><%=nomeLingua[k]%></option>
	<% } %>
       </select>                                                                                   
  </td>                                                                                          
 </tr>

 <tr>
  <td class="label"><%=lang.translate("tipologia") %></td>
  <td colspan="2" class="input">
      <select name="categoria_fc" title="<%=lang.translate("scegli_tipologia") %>">
      	<option value=""><%=lang.translate("tutti") %></option>
	<% for (int k = 0; k < siglaMat.length ; k++)
           {   String sel = (siglaMat[k].equals(categoria_fc)) ? " selected=\"yes\"" : ""; %>
	<option value="<%=siglaMat[k]%>"<%=sel%>><%=nomeMat[k]%></option>
	<% } %>
      </select>
  </td>

  <td class="label" style="width:7em;"><%=lang.translate("ediz_dewey") %></td>
  <td colspan="3" class="input">
     <select name="deweyediz_fc" title="<%=lang.translate("ediz_dewey") %>">
       <option value=""><%=lang.translate("tutte") %></option>
        <% for(String ed: edizioniDewey)
           {   String sel = (ed.equals(deweyediz_fc)) ? " selected=\"yes\"" : ""; %>
       <option value="<%=ed%>"<%=sel%>><%=ed%></option>
        <% } %>
     </select>
  </td>
 </tr>

 <tr>
  <td class="label"><%=lang.translate("pubblic") %></td>
  <td colspan="2" class="input" style="white-space: nowrap;">
       <label for="pda"><%=lang.translate("dall_anno") %></label>
       <input id="pda" name="anno1_from" value="<%=anno1_from%>" size="3" maxlength="4" type="text" 
              title="<%=lang.translate("scegli_dall_anno") %>" class="checknumeric" />
       <label for="paa">&nbsp;&nbsp;<%=lang.translate("all_anno") %></label>
       <input id="pda" name="anno1_to" value="<%=anno1_to%>" size="3" maxlength="4" type="text" 
              title="<%=lang.translate("scegli_all_anno") %>" class="checknumeric" />
   </td>

  <td class="label"><%=lang.translate("inserito_dal") %></td>
  <td colspan="3" class="input">
     <input id="insd" name="dataagg_from" value="<%=dataagg_from%>" size="10" maxlength="8" type="text"
            title="<%=lang.translate("scegli_dall_anno") %>" class="checknumeric" />
     <label for="insa">al</label>
     <input id="ina" name="dataagg_to" value="<%=dataagg_to%>" size="10" maxlength="8" type="text"
            title="<%=lang.translate("scegli_all_anno") %>" class="checknumeric" /> 
  </td>
 </tr>

 <tr>
  <td class="label"><%=lang.translate("biblioteca") %></td>
  <td colspan="3" class="input">
      <select name="biblioteca_fc" title="<%=lang.translate("scegli_biblioteca") %>">
	<option value=""><%=lang.translate("tutte") %></option>
	<% for (int k = 0; k < siglaBib.length ; k++)
           {  String sel = (siglaBib[k].equals(biblioteca_fc)) ? " selected=\"yes\"" : ""; %>
	<option value="<%=siglaBib[k]%>"<%=sel%>><%=nomeBib[k]%></option>
	<% } %>
     </select>
  </td>
  <td class="label"><%=lang.translate("soggettario") %></td>
  <td colspan="2" class="input">
      <select name="tiposogg" title="<%=lang.translate("scegli_soggettario") %>">
        <option value=""><%=lang.translate("tutti") %></option>
	<% for (int k = 0; k < siglaSogg.length ; k++)
           {   String sel = (siglaSogg[k].equals(tiposogg)) ? " selected=\"yes\"" : ""; %>
	<option value="<%=siglaSogg[k]%>"<%=sel%>><%=nomeSogg[k]%></option>
	<% } %>
      </select>
  </td>
 </tr>

</table>

 </div>

 <div style="clear:both;"></div>

</form>
</div><!--1024-->

  </div><!--#std-box-grey-->
</div><!--#topbox-->


