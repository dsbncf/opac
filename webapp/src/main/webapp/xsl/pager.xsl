<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<!-- ===================== pager ===================== -->

<xsl:template name="pager">
 <xsl:param name="startRow"/>
 <xsl:param name="numRows"/>
 <xsl:param name="maxRows"/>
 <xsl:param name="pageRange"/>

 <xsl:variable name="currentPage" select="floor($startRow div $numRows) + 1"/>

 <xsl:variable name="currentPageRange">
  <xsl:choose>
   <xsl:when test="$currentPage &lt;= 999"><xsl:value-of select="$pageRange" /></xsl:when>
   <xsl:when test="($currentPage &gt; 999) and ($currentPage &lt;= 9999)">15</xsl:when>
   <xsl:when test="$currentPage &gt; 9999">11</xsl:when>
  </xsl:choose>
 </xsl:variable>

 <xsl:variable name="halfRange"	select="floor($currentPageRange div 2)"/>

 <xsl:variable name="maxPage">
  <xsl:choose>
   <xsl:when test="($maxRows mod $numRows) = 0"><xsl:value-of select="$maxRows div $numRows"/>
   </xsl:when>
   <xsl:otherwise><xsl:value-of select="floor($maxRows div $numRows) + 1"/></xsl:otherwise>
  </xsl:choose>
 </xsl:variable>

<xsl:if test="$maxPage &gt; 1">
 <xsl:variable name="lpgs" select="$maxPage - $currentPageRange + 1"/>
 <xsl:variable name="lastpagestart">
  <xsl:choose>
  <xsl:when test="$lpgs &lt; 1">1</xsl:when>
  <xsl:otherwise><xsl:value-of select="$lpgs"/></xsl:otherwise>
  </xsl:choose>
 </xsl:variable>

 <xsl:variable name="firstPage">
  <xsl:choose>
    <xsl:when test="$currentPage &gt; $lastpagestart"><xsl:value-of select="$lastpagestart"/></xsl:when>
    <xsl:otherwise>
     <xsl:choose>
      <xsl:when test="$currentPage &gt; $halfRange"><xsl:value-of select="$currentPage - $halfRange"/></xsl:when>
      <xsl:otherwise><xsl:value-of select="1"/></xsl:otherwise>
     </xsl:choose>
    </xsl:otherwise>
  </xsl:choose>
 </xsl:variable>

 <xsl:variable name="lpg" select="$firstPage + $currentPageRange - 1"/>
 <xsl:variable name="lastPage">
  <xsl:choose>
  <xsl:when test="$lpg &gt; $maxPage"><xsl:value-of select="$maxPage"/></xsl:when>
  <xsl:otherwise><xsl:value-of select="$lpg"/></xsl:otherwise>
  </xsl:choose>
 </xsl:variable>

<!--
	<br/>
	maxPage: <xsl:value-of select="$maxPage"/> <br/>
	currentPage: <xsl:value-of select="$currentPage"/> <br/>
	lastpagestart: <xsl:value-of select="$lastpagestart"/> <br/>
	firstPage: <xsl:value-of select="$firstPage"/> <br/>
	lastPage: <xsl:value-of select="$lastPage"/> <br/>
	lpg: <xsl:value-of select="$lpg"/> <br/>
	lpgs: <xsl:value-of select="$lpgs"/> <br/>
	currentPageRange: <xsl:value-of select="$currentPageRange"/> <br/>
	<br/>
-->

<div id="pager">
<br/>
	<!-- goto first page -->
	<xsl:if test="$currentPage &gt; 1">
	<a class="std-page"><xsl:attribute name="href">
	<xsl:call-template name="getURL">
		<xsl:with-param name="start" select="0"/>
	</xsl:call-template>
	</xsl:attribute>
	<xsl:attribute name="title">
	<xsl:call-template name="translate">
	<xsl:with-param name="section">traduzioni</xsl:with-param>
	<xsl:with-param name="sigla">vai_alla_prima_pagina</xsl:with-param>
	</xsl:call-template> (AccessKey: i)
  </xsl:attribute>
	<xsl:attribute name="accesskey">i</xsl:attribute>
   <img>
      <xsl:attribute name="src"><xsl:value-of select="$param.contextPath"/>/img/first.gif</xsl:attribute>
      <xsl:attribute name="alt">
   	<xsl:call-template name="translate">
   	<xsl:with-param name="section">traduzioni</xsl:with-param>
   	<xsl:with-param name="sigla">icona_vai_alla_prima_pagina</xsl:with-param>
   	</xsl:call-template>
      </xsl:attribute>
   </img></a>
	</xsl:if>

	<!-- goto previous page -->
	<xsl:if test="$currentPage &gt; 1">
	<a class="std-page" id="previous-page"><xsl:attribute name="href">
	<xsl:call-template name="getURL">
		<xsl:with-param name="start" select="$startRow - $numRows"/>
	</xsl:call-template>
	</xsl:attribute>
	<xsl:attribute name="title">
   	<xsl:call-template name="translate">
   	<xsl:with-param name="section">traduzioni</xsl:with-param>
   	<xsl:with-param name="sigla">vai_alla_pagina_precedente</xsl:with-param>
   	</xsl:call-template> (AccessKey: -)
  </xsl:attribute>
	<xsl:attribute name="accesskey">-</xsl:attribute>
   <img>
      <xsl:attribute name="src"><xsl:value-of select="$param.contextPath"/>/img/prev.gif</xsl:attribute>
      <xsl:attribute name="alt">
   	<xsl:call-template name="translate">
   	<xsl:with-param name="section">traduzioni</xsl:with-param>
   	<xsl:with-param name="sigla">icona_vai_alla_pagina_precedente</xsl:with-param>
   	</xsl:call-template>
      </xsl:attribute>
   </img></a>
	</xsl:if>

	<!-- page number links (recursive) -->
	<xsl:call-template name="pagerNums">
		<xsl:with-param name="firstPage" select="$firstPage"/>
		<xsl:with-param name="currentPage" select="$currentPage"/>
		<xsl:with-param name="position" select="$firstPage"/>
		<xsl:with-param name="lastPage" select="$lastPage"/>
		<xsl:with-param name="numRows" select="$numRows"/>
	</xsl:call-template>

	<!-- goto next page -->
	<xsl:if test="$currentPage &lt; $maxPage">
	<a class="std-page" id="next-page"><xsl:attribute name="href">
	<xsl:call-template name="getURL">
		<xsl:with-param name="start" select="$startRow + $numRows"/>
	</xsl:call-template>
	</xsl:attribute>
	<xsl:attribute name="title">
   	<xsl:call-template name="translate">
   	<xsl:with-param name="section">traduzioni</xsl:with-param>
   	<xsl:with-param name="sigla">vai_alla_pagina_successiva</xsl:with-param>
   	</xsl:call-template> (AccessKey: +)
  </xsl:attribute>
	<xsl:attribute name="accesskey">+</xsl:attribute>
   <img>
      <xsl:attribute name="src"><xsl:value-of select="$param.contextPath"/>/img/next.gif</xsl:attribute>
      <xsl:attribute name="alt">
   	<xsl:call-template name="translate">
   	<xsl:with-param name="section">traduzioni</xsl:with-param>
   	<xsl:with-param name="sigla">icona_vai_alla_pagina_successiva</xsl:with-param>
   	</xsl:call-template>
      </xsl:attribute>
   </img></a>
	</xsl:if>

	<!-- goto last page -->
	<xsl:if test="$currentPage &lt; $maxPage">
	<xsl:variable name="offsetLastPage" select="($maxPage - 1) * $numRows"/>
	<a class="std-page"><xsl:attribute name="href">
	<xsl:call-template name="getURL">
		<xsl:with-param name="start" select="$offsetLastPage"/>
	</xsl:call-template>
	</xsl:attribute>
	<xsl:attribute name="title">
   	<xsl:call-template name="translate">
   	<xsl:with-param name="section">traduzioni</xsl:with-param>
   	<xsl:with-param name="sigla">vai_all_ultima_pagina</xsl:with-param>
   	</xsl:call-template> (AccessKey: f)
   </xsl:attribute>
  <xsl:attribute name="accesskey">f</xsl:attribute>
   <img>
      <xsl:attribute name="src"><xsl:value-of select="$param.contextPath"/>/img/last.gif</xsl:attribute>
      <xsl:attribute name="alt">
   	<xsl:call-template name="translate">
   	<xsl:with-param name="section">traduzioni</xsl:with-param>
   	<xsl:with-param name="sigla">icona_vai_all_ultima_pagina</xsl:with-param>
   	</xsl:call-template>
      </xsl:attribute>
   </img></a>
	</xsl:if>
</div>
<div class="clearboth"></div>
</xsl:if>
</xsl:template>

<!-- pager: compone la lista delle pagine -->
<xsl:template name="pagerNums">
 <xsl:param name="firstPage"/>
 <xsl:param name="currentPage"/>
 <xsl:param name="position"/>
 <xsl:param name="lastPage"/>
 <xsl:param name="numRows"/>

 <xsl:if test="$position &lt;= $lastPage">
	<xsl:variable name="offset" select="($position - 1) * $numRows"/>

	<xsl:choose>
	  <xsl:when test="$currentPage = $position">
		<b class="std-page"><xsl:value-of select="$position"/></b>
	  </xsl:when>
	  <xsl:otherwise>
		<a class="std-page">
    <xsl:attribute name="title">
   	<xsl:call-template name="translate">
   	<xsl:with-param name="section">traduzioni</xsl:with-param>
   	<xsl:with-param name="sigla">pagina</xsl:with-param>
   	</xsl:call-template><xsl:text> </xsl:text><xsl:value-of select="$position"/>
    </xsl:attribute>
    <xsl:attribute name="href">
		<xsl:call-template name="getURL">
			<xsl:with-param name="start" select="$offset"/>
		</xsl:call-template>
		</xsl:attribute>
		<xsl:value-of select="$position"/></a>
		
	  </xsl:otherwise>
	</xsl:choose>

	<xsl:call-template name="pagerNums">
		<xsl:with-param name="firstPage" select="$firstPage"/>
		<xsl:with-param name="currentPage" select="$currentPage"/>
		<xsl:with-param name="position" select="$position + 1"/>
		<xsl:with-param name="lastPage" select="$lastPage"/>
		<xsl:with-param name="numRows" select="$numRows"/>
	</xsl:call-template>
 </xsl:if>
</xsl:template>

</xsl:stylesheet>    
