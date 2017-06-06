<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE solrresult [
<!ENTITY nbsp "&#xA0;">
<!ENTITY hr "<hr size='1' noshade='1'/>">
]>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<xsl:include href="xsl/utilities.xsl"/>
<xsl:include href="xsl/pager.xsl"/>


<!-- =============== response =============== -->

<xsl:template match="response">

<xsl:variable name="numRows" select="lst[@name='responseHeader']/lst[@name='params']/str[@name='rows']"/>
<xsl:variable name="totale" select="result/@numFound"/>

<xsl:apply-templates select="result">
    <xsl:with-param name="numRows" select="$numRows" />
</xsl:apply-templates>

<div id="filterbox">
 <div class="std-box-grey">
  <div class="std-title-grey">
	<xsl:call-template name="translate">
	<xsl:with-param name="section">traduzioni</xsl:with-param>
	<xsl:with-param name="sigla">la_tua_ricerca</xsl:with-param>
	</xsl:call-template>
	<!-- // opzione per la eliminazione di tutti filtri impostati //
	<span style="margin-left:30%">
		<a><xsl:attribute name="href">
		<xsl:call-template name="getURL">
			<xsl:with-param name="start" select="0"/>
			<xsl:with-param name="clear" select="all"/>
		</xsl:call-template>
		</xsl:attribute>
		<xsl:attribute name="title">elimina i filtri attivi</xsl:attribute>
		elimina
		</a>
	</span>
	-->
   </div>
   <xsl:apply-templates select="searchterms" />
   <xsl:apply-templates select="rangefilters" />
   <xsl:apply-templates select="filterterms" />
<!--
    <xsl:apply-templates select="lst[@name='facet_counts']" mode="fcontrol"/>
-->
 </div><!-- .std-box-grey -->

   <xsl:if test="$totale &gt; 1">
    <h4>
	 <xsl:call-template name="translate">
	 <xsl:with-param name="section">traduzioni</xsl:with-param>
	 <xsl:with-param name="sigla">filtra_ricerca_per</xsl:with-param>
	 </xsl:call-template>
    </h4>
    </xsl:if>
    <!-- colonna (sx)  delle facette -->
    <xsl:apply-templates select="lst[@name='facet_counts']">
    <xsl:with-param name="numFound" select="result/@numFound" />
    <xsl:with-param name="numRows" select="$numRows" />
    </xsl:apply-templates>
</div><!-- #filterbox -->
</xsl:template>



<!-- =============== search terms ===============
 !
 !   elenco dei termini della ricerca e dei filtri (cancellabili)
 !
 -->

<xsl:template match="searchterms">
  <xsl:apply-templates select="term[@field='keywords']"/>
  <xsl:apply-templates select="term[@field!='keywords']"/>
</xsl:template>

<xsl:template match="searchterms/term">
<xsl:if test="@text != '*'">
<p>
  <strong>
	<xsl:call-template name="translate">
	<xsl:with-param name="section">faccette</xsl:with-param>
	<xsl:with-param name="sigla" select="@field"/>
	</xsl:call-template>
  </strong>:<br/>
      <span style="padding-left: 3em">
		<xsl:call-template name="translate">
		<xsl:with-param name="section" select="@field" />
		<xsl:with-param name="sigla" select="@text"/>
		</xsl:call-template>
		<a><xsl:attribute name="href">
		<xsl:call-template name="getURL">
			<xsl:with-param name="start" select="0"/>
			<xsl:with-param name="clear"><xsl:value-of select="@field"/></xsl:with-param>
			<xsl:with-param name="clearvalue"><xsl:value-of select="@text"/></xsl:with-param>
		</xsl:call-template>
		</xsl:attribute>
		<xsl:attribute name="title">
   	 <xsl:call-template name="translate">
   	 <xsl:with-param name="section">traduzioni</xsl:with-param>
   	 <xsl:with-param name="sigla">elimina_il_filtro</xsl:with-param>
   	 </xsl:call-template>&nbsp;<xsl:value-of select="@field"/></xsl:attribute>[x]</a>
	</span>
</p>
</xsl:if>
</xsl:template>



<!-- =============== range queries ===============
 !
 !   elenco dei termini della ricerca e dei filtri per range (cancellabili)
 !
 -->

<xsl:template match="filterterms">
  <xsl:apply-templates select="filter"/>
</xsl:template>

<xsl:template match="filterterms/filter">
<p>
  <strong>
	<xsl:call-template name="translate">
	<xsl:with-param name="section">faccette</xsl:with-param>
	<xsl:with-param name="sigla" select="@field"/>
	</xsl:call-template>
  </strong>:<br/>
      <span style="padding-left: 3em">
		<xsl:call-template name="translate">
		<xsl:with-param name="section" select="@field" />
		<xsl:with-param name="sigla" select="@text"/>
		</xsl:call-template>
		<a><xsl:attribute name="href">
		<xsl:call-template name="getURL">
			<xsl:with-param name="start" select="0"/>
			<xsl:with-param name="clear"><xsl:value-of select="@field"/></xsl:with-param>
			<xsl:with-param name="clearvalue"><xsl:value-of select="@text"/></xsl:with-param>
		</xsl:call-template>
		</xsl:attribute>
		<xsl:attribute name="title">
   	 <xsl:call-template name="translate">
   	 <xsl:with-param name="section">traduzioni</xsl:with-param>
   	 <xsl:with-param name="sigla">elimina_il_filtro</xsl:with-param>
   	 </xsl:call-template>&nbsp;<xsl:value-of select="@field"/></xsl:attribute>[x]</a>
	</span>
</p>
</xsl:template>




<!-- =============== range queries ===============
 !
 !   elenco dei termini della ricerca e dei filtri per range (cancellabili)
 !
 -->

<xsl:template match="rangefilters">
  <xsl:apply-templates select="filter"/>
</xsl:template>

<xsl:template match="rangefilters/filter">
<p>
  <strong>
	<xsl:call-template name="translate">
	<xsl:with-param name="section">faccette</xsl:with-param>
	<xsl:with-param name="sigla" select="@field"/>
	</xsl:call-template>
  </strong>:<br/>
      <span style="padding-left: 3em">
		<xsl:call-template name="translate">
		<xsl:with-param name="section" select="@field" />
		<xsl:with-param name="sigla" select="@text"/>
		</xsl:call-template>
		<a><xsl:attribute name="href">
		<xsl:call-template name="getURL">
			<xsl:with-param name="start" select="0"/>
			<xsl:with-param name="clear"><xsl:value-of select="@field"/></xsl:with-param>
			<xsl:with-param name="clearvalue"><xsl:value-of select="@text"/></xsl:with-param>
		</xsl:call-template>
		</xsl:attribute>
		<xsl:attribute name="title">
   	<xsl:call-template name="translate">
   	<xsl:with-param name="section">traduzioni</xsl:with-param>
   	<xsl:with-param name="sigla">la_tua_ricerca</xsl:with-param>
   	</xsl:call-template>&nbsp;<xsl:value-of select="@field"/></xsl:attribute>[x]</a>
	</span>
</p>
</xsl:template>




<!-- =============== result list =============================
 !
 !   lista dei risultati con indicazione di doc. trovati
 -->

<xsl:template match="result">
 <xsl:param name="numRows" />
 <div id="resultcontainer">
  <div id="result">

    <!-- documenti trovati da-a di totale -->
    <xsl:call-template name="showPageCount">
	<xsl:with-param name="startRow"  select="@start"/>
	<xsl:with-param name="numRows"   select="$numRows"/>
	<xsl:with-param name="maxRows"   select="@numFound"/>
    </xsl:call-template>

    <xsl:call-template name="showSort">
    </xsl:call-template>

	<br/>
	<br/>

    <hr noshade="1" size="1"/>

    <xsl:if test="@numFound = 0">
      <p>
	   <xsl:call-template name="translate">
	   <xsl:with-param name="section">traduzioni</xsl:with-param>
	   <xsl:with-param name="sigla">nessun_documento_trovato</xsl:with-param>
	   </xsl:call-template>.
      </p>
    </xsl:if>
    <xsl:if test="@numFound &gt; 0">
      <table border="1">
      <tr>
        <th>
   	   <xsl:call-template name="translate">
   	   <xsl:with-param name="section">traduzioni</xsl:with-param>
   	   <xsl:with-param name="sigla">titolo</xsl:with-param>
   	   </xsl:call-template>
        </th>
        <th>
   	   <xsl:call-template name="translate">
   	   <xsl:with-param name="section">traduzioni</xsl:with-param>
   	   <xsl:with-param name="sigla">autore</xsl:with-param>
   	   </xsl:call-template>
        </th>
        <th>
   	   <xsl:call-template name="translate">
   	   <xsl:with-param name="section">traduzioni</xsl:with-param>
   	   <xsl:with-param name="sigla">anno</xsl:with-param>
   	   </xsl:call-template>
        </th>
        <th>
   	   <xsl:call-template name="translate">
   	   <xsl:with-param name="section">traduzioni</xsl:with-param>
   	   <xsl:with-param name="sigla">tipologia</xsl:with-param>
   	   </xsl:call-template>
        </th>
      </tr>
      <xsl:apply-templates select="doc"/>
      </table>
    </xsl:if>
    <hr noshade="1" size="1"/>

    <xsl:apply-templates select="../didyoumean"/>

    <!-- pager -->
    <xsl:call-template name="pager">
	<xsl:with-param name="startRow" select="@start"/>
	<xsl:with-param name="numRows" select="$numRows"/>
	<xsl:with-param name="maxRows" select="@numFound"/>
	<xsl:with-param name="pageRange" select="17"/>
    </xsl:call-template>

  </div><!--#result-->
 </div><!-- #resultcontainer -->
</xsl:template>

<!-- ======================= Didyoumean =========================================
 !
 !   Did you mean - vocabolario proposto
 -->
<xsl:template match="/response/didyoumean">
    <div id="didyoumean">
    <strong>
    <xsl:call-template name="translate">
    <xsl:with-param name="section">traduzioni</xsl:with-param>
    <xsl:with-param name="sigla">forse_cercavi</xsl:with-param>
    </xsl:call-template>:</strong>&nbsp;&nbsp;
    <xsl:apply-templates select="term"/>
    </div>
</xsl:template>

<xsl:template match="/response/didyoumean/term">
    <a>
      <xsl:attribute name="title">
      <xsl:call-template name="translate">
      <xsl:with-param name="section">traduzioni</xsl:with-param>
      <xsl:with-param name="sigla">forse_cercavi</xsl:with-param>
      </xsl:call-template>&nbsp;<xsl:value-of select="text()" />
      </xsl:attribute>
      <xsl:attribute name="style">font-weight: bold; font-size: 1.2em;</xsl:attribute>
      <xsl:attribute name="href">fcsearch?sf1=keywords&amp;sv1=<xsl:value-of select="text()" />&amp;start=0</xsl:attribute>
      <xsl:value-of select="text()" />
    </a><xsl:if test="position()!=last()">,&nbsp;</xsl:if>
</xsl:template>

<!-- ======================= Documenti trovati =========================================
 !
 !   Documenti trovati: 'da' - 'a' di 'totale'
 -->
<xsl:template name="showPageCount">
 <xsl:param name="startRow"/>
 <xsl:param name="numRows"/>
 <xsl:param name="maxRows"/>
 <xsl:variable name="end" select="$startRow + $numRows"/>
 <xsl:variable name="endRow">
  <xsl:choose>
   <xsl:when test="$end &gt; $maxRows"><xsl:value-of select="$maxRows"/></xsl:when>
   <xsl:otherwise><xsl:value-of select="$end"/></xsl:otherwise>
  </xsl:choose>
 </xsl:variable>
    <xsl:call-template name="translate">
    <xsl:with-param name="section">traduzioni</xsl:with-param>
    <xsl:with-param name="sigla">documenti_trovati</xsl:with-param>
    </xsl:call-template>:&nbsp;&nbsp;<xsl:if test="$maxRows &gt; 0"><strong><span id="startrow"><xsl:value-of select="$startRow+1"/></span>&nbsp;-&nbsp;<span id="endrow"><xsl:value-of select="$endRow"/></span></strong>&nbsp;&nbsp;di&nbsp;&nbsp;</xsl:if><strong><span id="maxrows"><xsl:value-of select="$maxRows"/></span></strong>
</xsl:template>



<!-- ======================= Ordinamento =========================================
 !
 !   Ordina per: <select> o <a> (se con javascript o senza)
 -->
<xsl:template name="showSort">
  <span class="JSScript" style="margin-left: 30px;">
    <xsl:call-template name="translate"><xsl:with-param name="section">traduzioni</xsl:with-param><xsl:with-param name="sigla">ordina_per</xsl:with-param></xsl:call-template>
    <xsl:text> </xsl:text>
    <select>
      <xsl:attribute name="title"><xsl:call-template name="translate"><xsl:with-param name="section">traduzioni</xsl:with-param><xsl:with-param name="sigla">scegli_ordinamento</xsl:with-param></xsl:call-template></xsl:attribute>
      <xsl:attribute name="onchange">document.location='<xsl:call-template name="getURL"><xsl:with-param name="clearsort">1</xsl:with-param></xsl:call-template>&amp;sort='+this.value;</xsl:attribute>
      <option value="null"><xsl:if test="$param.sort='' or $param.sort='null'"><xsl:attribute name="selected">selected</xsl:attribute></xsl:if>
        <xsl:call-template name="translate"><xsl:with-param name="section">traduzioni</xsl:with-param><xsl:with-param name="sigla">ord_rilevanza</xsl:with-param></xsl:call-template>
      </option>
      <option value="data"><xsl:if test="$param.sort='data'"><xsl:attribute name="selected">selected</xsl:attribute></xsl:if>
        <xsl:call-template name="translate"><xsl:with-param name="section">traduzioni</xsl:with-param><xsl:with-param name="sigla">ord_anno_decrescente</xsl:with-param></xsl:call-template>
      </option>
      <option value="autore"><xsl:if test="$param.sort='autore'"><xsl:attribute name="selected">selected</xsl:attribute></xsl:if>
        <xsl:call-template name="translate"><xsl:with-param name="section">traduzioni</xsl:with-param><xsl:with-param name="sigla">ord_autore</xsl:with-param></xsl:call-template>
      </option>
      <option value="titolo"><xsl:if test="$param.sort='titolo'"><xsl:attribute name="selected">selected</xsl:attribute></xsl:if>
        <xsl:call-template name="translate"><xsl:with-param name="section">traduzioni</xsl:with-param><xsl:with-param name="sigla">ord_titolo</xsl:with-param></xsl:call-template>
      </option>
    </select>
  </span>
  <span class="noJSScript" style="margin-left: 30px;">
    <xsl:call-template name="translate"><xsl:with-param name="section">traduzioni</xsl:with-param><xsl:with-param name="sigla">ordina_per</xsl:with-param></xsl:call-template>
      &nbsp;<strong>|</strong>&nbsp;
      <xsl:if test="$param.sort!='' and $param.sort!='null'">
      <a>
        <xsl:attribute name="href"><xsl:call-template name="getURL"><xsl:with-param name="clearsort">1</xsl:with-param></xsl:call-template>&amp;sort=null</xsl:attribute>
        <xsl:attribute name="title"><xsl:call-template name="translate"><xsl:with-param name="section">traduzioni</xsl:with-param><xsl:with-param name="sigla">ord_rilevanza</xsl:with-param></xsl:call-template></xsl:attribute>
        <xsl:call-template name="translate"><xsl:with-param name="section">traduzioni</xsl:with-param><xsl:with-param name="sigla">ord_rilevanza</xsl:with-param></xsl:call-template>
      </a>
      </xsl:if>
      <xsl:if test="$param.sort='' or $param.sort='null'">
         <strong><xsl:call-template name="translate"><xsl:with-param name="section">traduzioni</xsl:with-param><xsl:with-param name="sigla">ord_rilevanza</xsl:with-param></xsl:call-template></strong>
      </xsl:if>
      &nbsp;<strong>|</strong>&nbsp;
      <xsl:if test="$param.sort!='data'">
      <a>
        <xsl:attribute name="href"><xsl:call-template name="getURL"><xsl:with-param name="clearsort">1</xsl:with-param></xsl:call-template>&amp;sort=data</xsl:attribute>
        <xsl:attribute name="title"><xsl:call-template name="translate"><xsl:with-param name="section">traduzioni</xsl:with-param><xsl:with-param name="sigla">ord_anno_decrescente</xsl:with-param></xsl:call-template></xsl:attribute>
        <xsl:call-template name="translate"><xsl:with-param name="section">traduzioni</xsl:with-param><xsl:with-param name="sigla">ord_anno_decrescente</xsl:with-param></xsl:call-template>
      </a>
      </xsl:if>
      <xsl:if test="$param.sort='data'">
         <strong><xsl:call-template name="translate"><xsl:with-param name="section">traduzioni</xsl:with-param><xsl:with-param name="sigla">ord_anno_decrescente</xsl:with-param></xsl:call-template></strong>
      </xsl:if>
      &nbsp;<strong>|</strong>&nbsp;
      <xsl:if test="$param.sort!='autore'">
      <a>
        <xsl:attribute name="href"><xsl:call-template name="getURL"><xsl:with-param name="clearsort">1</xsl:with-param></xsl:call-template>&amp;sort=autore</xsl:attribute>
        <xsl:attribute name="title"><xsl:call-template name="translate"><xsl:with-param name="section">traduzioni</xsl:with-param><xsl:with-param name="sigla">ord_autore</xsl:with-param></xsl:call-template></xsl:attribute>
        <xsl:call-template name="translate"><xsl:with-param name="section">traduzioni</xsl:with-param><xsl:with-param name="sigla">ord_autore</xsl:with-param></xsl:call-template>
      </a>
      </xsl:if>
      <xsl:if test="$param.sort='autore'">
         <strong><xsl:call-template name="translate"><xsl:with-param name="section">traduzioni</xsl:with-param><xsl:with-param name="sigla">ord_autore</xsl:with-param></xsl:call-template></strong>
      </xsl:if>
      &nbsp;<strong>|</strong>&nbsp;
      <xsl:if test="$param.sort!='titolo'">
      <a>
        <xsl:attribute name="href"><xsl:call-template name="getURL"><xsl:with-param name="clearsort">1</xsl:with-param></xsl:call-template>&amp;sort=titolo</xsl:attribute>
        <xsl:attribute name="title"><xsl:call-template name="translate"><xsl:with-param name="section">traduzioni</xsl:with-param><xsl:with-param name="sigla">ord_titolo</xsl:with-param></xsl:call-template></xsl:attribute>
        <xsl:call-template name="translate"><xsl:with-param name="section">traduzioni</xsl:with-param><xsl:with-param name="sigla">ord_titolo</xsl:with-param></xsl:call-template>
      </a>
      </xsl:if>
      <xsl:if test="$param.sort='titolo'">
         <strong><xsl:call-template name="translate"><xsl:with-param name="section">traduzioni</xsl:with-param><xsl:with-param name="sigla">ord_titolo</xsl:with-param></xsl:call-template></strong>
      </xsl:if>
      &nbsp;<strong>|</strong>&nbsp;
  </span>
</xsl:template>


<!-- ======================= doc =========================================
 !
 !    estrazione dati da ogni documento contenuto nel risultato 
 !    da inserire nella tabella principale
 -->
<xsl:template match="doc">
	<xsl:variable name="idn" select="str[@name='idn']"/>

	<xsl:variable name="pathinfo"><xsl:value-of select="$idn"/><xsl:if test="$param.queryhash!=0">/<xsl:value-of select="$param.queryhash"/></xsl:if>/<xsl:value-of select="/response/result/@start + position()"/></xsl:variable>

 	<xsl:variable name="bidlink"><xsl:call-template name="getURL">
	  <xsl:with-param name="uri"><xsl:value-of select="$param.contextPath"/>/bid/<xsl:value-of select="$pathinfo"/></xsl:with-param>
	  <xsl:with-param name="start"><xsl:value-of select="/response/result/@start"/></xsl:with-param>
		</xsl:call-template>
	</xsl:variable>
      <xsl:variable name="bidlinkspc">
        <xsl:call-template name="escapeURLspace"><xsl:with-param name="string"><xsl:value-of select="$bidlink"/></xsl:with-param></xsl:call-template>
      </xsl:variable>
      <xsl:variable name="bidlinkjs">
        <xsl:call-template name="escapeApostropheJs"><xsl:with-param name="string"><xsl:value-of select="$bidlinkspc"/></xsl:with-param></xsl:call-template>
      </xsl:variable>
<tr class="norm" onMouseOver="this.className='high'" onMouseOut="this.className='norm'">
 <td style="width:240px;">
	<a><xsl:attribute name="title"><xsl:call-template name="translate"><xsl:with-param name="section">traduzioni</xsl:with-param><xsl:with-param name="sigla">vai_doc</xsl:with-param></xsl:call-template></xsl:attribute>
	<xsl:attribute name="href"><xsl:value-of select="$bidlinkspc"/></xsl:attribute>
<!--
        <xsl:attribute name="onclick">openDetail('<xsl:value-of select="$bidlinkjs"/>','<xsl:value-of select="position()" />'); return false;</xsl:attribute>
-->
        <xsl:attribute name="id">n<xsl:value-of select="position()" /></xsl:attribute>
        <xsl:attribute name="class">viewbid</xsl:attribute>
        <xsl:attribute name="name"><xsl:value-of select="$idn"/></xsl:attribute>
	<xsl:call-template name="substDelim">
		<xsl:with-param name="string" select="str[@name='titolo_dp']"/>
	</xsl:call-template>
	</a><br/>
 </td>
 <td class="med-col-wrap"><xsl:value-of select="str[@name='autore_dp']"/></td>
 <td class="min-col-nowrap"><xsl:value-of select="int[@name='anno1']"/></td>
 <td class="min-col-nowrap small-font"><xsl:apply-templates select="arr[@name='categoria']/str" /></td>
</tr>
</xsl:template>


<!-- ======================= doc =========================================
 !
 !    estrazione dati da ogni documento contenuto nel risultato 
 !    senza formattazione per la tabella
 -->
<xsl:template match="docNoTable">
	<p>
        <a href="#" title="">
	<xsl:call-template name="substDelim">
		<xsl:with-param name="string" select="str[@name='titolo_dp']"/>
	</xsl:call-template>
	</a><br/>
	<xsl:if test="str[@name='autore_dp'] !=''"><xsl:value-of select="str[@name='autore_dp']"/><br/></xsl:if>
	<xsl:value-of select="str[@name='idn']"/>&nbsp;
        </p>
</xsl:template>



<!-- ====================== display facets =======================
 !
 !   Visualizzazine delle facette (nella colonna a sinistra)
 -->

<xsl:template match="lst[@name='facet_counts']">
<xsl:param name="numFound" />
<xsl:param name="numRows" />
<xsl:apply-templates select="lst[@name='facet_fields']">
    <xsl:with-param name="numFound" select="$numFound"/>
    <xsl:with-param name="numRows" select="$numRows"/>
</xsl:apply-templates>
<!--
<xsl:apply-templates select="lst[@name='facet_queries']">
    <xsl:with-param name="numFound" select="$numFound"/>
    <xsl:with-param name="numRows" select="$numRows"/>
    <xsl:with-param name="name" select="'anno1'"/>
</xsl:apply-templates>
-->
</xsl:template>

<!-- =============== sequenza facet fields ===============
 !
 !   Questo template (facet_fields) definisce
 !   quale faccette visualizzare e in quale ordine.
 -->

<xsl:template match="lst[@name='facet_fields']">
  <xsl:param name="numFound" />
  <xsl:param name="numRows" />
  <xsl:if test="$numFound &gt; 1">
      <xsl:apply-templates select="lst[@name='biblioteca_fc']" />
  </xsl:if>
  <xsl:if test="$numFound &gt; ($numRows)">
      <xsl:apply-templates select="lst[@name='categoria_fc']" />
      <xsl:apply-templates select="lst[@name='lingua_fc']" />
  </xsl:if>
  <xsl:if test="$numFound &gt; 1">
      <xsl:apply-templates select="lst[@name='descrittore_fc']" />
  </xsl:if>
  <xsl:if test="$numFound &gt; ($numRows)">
      <xsl:apply-templates select="lst[@name='annopub_fc']" />
  </xsl:if>
  <xsl:if test="$numFound &gt; ($numRows * 2)">
      <xsl:apply-templates select="lst[@name='autore_fc']" />
      <xsl:apply-templates select="lst[@name='opera_fc']" />
  </xsl:if>
  <xsl:if test="$numFound &gt; 1">
      <xsl:apply-templates select="lst[@name='editore_fc']" />
  </xsl:if>
</xsl:template>

<!-- =============== Gruppo facetta ===============
 !
 !   Trattamento della singola facetta (box)
 -->
<xsl:template match="lst[@name='facet_fields']/lst">
 <xsl:if test="count(int) > 0">
    <div class="std-box-grey">
	<!--non utilizzare la classe js-title-facets per altri div, e' riservata per uso javascript -->
	<div class="std-title-grey js-title-facets">
		<xsl:attribute name="id">title-<xsl:value-of select="@name" /></xsl:attribute>
		<xsl:call-template name="facet-label">
		<xsl:with-param name="sigla" select="@name"/>
		</xsl:call-template>
	</div>
	<!-- public visible facet name -->
	<xsl:variable name="facet">
		<xsl:call-template name="translate">
		<xsl:with-param name="section">showAllRev</xsl:with-param>
		<xsl:with-param name="sigla" select="$param.showAll"/>
		</xsl:call-template>
 	</xsl:variable>
	<!-- max display for facet box-->
	<xsl:variable name="maxdisplay">
	    <xsl:choose>
		<xsl:when test="$facet!=@name"><xsl:value-of select="$param.facetLimitMin"/></xsl:when>
		<xsl:otherwise><xsl:value-of select="$param.facetLimitMax"/></xsl:otherwise>
	    </xsl:choose>
 	</xsl:variable>

	<div><xsl:attribute name="id">container-<xsl:value-of select="@name" /></xsl:attribute>
	<xsl:choose>
	    <xsl:when test="@name = 'annopub_fc'">
		<xsl:apply-templates select="int[(text()&gt;0)]">
			<xsl:with-param name="maxdisplay">20</xsl:with-param>
			<xsl:sort select="@name"/>
		</xsl:apply-templates>
	    </xsl:when>
	    <xsl:otherwise>
		<xsl:apply-templates select="int[(text()&gt;0)]">
			<xsl:with-param name="maxdisplay" select="$maxdisplay"/>
		</xsl:apply-templates>
	</xsl:otherwise>
	</xsl:choose>
  </div>
</div>
</xsl:if>
</xsl:template>

<!-- =============== Termini della facetta ===============
 !
 !   Lista dei termini nel box della facetta
 -->
<xsl:template match="lst[@name='facet_fields']/lst/int">
 <xsl:param name="maxdisplay"/>

 <xsl:choose>
  <xsl:when test="position() &lt;= $maxdisplay">
	<p>
	<a><xsl:attribute name="href">
	<xsl:call-template name="getURL">
		<xsl:with-param name="filtername" select="../@name"/>
		<xsl:with-param name="filtervalue" select="@name"/>
		<xsl:with-param name="start" select="0"/>
	</xsl:call-template>
	</xsl:attribute>
	<xsl:call-template name="translate">
		<xsl:with-param name="section" select="../@name"/>
		<xsl:with-param name="sigla" select="@name"/>
	</xsl:call-template>
	</a>&nbsp;&nbsp;<span class="graynum">(<xsl:value-of select="."/>)</span><br/>
	</p>
  </xsl:when>
  <xsl:when test="position() = $maxdisplay+1">
  <p style="text-align: right;">
   <a>
    <xsl:attribute name="href">
    <xsl:call-template name="getURL">
	  <xsl:with-param name="showAll">
    	<xsl:call-template name="translate">
    		<xsl:with-param name="section">showAll</xsl:with-param>
    		<xsl:with-param name="sigla" select="../@name"/>
    	</xsl:call-template>
    </xsl:with-param>
    </xsl:call-template>
    </xsl:attribute>
    	<xsl:call-template name="translate">
    		<xsl:with-param name="section">traduzioni</xsl:with-param>
    		<xsl:with-param name="sigla">mostra_tutti</xsl:with-param>
    	</xsl:call-template></a>
  </p>
  </xsl:when>
 </xsl:choose>
</xsl:template>


<!-- =============== facet queries ===============
 !
 !   Questo template (facet_queries) definisce
 !   quale faccette visualizzare e in quale ordine.
 -->
<xsl:template match="lst[@name='facet_queries']">
 <xsl:param name="numFound"/>
 <xsl:param name="numRows"/>
 <xsl:param name="name"/>

 <xsl:variable name="querylabel"><xsl:value-of select="$name"/>:</xsl:variable>

  <div class="std-box-grey">
   <div class="std-title-grey js-title-facets">
	<xsl:attribute name="id">title-<xsl:value-of select="$name"/></xsl:attribute>
	<xsl:call-template name="facet-label">
	<xsl:with-param name="sigla" select="$name"/>
	</xsl:call-template>
   </div>
  <div><xsl:attribute name="id">container-<xsl:value-of select="@name"/></xsl:attribute>
       <xsl:apply-templates select="int[starts-with(@name,$querylabel) and (text() &gt; 0)]" />
  </div>
</div>
 <xsl:if test="$numFound &gt; 0">
</xsl:if>
</xsl:template>


<!-- =============== facet query - riga  =============== -->
<xsl:template match="lst[@name='facet_queries']/int[@name!='']">
  <xsl:value-of select="substring-after(@name,':')"/> (<xsl:value-of select="."/>)<br/>
</xsl:template>


<!--
 <xsl:value-of select="$uri"/><xsl:text>?</xsl:text>
 <xsl:choose>
  <xsl:when test="$start!=''">start=<xsl:value-of select="$start"/></xsl:when>
  <xsl:otherwise>start=<xsl:value-of select="/response/result/@start"/></xsl:otherwise>
 </xsl:choose>
-->


<!-- =============== getURL =============== -->

<xsl:template name="getURL">
 <xsl:param name="uri" select="$requestURI"/>
 <xsl:param name="start"      select="0" />
 <xsl:param name="clear"      select="0" />
 <xsl:param name="clearvalue" select="0" />
 <xsl:param name="filtername" />
 <xsl:param name="filtervalue"/>
 <xsl:param name="showAll"    />
 <xsl:param name="clearsort" select="0" />

 <xsl:value-of select="$uri"/>
 <xsl:if test="$start &gt; 0"><xsl:text>/</xsl:text><xsl:value-of select="$start"/></xsl:if>
 <xsl:text>?</xsl:text>

 <xsl:if test="$clear!='all'">

   <xsl:variable name="keywords"><xsl:apply-templates select="/response/searchterms/term[@field='keywords']/@text"/></xsl:variable>

   <xsl:for-each select="/response/searchterms/term[not(($clear=@field) and ($clearvalue=@text))]">
<!--
   <xsl:for-each select="/response/searchterms/term">
    <xsl:if test="not(($clear=@field) and ($clearvalue=@text))">
-->
     <xsl:if test="position() > 1">&amp;</xsl:if>
     <xsl:choose>
      <xsl:when test="@sparam">
       <xsl:if test="@text != '*'">
        <xsl:text>sf</xsl:text><xsl:value-of select="@sparam" />=<xsl:value-of select="@field"/>
        <xsl:text>&amp;sv</xsl:text><xsl:value-of select="@sparam" />=<xsl:value-of select="@text"/>
       </xsl:if>
      </xsl:when>
      <xsl:otherwise>
       <xsl:text></xsl:text><xsl:value-of select="@field"/>=<xsl:value-of select="@text"/>
      </xsl:otherwise>
     </xsl:choose>
<!--
    </xsl:if>
-->

   </xsl:for-each>

   <xsl:for-each select="/response/filterterms/filter">
      <xsl:if test="not(($clear=@field) and ($clearvalue=@text))">
            <xsl:text>&amp;</xsl:text><xsl:value-of select="@field"/>=<xsl:value-of select="@text"/>
      </xsl:if>
   </xsl:for-each>

   <xsl:for-each select="/response/rangefilters/filter">
      <xsl:if test="not(($clear=@field) and ($clearvalue=@text))">
         <xsl:if test="@from != ''">
            <xsl:text>&amp;</xsl:text><xsl:value-of select="@field"/>_from=<xsl:value-of select="@from"/>
         </xsl:if>
         <xsl:if test="@to != ''">
            <xsl:text>&amp;</xsl:text><xsl:value-of select="@field"/>_to=<xsl:value-of select="@to"/>
         </xsl:if>
      </xsl:if>
   </xsl:for-each>

   <xsl:if test="($filtername!='') and ($filtervalue != '') and ($filtervalue != $clear)">
        <xsl:variable name="fval">
            <xsl:choose>
            <xsl:when test="$filtername='descrittore_fc'">"<xsl:value-of select="$filtervalue"/>"</xsl:when>
            <xsl:when test="$filtername='autore_fc'">"<xsl:value-of select="$filtervalue"/>"</xsl:when>
            <xsl:when test="$filtername='opera_fc'">"<xsl:value-of select="$filtervalue"/>"</xsl:when>
            <xsl:when test="$filtername='annopub_fc'">"<xsl:value-of select="$filtervalue"/>"</xsl:when>
            <xsl:otherwise><xsl:value-of select="$filtervalue"/></xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:text>&amp;</xsl:text><xsl:value-of select="$filtername"/>=<xsl:value-of select="$fval"/>
   </xsl:if>

   <xsl:if test="$showAll!=''">&amp;exp=<xsl:value-of select="$showAll" /></xsl:if>
   <xsl:if test="$clearsort!=1 and $param.sort!=''">&amp;sort=<xsl:value-of select="$param.sort" /></xsl:if>

 </xsl:if>

</xsl:template>



<!-- utili -->


<xsl:template match="arr[@name='categoria']/str">
<xsl:if test="text() !=''">
<xsl:call-template name="translate">
	<xsl:with-param name="section">categoria_fc</xsl:with-param>
	<xsl:with-param name="sigla"><xsl:value-of select="text()"/></xsl:with-param>
</xsl:call-template><br />
</xsl:if>
</xsl:template>



<xsl:template name="facet-label">
 <xsl:param name="sigla"/>
 <xsl:call-template name="translate"><xsl:with-param name="section">faccette</xsl:with-param><xsl:with-param name="sigla" select="$sigla"/></xsl:call-template>
</xsl:template>




</xsl:stylesheet>    
