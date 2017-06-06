<?xml version="1.0" encoding="UTF-8"?>

<!DOCTYPE notizia [
<!ENTITY nbsp "&#xA0;">
<!ENTITY eacute "&#xE9;">
<!ENTITY egrave "&#xE8;">
<!ENTITY agrave "&#xE0;">
<!ENTITY separatore "<hr/>">
<!ENTITY br1 "<br/>">
<!ENTITY br2 "<br/><br/>">
]>
<xsl:stylesheet version="1.0"
	xmlns:marc="http://www.loc.gov/MARC21/slim"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:java_net="http://xml.apache.org/xalan/java/java.net"
	exclude-result-prefixes="marc java_net">

<xsl:output method="html" indent="yes" encoding="UTF-8"/>
	
<xsl:param name="contextpath"/>

<xsl:template match="/">
<xsl:apply-templates/>
</xsl:template>

<!--
<MServDoc>
  <ansfasc>
   <annata idannata="58116" anno="1997" kordi="L998405147" kanno="1997" kbibl="CF"
	ninvent="CF 5303365 CFGIOR     A 0          04974"
	posseduto="a.1997:v.1:n.2(1997:ott)-a.1997:v.1:n.3-4(1997:nov-dic),a.1998:v.1:n.9(1998:mag)-a.1998:v.1:n.10-11(1998:giu-lug)"/>

<annata idannata="58117" anno="1998" kordi="L998405147" kanno="1998" kbibl="CF"
	ninvent="CF 5545635 CFGIOR     A 0          04974"
	posseduto="a.1998:v.2:n.1-2(1998:ago-set)-a.1999:v.2:n.6-7(1999:gen-feb)"/>
  </ansfasc>
</MServDoc>
-->

<!-- =========================================	-->
<!--	MServDoc				-->
<!-- =========================================	-->
<xsl:template match="MServDoc">
	<xsl:apply-templates/>
<br/>
<br/>
	<xsl:if test="not(ansfasc)"><strong>Per la notizia non ci sono abbonamenti</strong></xsl:if>
<br/>
<br/>

</xsl:template>



<!-- =========================================	-->
<!--	ansfasc				-->
<!-- =========================================	-->
<xsl:template match="ansfasc">
 <table border="1">
	<tr> <th>Anno</th> <th>Collocazione</th> <th>Inventario</th> <th>Annate possedute</th></tr>
	<xsl:apply-templates/>
 </table>
</xsl:template>


<!-- =========================================	-->
<!--	ansfasc/annata				-->
<!-- =========================================	-->
<xsl:template match="annata">
<!--
  precedente a data 2/1/2012:
  <xsl:variable name="inv" select="substring(@ninvent,3,string-length(@ninvent)-18)"/>
  BID CFI0350137 richiede la sottrazione di 22.
-->
 <xsl:variable name="colloc" select="substring(@ninvent,string-length(@ninvent)-12)"/>
 <xsl:variable name="inv" select="substring(@ninvent,3,string-length(@ninvent)-22)"/>
 <tr>
  <td class="anno"><xsl:apply-templates select="." mode="link"/></td>
  <td class="abbo"><xsl:value-of select="$colloc"/></td>
  <td class="inv"><xsl:value-of select="$inv"/></td>
  <td class="poss"><xsl:value-of select="@posseduto"/></td>
 </tr>
</xsl:template>

<!-- ================================================================================== -->
<!--   ansfasc/annata/@idannatoa composizione del Link per la richiesta dei fascicoli	-->
<!-- ================================================================================== -->
<xsl:template match="annata/@idannata">
<a><xsl:attribute name="title">Cliccare per visualizzare le informazioni sull'annata</xsl:attribute>
	<xsl:attribute name="href"><xsl:value-of select="$contextpath"/>/annata/<xsl:value-of select="."/></xsl:attribute><xsl:value-of select="."/></a>
</xsl:template>

<xsl:template match="annata" mode="link">
<a><xsl:attribute name="title">Cliccare per visualizzare le informazioni sull'annata</xsl:attribute>
	<xsl:attribute name="href"><xsl:value-of select="$contextpath"/>/annata/<xsl:value-of select="@idannata"/></xsl:attribute><xsl:value-of select="@anno"/></a>
</xsl:template>


</xsl:stylesheet>

