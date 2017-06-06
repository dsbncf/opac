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
	
<xsl:template match="/">
<xsl:apply-templates/>
</xsl:template>

<!--
<MServDoc>
  <ansfasc>
   <annata idannata="120368" anno="2007" kordi="A008001462" kanno="2007" kbibl="CF"
	ninvent="CF 5983851 CFP.RIV    2.Ri.1a      SP0163"
	posseduto="a.2007:n.1(2007:janv.)-a.2007:n.6(2007:juin),a.2007:n.10/11(2007:oct.-nov.)"/>
  <sezione categoria="Base">
	<fascicolo etichetta="a. 2007:n. 1 (2007:janv.)" data="01/01/2007" statofas="Ricevuto"/>
	<fascicolo etichetta="a. 2007:n. 2 (2007:févr.)" data="01/02/2007" statofas="Ricevuto"/>
	<fascicolo etichetta="a. 2007:n. 3 (2007:mars)" data="01/03/2007" statofas="Ricevuto"/>
	<fascicolo etichetta="a. 2007:n. 4 (2007:avr.)" data="01/04/2007" statofas="Ricevuto"/>
	<fascicolo etichetta="a. 2007:n. 5 (2007:mai)" data="01/05/2007" statofas="Ricevuto"/>
	<fascicolo etichetta="a. 2007:n. 6 (2007:juin)" data="01/06/2007" statofas="Ricevuto"/>
	<fascicolo etichetta="a. 2007:n. 7 (2007:juil.)" data="01/07/2007" statofas="Lacuna"/>
	<fascicolo etichetta="a. 2007:n. 8 (2007:août)" data="01/08/2007" statofas="Lacuna"/>
	<fascicolo etichetta="a. 2007:n. 9 (2007:sept.)" data="01/09/2007" statofas="Lacuna"/>
	<fascicolo etichetta="a. 2007:n. 10/11 (2007:oct.-nov.)" data="01/10/2007" statofas="Ricevuto"/>
	<fascicolo etichetta="a. 2007:n. 12 (2007:déc.)" data="01/12/2007" statofas="Lacuna"/>
  </sezione>
 </ansfasc>
</MServDoc>
-->


<!-- =========================================	-->
<!--	MServDoc				-->
<!-- =========================================	-->
<xsl:template match="MServDoc">
	<xsl:apply-templates/>
</xsl:template>



<!-- =========================================	-->
<!--	ansfasc				-->
<!-- =========================================	-->
<xsl:template match="ansfasc">
	<xsl:apply-templates/>
</xsl:template>


<!-- =========================================	-->
<!--	annata				-->
<!-- =========================================	-->
<xsl:template match="annata">
 <xsl:variable name="colloc" select="substring(@ninvent,string-length(@ninvent)-12)"/>
 <xsl:variable name="inv" select="substring(@ninvent,3,string-length(@ninvent)-22)"/>
<!-- <xsl:value-of select="@idannata"/> -->
 <table border="1">
 <tr><th>Abbonamento</th><td class="abbo"><xsl:value-of select="@kordi"/></td></tr>
 <tr><th>Collocazione</th><td class="abbo"><xsl:value-of select="$colloc"/></td></tr>
 <tr><th>Anno</th><td class="anno"><xsl:value-of select="@anno"/></td></tr>
 <tr><th>Inventario</th><td class="inv"><xsl:value-of select="$inv"/></td></tr>
 <tr><th>Posseduto</th><td class="poss"><xsl:value-of select="@posseduto"/></td></tr>
 </table>
 <br/>
<xsl:comment>
idannata <xsl:value-of select="@idannata"/>
ninvent <xsl:value-of select="@ninvent"/>
kordi <xsl:value-of select="@kordi"/>
kanno <xsl:value-of select="@kanno"/>
</xsl:comment>
</xsl:template>


<!-- =========================================	-->
<!--	sezione				-->
<!-- =========================================	-->
<xsl:template match="sezione">
 <table border="1">
	<tr><th>Etichetta</th> <th>Data</th> <th>Stato</th> </tr>
	<xsl:apply-templates/>
 </table>
</xsl:template>


<!-- =========================================	-->
<!--	fascicolo				-->
<!-- =========================================	-->
<xsl:template match="fascicolo">
 <tr>
  <td class="etic"><xsl:value-of select="@etichetta"/></td>
  <td class="data"><xsl:value-of select="@data"/></td>
  <td class="stat"><xsl:value-of select="@statofas"/></td>
 </tr>
</xsl:template>



</xsl:stylesheet>


