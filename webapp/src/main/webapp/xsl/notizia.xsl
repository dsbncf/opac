<?xml version="1.0" encoding="UTF-8"?>

<!-- BNCF: $Id: notizia.xsl,v 1.93 2009/03/12 09:47:41 ds Exp $ -->

<!DOCTYPE notizia [
<!ENTITY nbsp "&#xA0;">
<!ENTITY eacute "&#xE9;">
<!ENTITY egrave "&#xE8;">
<!ENTITY agrave "&#xE0;">
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

<!-- =========================================	-->
<!--	rec					-->
<!-- =========================================	-->
<xsl:template match="rec">

	<xsl:variable name="leader" select="lab"/>
	<!-- leader + 0-based offset, substring instead is 1-based -->
	<xsl:variable name="natura"  select="substring($leader,8,1)"/>
	<xsl:variable name="livello" select="substring($leader,9,1)"/>
	<xsl:variable name="controlField008" select="cf[@t=008]"/>

<span><xsl:attribute name="class">notizia</xsl:attribute>
<xsl:call-template name="intestazione"/>
<xsl:call-template name="formato"/>
<xsl:call-template name="titcop"/>
<xsl:call-template name="note"/>
<xsl:call-template name="titolo_orig"/>
<xsl:call-template name="notetit"/>
<!-- marca -->
<xsl:apply-templates select="df[@t=921]"/>
<!-- impronta -->
<xsl:apply-templates select="df[@t=012]"/>
<xsl:call-template name="standardnum"/>
<xsl:call-template name="soggetti"/>
<xsl:call-template name="responsec"/>
<xsl:call-template name="classi"/>
<xsl:call-template name="codmateria"/>
<!-- Continuazione di -->
<xsl:apply-templates select="df[@t=430]/s1/df[@t=200]"/>
<!-- Continua con -->
<xsl:apply-templates select="df[@t=440]/s1/df[@t=200]"/>
<xsl:call-template name="continuaparziale"/>
<xsl:call-template name="continuatoparziale"/>
<xsl:call-template name="partedi">
    <xsl:with-param name="livello" select="$livello"/>
</xsl:call-template>
<xsl:call-template name="contiene">
    <xsl:with-param name="livello" select="$livello"/>
</xsl:call-template>
<xsl:call-template name="supplementoa"/>
<xsl:call-template name="hasupplemento"/>
<xsl:call-template name="assorbe"/>
<xsl:call-template name="assorbito"/>
<xsl:call-template name="altraedizione"/>
<xsl:call-template name="nationaluse"/>
<xsl:call-template name="materiale"/>
<xsl:call-template name="collocazione">
    <xsl:with-param name="natura"  select="$natura"/>
    <xsl:with-param name="livello" select="$livello"/>
</xsl:call-template>
<xsl:call-template name="risdigitale">
    <xsl:with-param name="cpath"  select="$contextpath"/>
</xsl:call-template>
<xsl:call-template name="coins"/>
<xsl:call-template name="googlebook"/>
</span><!--notizia-->
<xsl:text>
</xsl:text>

</xsl:template>


<!-- =========================================	-->
<!--	google books preview			-->
<!-- =========================================	-->
<xsl:template name="googlebook">
<xsl:variable name="isbn" select="df[@t='010']/sf[@c='a']"/>
<xsl:if test="$isbn!=''">
<div id="google" style="width:14em;margin:auto"></div>
<hr/>
<style type="text/css">
.gbs_thumb_img { float: left; margin-right: 1em; }
.gbs_preview_button { float: left; margin-top: 2em; }
</style>
<!--
<script>
  var api_url ="http://books.google.com/books?jscmd=viewapi&amp;bibkeys=ISBN<xsl:value-of select="$isbn"/>";
  document.write(unescape("%3Cscript src=" + api_url + " type='text/javascript'%3E%3C/script%3E"));
</script>
-->
<script>
  <xsl:attribute name="src">http://books.google.com/books?jscmd=viewapi&amp;bibkeys=ISBN<xsl:value-of select="$isbn"/></xsl:attribute>
  <xsl:attribute name="type">text/javascript</xsl:attribute>
</script>
<script>
  <xsl:attribute name="type">text/javascript</xsl:attribute>
  var buttonImg = 'http://code.google.com/apis/books/images/gbs_preview_button1.gif';
  var bookInfo = _GBSBookInfo['ISBN<xsl:value-of select="$isbn"/>'];
  if (bookInfo != null)
  {
     var previewButtonHTML = "";
     if (bookInfo.preview == "full" || bookInfo.preview == "partial")
     {
        previewButtonHTML = "&lt;p class=\"gbs_preview_button\"&gt;"
        + "&lt;a href=\"" + bookInfo.preview_url + "\"&gt;"
        + "&lt;img src=\"" + buttonImg + "\" border=\"0\"/&gt;&lt;/a&gt;&lt;/p&gt;";
     }
     var thumbnailHTML = "";
     if (bookInfo.thumbnail_url)
     {
        thumbnailHTML = "&lt;img class=\"gbs_thumb_img\" " + " border=0 src=\""
                      + bookInfo.thumbnail_url.replace('edge=curl','') + "\"/&gt;"
     }
     var divg = document.getElementById('google');
     divg.innerHTML = thumbnailHTML + previewButtonHTML + "&lt;div style=\"clear: both;\"&gt;&lt;/div&gt;";
  }
</script>
</xsl:if>
</xsl:template>


<!-- =========================================	-->
<!--	titolo breve (snippet)			-->
<!-- =========================================	-->
                                                                                                
<xsl:template name="breve_snippet">
  <xsl:for-each select="df[@t=200]">

	<xsl:value-of select="sf[@c='a']"/>

        <xsl:variable name="ind" select="@i1"/>
        <xsl:if test="$ind=0">
         <xsl:choose>
	  <xsl:when test="/rec/df[@t=461]/s1/df[@t=200]">
		<xsl:text> - - &gt; </xsl:text>
                <xsl:call-template name="snippet461"/>
	  </xsl:when>
	  <xsl:when test="/rec/df[@t=462]/s1/df[@t=200]">
		<xsl:text> - - &gt; </xsl:text>
                <xsl:call-template name="snippet462"/>
	  </xsl:when>
         </xsl:choose>
        </xsl:if>

	<xsl:call-template name="subfieldSelect">
		<xsl:with-param name="codes">cdhi</xsl:with-param>
	</xsl:call-template>
	<xsl:if test="sf[@c='e']"> : <xsl:call-template name="substDelim">
	  <xsl:with-param name="string" select="sf[@c='e']"/></xsl:call-template></xsl:if>

	<xsl:if test="/rec/df[@t=205]/sf[@c='a']">
	  <xsl:text>. </xsl:text>
	<xsl:call-template name="snippet205"/>
        <xsl:text> </xsl:text>
	</xsl:if>

        <xsl:variable name="ediz" select="translate(/rec/df[@t=210]/sf[@c='c'],'sn','SN')"/>

	<xsl:if test="$ediz and not(contains($ediz,'S.N.') or contains($ediz,'S. N.'))">
	  <!-- radoppia eventualmente il punto con 205$a -->
	  <xsl:text> - </xsl:text>
	  <xsl:value-of select="/rec/df[@t=210]/sf[@c='c']"/>
	</xsl:if>

  </xsl:for-each>
</xsl:template>

<!-- =========================================	-->
<!--	snippet 461				-->
<!-- =========================================	-->
<xsl:template name="snippet461">
  <xsl:for-each select="/rec/df[@t=461]/s1/df[@t=200]">
        <xsl:call-template name="titolo"/>
  </xsl:for-each>
</xsl:template>
                                                                                                
<!-- =========================================	-->
<!--	snippet 462				-->
<!-- =========================================	-->
<xsl:template name="snippet462">
 <xsl:for-each select="/rec/df[@t=462]/s1/df[@t=200]">
        <xsl:call-template name="titolo"/>
 </xsl:for-each>
</xsl:template>
                                                                                                

<!-- =========================================	-->
<!--	snippet 205				-->
<!-- =========================================	-->
<xsl:template name="snippet205">
 <xsl:for-each select="/rec/df[@t=205]">
	<xsl:text> </xsl:text>
        <xsl:call-template name="subfieldSelect">
                <xsl:with-param name="codes">adgfb</xsl:with-param>
		<xsl:with-param name="delimiter">, </xsl:with-param>
        </xsl:call-template>
 </xsl:for-each>
</xsl:template>
                                                                                                


<!-- ==================================	-->
<!--	formato				-->
<!-- ==================================	-->
 <xsl:template name="formato">
 <xsl:if test="df[@t=215]|df[@t=225]">
 &br1;
 <formato>
  <xsl:apply-templates select="df[@t=215]"/>
  <xsl:apply-templates select="df[@t=225]"/>
 </formato>
 </xsl:if>
 </xsl:template>


<!-- ==================================	-->
<!--	215				-->
<!-- ==================================	-->
 <xsl:template match="df[@t=215]">
   <xsl:call-template name="substDelim">
    <xsl:with-param name="string"><xsl:value-of select="sf[@c='a']"/></xsl:with-param>
   </xsl:call-template>
  <xsl:if test="sf[@c='a'] and sf[@c='c']"> : </xsl:if>
  <xsl:value-of select="sf[@c='c']"/>
  <xsl:if test="(sf[@c='a']|sf[@c='c']) and (sf[@c='d']|sf[@c='e'])"> ; </xsl:if>
  
  <xsl:for-each select="sf[@c='d']|sf[@c='e']">
   <xsl:value-of select="."/>
   <xsl:if test="@c = 'd' and (position() != last())"> + </xsl:if>
  </xsl:for-each>
 </xsl:template>


<!-- ==================================	-->
<!--	225				-->
<!-- ==================================	-->
<xsl:template match="df[@t=225]">

  <!-- // ricerca tramite titolo della collana
  <xsl:variable name="params"><xsl:call-template name="trim">
	<xsl:with-param name="string" select="sf[@c='a']"/>
	</xsl:call-template></xsl:variable>
  -->
  <xsl:variable name="pos" select="position()"/>
  <xsl:variable name="bid" select="substring(/rec/df[@t='410'][position() = $pos]/s1/cf[@t='001'],1,10)"/>

  <xsl:variable name="display">
   <xsl:for-each select="sf">
    <xsl:choose>
     <xsl:when test="@c = 'a'">
	<xsl:call-template name="substDelim">
	   <xsl:with-param name="string"><xsl:value-of select="text()"/></xsl:with-param>
	</xsl:call-template>
     </xsl:when>
     <xsl:when test="@c = 'd'"><xsl:text>. </xsl:text><xsl:value-of select="text()"/> </xsl:when>
     <xsl:when test="@c = 'f'"><xsl:text> / </xsl:text><xsl:value-of select="text()"/> </xsl:when>
     <xsl:when test="@c = 'i'"><xsl:text>. </xsl:text><xsl:value-of select="text()"/> </xsl:when>
     <xsl:when test="@c = 'x'"><xsl:text>, ISSN </xsl:text><xsl:value-of select="text()"/> </xsl:when>
     <xsl:when test="@c = 'v'"><xsl:text> ; </xsl:text><xsl:value-of select="text()"/> </xsl:when>
   </xsl:choose>
  </xsl:for-each>
  </xsl:variable>

  ( <i><a><xsl:attribute
	name="href"><xsl:value-of select="$contextpath"/>/fcsearch?sf1=bid&amp;sv1=<xsl:value-of select="$bid"/></xsl:attribute>
	<xsl:attribute name="title">
   	<xsl:call-template name="translate">
   	<xsl:with-param name="section">traduzioni</xsl:with-param>
   	<xsl:with-param name="sigla">ricerca_notizie_collana</xsl:with-param>
   	</xsl:call-template>
   </xsl:attribute><xsl:value-of select="$display"/></a></i> )

</xsl:template>


<!-- ==================================================	-->
<!--	Continuazione di : [430]/s1/[200]	-->
<!-- ==================================================	-->
<xsl:template match="df[@t=430]/s1/df[@t=200]">
  &br2;<b>Continuazione di:</b>
  &br1;
  <a><xsl:attribute name="href"><xsl:value-of select="$contextpath"/>/fcsearch?sf1=bid&amp;sv1=<xsl:value-of select="substring(../../s1/cf[@t=001],1,10)"/></xsl:attribute>
  <xsl:attribute name="title">
   	<xsl:call-template name="translate">
   	<xsl:with-param name="section">traduzioni</xsl:with-param>
   	<xsl:with-param name="sigla">ricerca_notizie_titolo</xsl:with-param>
   	</xsl:call-template>
  </xsl:attribute>

  <xsl:for-each select="sf">
	<xsl:if test="@c='a'">
	 <xsl:call-template name="substDelim">
           <xsl:with-param name="string"><xsl:value-of select="."/></xsl:with-param>
	 </xsl:call-template>
	</xsl:if>
	<xsl:if test="@c='e'"> : <xsl:value-of select="."/> </xsl:if>
	<xsl:if test="@c='f'"> / <xsl:value-of select="."/> </xsl:if>
	<xsl:if test="@c='i'"> = <xsl:value-of select="."/> </xsl:if>
  </xsl:for-each>
 </a> 
</xsl:template>


<!-- ==================================================	-->
<!--	Continua con : [440]/s1/[200]	-->
<!-- ==================================================	-->
<xsl:template match="df[@t=440]/s1/df[@t=200]">
  &br2;<b>Continua con:</b>
  &br1;
  <a><xsl:attribute name="href"><xsl:value-of select="$contextpath"/>/fcsearch?sf1=bid&amp;sv1=<xsl:value-of select="substring(/rec/df[@t=440]/s1/cf[@t=001],1,10)"/></xsl:attribute>
    <xsl:attribute name="title">
   	<xsl:call-template name="translate">
   	<xsl:with-param name="section">traduzioni</xsl:with-param>
   	<xsl:with-param name="sigla">ricerca_notizie_titolo</xsl:with-param>
   	</xsl:call-template>
    </xsl:attribute>
  <xsl:for-each select="sf">
	<xsl:if test="@c='a'">
	 <xsl:call-template name="substDelim">
           <xsl:with-param name="string"><xsl:value-of select="."/></xsl:with-param>
	 </xsl:call-template>
	</xsl:if>
	<xsl:if test="@c='e'"> : <xsl:value-of select="."/> </xsl:if>
	<xsl:if test="@c='f'"> / <xsl:value-of select="."/> </xsl:if>
	<xsl:if test="@c='i'"> = <xsl:value-of select="."/> </xsl:if>
  </xsl:for-each>
 </a> 
</xsl:template>



<!-- ==================================	-->
<!--	numero standard	(generale)	-->
<!-- ==================================	-->
<xsl:template name="standardnum">
 <xsl:if test="df[@t=010]|df[@t=011]|df[@t=013]|df[@t=020]|df[@t=071]|df[@t=090]">
 &br1;
 <standardnum>
  <xsl:apply-templates select="df[@t=010]"/>
  <xsl:apply-templates select="df[@t=011]/sf[@c='a']"/>
  <xsl:apply-templates select="df[@t=013]"/>
  <xsl:apply-templates select="df[@t=020]/sf[@c='b']"/>
  <xsl:apply-templates select="df[@t=071]/sf[@c='a']"/>
  <xsl:apply-templates select="df[@t=090]/sf[@c='a']"/>
 </standardnum>
 </xsl:if>
</xsl:template>


<!-- ==================================	-->
<!--	numero standard	 [010]		-->
<!-- ==================================	-->
<xsl:template match="df[@t=010]">
  <xsl:if test="sf[@c='a']"><xsl:text>ISBN </xsl:text><xsl:value-of select="sf[@c='a']"/>.&nbsp;&nbsp;</xsl:if> <xsl:if test="sf[@c='z']"><xsl:text>ISBN </xsl:text><xsl:value-of select="sf[@c='z']"/> (errato).&nbsp;&nbsp;</xsl:if> <xsl:if test="sf[@c='b'] and not(sf[@c='b']='')"><xsl:text> (</xsl:text><xsl:value-of select="sf[@c='b']"/>).&nbsp;&nbsp;</xsl:if>
</xsl:template>

<!-- ==================================	-->
<!--	numero standard	 [011]		-->
<!-- ==================================	-->
<xsl:template match="df[@t=011]/sf[@c='a']">
	<xsl:text>ISSN </xsl:text><xsl:value-of select="."/>.&nbsp;&nbsp;
</xsl:template>

<!-- ==================================	-->
<!--	numero standard	 [013]		-->
<!-- ==================================	-->
<xsl:template match="df[@t=013]">
  <xsl:if test="sf[@c='a']"><xsl:text>ISMN </xsl:text><xsl:value-of select="sf[@c='a']"/></xsl:if><xsl:if test="sf[@c='b'] and (text()!='')"><xsl:text> (</xsl:text><xsl:value-of select="sf[@c='b']"/>)</xsl:if>.&nbsp;&nbsp;&nbsp;
</xsl:template>

<!-- ==================================	-->
<!--	numero standard	 [020]		-->
<!-- ==================================	-->
<xsl:template match="df[@t=020]/sf[@c='b']">
	<xsl:text>BN </xsl:text><xsl:value-of select="."/>.&nbsp;&nbsp;&nbsp;
</xsl:template>

<!-- ==================================	-->
<!--	numero standard	 [071]		-->
<!-- ==================================	-->
<xsl:template match="df[@t=071]/sf[@c='a']">
	<xsl:text>N.l. </xsl:text><xsl:value-of select="."/>.&nbsp;&nbsp;&nbsp;
</xsl:template>

<!-- ==================================	-->
<!--	numero standard	 [090]		-->
<!-- ==================================	-->
<xsl:template match="df[@t=090]/sf[@c='a']">
	<xsl:text>CUBI </xsl:text><xsl:value-of select="."/>.&nbsp;&nbsp;&nbsp;
</xsl:template>


<!-- ==================================	-->
<!--	note [3xx]			-->
<!-- ==================================	-->
<xsl:template name="note">
 <xsl:if test="df[@t=300]|df[@t=301]|df[@t=302]|df[@t=303]|df[@t=304]|df[@t=305]|df[@t=306]|df[@t=307]|df[@t=308]|df[@t=310]|df[@t=311]|df[@t=313]|df[@t=314]|df[@t=315]|df[@t=320]|df[@t=321]|df[@t=324]|df[@t=326]|df[@t=327]|df[@t=328]|df[@t=330]|df[@t=337]">
 &br1;
 <span><xsl:attribute name="class">note</xsl:attribute>
 <xsl:for-each select="df[@t=300]|df[@t=301]|df[@t=302]|df[@t=303]|df[@t=304]|df[@t=305]|df[@t=306]|df[@t=307]|df[@t=308]|df[@t=310]|df[@t=311]|df[@t=313]|df[@t=314]|df[@t=315]|df[@t=320]|df[@t=321]|df[@t=324]|df[@t=326]|df[@t=327]|df[@t=328]|df[@t=330]|df[@t=337]">

	<xsl:if test="position() > 1">. - </xsl:if>
	<xsl:call-template name="subfieldSelect">
		<xsl:with-param name="codes">a</xsl:with-param>
		<xsl:with-param name="delimiter"> - </xsl:with-param>
	</xsl:call-template>
	<xsl:if test="sf[@c='5']"> (<xsl:value-of select="sf[@c='5']"/>) </xsl:if>
 </xsl:for-each>
 </span><!-- note -->
 </xsl:if>
</xsl:template>


<!-- ==================================	-->
<!--	marca [921]			-->
<!-- ==================================	-->
<xsl:template match="df[@t=921]">
 <xsl:if test="sf[@c='b']">
  &br1;
  <marca>Marca: <xsl:apply-templates select="sf[@c='b']"/></marca>
 </xsl:if>
</xsl:template>

<!-- ==================================	-->
<!--	marca [921$b]			-->
<!-- ==================================	-->
<xsl:template match="df[@t=921]/sf[@c='b']">
 <xsl:text> </xsl:text><xsl:value-of select="."/>
</xsl:template>


<!-- ==================================	-->
<!--	impronta [012]			-->
<!-- ==================================	-->
<xsl:template match="df[@t=012]">
 <xsl:if test="sf[@c='a']">
  &br1;
  <impronta>Impronta: <xsl:apply-templates select="sf[@c='a']"/></impronta>
 </xsl:if>
</xsl:template>

<!-- ==================================	-->
<!--	impronta [012$b]		-->
<!-- ==================================	-->
<xsl:template match="df[@t=012]/sf[@c='a']">
 <xsl:text> </xsl:text>
 <xsl:call-template name="substDelim">
     <xsl:with-param name="string"><xsl:value-of select="."/></xsl:with-param>
 </xsl:call-template>
</xsl:template>


<!-- ==================================	-->
<!--	tit. in cop. [312]		-->
<!-- ==================================	-->
<xsl:template name="titcop">
 <xsl:if test="df[@t=312]">
  &br1;
 <titcop>
    <xsl:for-each select="df[@t=312]">
	<xsl:if test="position() > 1"> - </xsl:if>
	<xsl:call-template name="substDelim">
           <xsl:with-param name="string">
		<xsl:call-template name="subfieldSelect">
			<xsl:with-param name="codes">a</xsl:with-param>
			<xsl:with-param name="delimiter">. </xsl:with-param>
		</xsl:call-template>
	   </xsl:with-param>
	</xsl:call-template>
	<xsl:text> </xsl:text>
    </xsl:for-each>
 </titcop>
 </xsl:if>
</xsl:template>


<!-- ==================================	-->
<!--	materiale			-->
<!-- ==================================	-->
<xsl:template name="materiale">
 &br2;
 <span><xsl:attribute name="class">materiale</xsl:attribute>
 <xsl:call-template name="natura"/> -
 <xsl:call-template name="decodifMateriale"/> -
 <xsl:apply-templates select="df[@t=102]/sf[@c='a']"/>
 <xsl:if test="df[@t=101]"> - <xsl:apply-templates select="df[@t=101]"/></xsl:if>
 </span><!--materiale-->
</xsl:template>


<!-- ==================================	-->
<!--	supplemento a			-->
<!-- ==================================	-->
<xsl:template name="supplementoa">
 <xsl:if test="df[@t=422]">
 <supplementoa>
 &br2;
 <b>
 <xsl:call-template name="translate">
 <xsl:with-param name="section">traduzioni</xsl:with-param>
 <xsl:with-param name="sigla">supplemento_a</xsl:with-param>
 </xsl:call-template>:
 </b>
 <xsl:for-each select="df[@t=422]">
  <xsl:sort select="s1/df[@t=200]/sf[@c='a']" data-type="number"/>
  <xsl:variable name="idn" select="substring(s1/cf[@t='001'],1,10)"/>

  <xsl:for-each select="s1/df[@t=200]">
   &br1;
   <a><xsl:attribute name="href"><xsl:value-of select="$contextpath"/>/fcsearch?sf1=bid&amp;sv1=<xsl:value-of select="$idn"/></xsl:attribute>
    <xsl:attribute name="title">
   	<xsl:call-template name="translate">
   	<xsl:with-param name="section">traduzioni</xsl:with-param>
   	<xsl:with-param name="sigla">ricerca_notizie_titolo</xsl:with-param>
   	</xsl:call-template>
    </xsl:attribute>
	<xsl:if test="sf[@c='v']"><xsl:value-of select="sf[@c='v']"/> : </xsl:if>
	<xsl:call-template name="substDelim">
           <xsl:with-param name="string"><xsl:value-of select="sf[@c='a']"/></xsl:with-param>
	</xsl:call-template>
	<xsl:if test="sf[@c='e']"> : <xsl:value-of select="sf[@c='e']"/> </xsl:if>
	<xsl:if test="sf[@c='f']"> / <xsl:value-of select="sf[@c='f']"/> </xsl:if>
        <xsl:if test="sf[@c='1']">
	   <xsl:variable name="idn2" select="substring(sf[@c='1'],4,10)"/>
	   (<xsl:value-of select="$idn2"/>)
        </xsl:if>
   </a> 
   </xsl:for-each>
  </xsl:for-each>
 </supplementoa>
 </xsl:if>
</xsl:template>


<!-- ==================================	-->
<!--	has supplemento			-->
<!-- ==================================	-->
<xsl:template name="hasupplemento">
 <xsl:if test="df[@t=421]">
 <hasupplemento>
 &br2;
 <b>
 <xsl:call-template name="translate">
 <xsl:with-param name="section">traduzioni</xsl:with-param>
 <xsl:with-param name="sigla">ha_per_supplemento</xsl:with-param>
 </xsl:call-template>:
 </b>
 <xsl:for-each select="df[@t=421]">
  <xsl:sort select="s1/df[@t=200]/sf[@c='a']" data-type="number"/>
  <xsl:variable name="idn" select="substring(s1/cf[@t='001'],1,10)"/>

  <xsl:for-each select="s1/df[@t=200]">
   &br1;
   <a><xsl:attribute name="href"><xsl:value-of select="$contextpath"/>/fcsearch?sf1=bid&amp;sv1=<xsl:value-of select="$idn"/></xsl:attribute>
    <xsl:attribute name="title">
   	<xsl:call-template name="translate">
   	<xsl:with-param name="section">traduzioni</xsl:with-param>
   	<xsl:with-param name="sigla">ricerca_notizie_titolo</xsl:with-param>
   	</xsl:call-template>
    </xsl:attribute>
	<xsl:if test="sf[@c='v']"><xsl:value-of select="sf[@c='v']"/> : </xsl:if>
	<xsl:call-template name="substDelim">
           <xsl:with-param name="string"><xsl:value-of select="sf[@c='a']"/></xsl:with-param>
	</xsl:call-template>
	<xsl:if test="sf[@c='e']"> : <xsl:value-of select="sf[@c='e']"/> </xsl:if>
	<xsl:if test="sf[@c='f']"> / <xsl:value-of select="sf[@c='f']"/> </xsl:if>
        <xsl:if test="sf[@c='1']">
	   <xsl:variable name="idn2" select="substring(sf[@c='1'],4,10)"/>
	   (<xsl:value-of select="$idn2"/>)
        </xsl:if>
        <!-- ( <xsl:value-of select="$idn"/> ) -->
   </a> 
   </xsl:for-each>
  </xsl:for-each>
 </hasupplemento>
 </xsl:if>
</xsl:template>



<!-- ==================================	-->
<!--	continua parziale		-->
<!-- ==================================	-->
<xsl:template name="continuaparziale">
 <xsl:if test="df[@t=431]">
 <continuaparziale>
 &br2;
 <b>
 <xsl:call-template name="translate">
 <xsl:with-param name="section">traduzioni</xsl:with-param>
 <xsl:with-param name="sigla">continuazione_parziale</xsl:with-param>
 </xsl:call-template>:
 </b>
 <xsl:for-each select="df[@t=431]">
  <xsl:sort select="s1/df[@t=200]/sf[@c='a']" data-type="number"/>
  <xsl:variable name="idn" select="substring(s1/cf[@t='001'],1,10)"/>

  <xsl:for-each select="s1/df[@t=200]">
   &br1;
   <a><xsl:attribute name="href"><xsl:value-of select="$contextpath"/>/fcsearch?sf1=bid&amp;sv1=<xsl:value-of select="$idn"/></xsl:attribute>
    <xsl:attribute name="title">
   	<xsl:call-template name="translate">
   	<xsl:with-param name="section">traduzioni</xsl:with-param>
   	<xsl:with-param name="sigla">ricerca_notizie_titolo</xsl:with-param>
   	</xsl:call-template>
    </xsl:attribute>
	<xsl:if test="sf[@c='v']"><xsl:value-of select="sf[@c='v']"/> : </xsl:if>
	<xsl:call-template name="substDelim">
           <xsl:with-param name="string"><xsl:value-of select="sf[@c='a']"/></xsl:with-param>
	</xsl:call-template>
	<xsl:if test="sf[@c='e']"> : <xsl:value-of select="sf[@c='e']"/> </xsl:if>
	<xsl:if test="sf[@c='f']"> / <xsl:value-of select="sf[@c='f']"/> </xsl:if>
        <xsl:if test="sf[@c='1']">
	   <xsl:variable name="idn2" select="substring(sf[@c='1'],4,10)"/>
	   (<xsl:value-of select="$idn2"/>)
        </xsl:if>
        <!-- ( <xsl:value-of select="$idn"/> ) -->
   </a> 
   </xsl:for-each>
  </xsl:for-each>
 </continuaparziale>
 </xsl:if>
</xsl:template>


<!-- ==================================	-->
<!--	continuato parziale		-->
<!-- ==================================	-->
<xsl:template name="continuatoparziale">
 <xsl:if test="df[@t=441]">
 <continuatoeparziale>
 &br2;
 <b>
 <xsl:call-template name="translate">
 <xsl:with-param name="section">traduzioni</xsl:with-param>
 <xsl:with-param name="sigla">continuato_parzialmente_da</xsl:with-param>
 </xsl:call-template>:
 </b>
 <xsl:for-each select="df[@t=441]">
  <xsl:sort select="s1/df[@t=200]/sf[@c='a']" data-type="number"/>
  <xsl:variable name="idn" select="substring(s1/cf[@t='001'],1,10)"/>

  <xsl:for-each select="s1/df[@t=200]">
   &br1;
   <a><xsl:attribute name="href"><xsl:value-of select="$contextpath"/>/fcsearch?sf1=bid&amp;sv1=<xsl:value-of select="$idn"/></xsl:attribute>
    <xsl:attribute name="title">
   	<xsl:call-template name="translate">
   	<xsl:with-param name="section">traduzioni</xsl:with-param>
   	<xsl:with-param name="sigla">ricerca_notizie_titolo</xsl:with-param>
   	</xsl:call-template>
   </xsl:attribute>
	<xsl:if test="sf[@c='v']"><xsl:value-of select="sf[@c='v']"/> : </xsl:if>
	<xsl:call-template name="substDelim">
           <xsl:with-param name="string"><xsl:value-of select="sf[@c='a']"/></xsl:with-param>
	</xsl:call-template>
	<xsl:if test="sf[@c='e']"> : <xsl:value-of select="sf[@c='e']"/> </xsl:if>
	<xsl:if test="sf[@c='f']"> / <xsl:value-of select="sf[@c='f']"/> </xsl:if>
        <xsl:if test="sf[@c='1']">
	   <xsl:variable name="idn2" select="substring(sf[@c='1'],4,10)"/>
	   (<xsl:value-of select="$idn2"/>)
        </xsl:if>
   </a> 
   </xsl:for-each>
  </xsl:for-each>
 </continuatoeparziale>
 </xsl:if>
</xsl:template>



<!-- ==================================	-->
<!--	assorbe				-->
<!-- ==================================	-->
<xsl:template name="assorbe">
 <xsl:if test="df[@t=434]">
 <assorbe>
 &br2;
 <b>
 <xsl:call-template name="translate">
 <xsl:with-param name="section">traduzioni</xsl:with-param>
 <xsl:with-param name="sigla">assorbe</xsl:with-param>
 </xsl:call-template>:
 </b>
 <xsl:for-each select="df[@t=434]">
  <xsl:sort select="s1/df[@t=200]/sf[@c='a']" data-type="number"/>
  <xsl:variable name="idn" select="substring(s1/cf[@t='001'],1,10)"/>

  <xsl:for-each select="s1/df[@t=200]">
   &br1;
   <a><xsl:attribute name="href"><xsl:value-of select="$contextpath"/>/fcsearch?sf1=bid&amp;sv1=<xsl:value-of select="$idn"/></xsl:attribute>
    <xsl:attribute name="title">
       	<xsl:call-template name="translate">
   	<xsl:with-param name="section">traduzioni</xsl:with-param>
   	<xsl:with-param name="sigla">ricerca_notizie_titolo</xsl:with-param>
   	</xsl:call-template>
    </xsl:attribute>
	<xsl:if test="sf[@c='v']"><xsl:value-of select="sf[@c='v']"/> : </xsl:if>
	<xsl:call-template name="substDelim">
           <xsl:with-param name="string"><xsl:value-of select="sf[@c='a']"/></xsl:with-param>
	</xsl:call-template>
	<xsl:if test="sf[@c='e']"> : <xsl:value-of select="sf[@c='e']"/> </xsl:if>
	<xsl:if test="sf[@c='f']"> / <xsl:value-of select="sf[@c='f']"/> </xsl:if>
        <xsl:if test="sf[@c='1']">
	   <xsl:variable name="idn2" select="substring(sf[@c='1'],4,10)"/>
	   (<xsl:value-of select="$idn2"/>)
        </xsl:if>
   </a> 
   </xsl:for-each>
  </xsl:for-each>
 </assorbe>
 </xsl:if>
</xsl:template>


<!-- ==================================	-->
<!--	assorbito			-->
<!-- ==================================	-->
<xsl:template name="assorbito">
 <xsl:if test="df[@t=444]">
 <assorbito>
 &br2;
 <b>
 <xsl:call-template name="translate">
 <xsl:with-param name="section">traduzioni</xsl:with-param>
 <xsl:with-param name="sigla">assorbito_da</xsl:with-param>
 </xsl:call-template>:
 </b>
 <xsl:for-each select="df[@t=444]">
  <xsl:sort select="s1/df[@t=200]/sf[@c='a']" data-type="number"/>
  <xsl:variable name="idn" select="substring(s1/cf[@t='001'],1,10)"/>

  <xsl:for-each select="s1/df[@t=200]">
   &br1;
   <a><xsl:attribute name="href"><xsl:value-of select="$contextpath"/>/fcsearch?sf1=bid&amp;sv1=<xsl:value-of select="$idn"/></xsl:attribute>
	<xsl:if test="sf[@c='v']"><xsl:value-of select="sf[@c='v']"/> : </xsl:if>
	<xsl:call-template name="substDelim">
           <xsl:with-param name="string"><xsl:value-of select="sf[@c='a']"/></xsl:with-param>
	</xsl:call-template>
	<xsl:if test="sf[@c='e']"> : <xsl:value-of select="sf[@c='e']"/> </xsl:if>
	<xsl:if test="sf[@c='f']"> / <xsl:value-of select="sf[@c='f']"/> </xsl:if>
        <xsl:if test="sf[@c='1']">
	   <xsl:variable name="idn2" select="substring(sf[@c='1'],4,10)"/>
	   (<xsl:value-of select="$idn2"/>)
        </xsl:if>
        <!-- ( <xsl:value-of select="$idn"/> ) -->
   </a> 
   </xsl:for-each>
  </xsl:for-each>
 </assorbito>
 </xsl:if>
</xsl:template>


<!-- ==================================	-->
<!--	altra edizione			-->
<!-- ==================================	-->
<xsl:template name="altraedizione">
 <xsl:if test="df[@t=451]">
 <altraedizione>
 &br2;
 <b>
 <xsl:call-template name="translate">
 <xsl:with-param name="section">traduzioni</xsl:with-param>
 <xsl:with-param name="sigla">altra_edizione_di</xsl:with-param>
 </xsl:call-template>:
 </b>
 <xsl:for-each select="df[@t=451]">
  <xsl:sort select="s1/df[@t=200]/sf[@c='a']" data-type="number"/>
  <xsl:variable name="idn" select="substring(s1/cf[@t='001'],1,10)"/>

  <xsl:for-each select="s1/df[@t=200]">
   &br1;
   <a><xsl:attribute name="href"><xsl:value-of select="$contextpath"/>/fcsearch?sf1=bid&amp;sv1=<xsl:value-of select="$idn"/></xsl:attribute>
    <xsl:attribute name="title">
   	<xsl:call-template name="translate">
   	<xsl:with-param name="section">traduzioni</xsl:with-param>
   	<xsl:with-param name="sigla">ricerca_notizie_titolo</xsl:with-param>
   	</xsl:call-template>
    </xsl:attribute>
	<xsl:if test="sf[@c='v']"><xsl:value-of select="sf[@c='v']"/> : </xsl:if>
	<xsl:call-template name="substDelim">
           <xsl:with-param name="string"><xsl:value-of select="sf[@c='a']"/></xsl:with-param>
	</xsl:call-template>
	<xsl:if test="sf[@c='e']"> : <xsl:value-of select="sf[@c='e']"/> </xsl:if>
	<xsl:if test="sf[@c='f']"> / <xsl:value-of select="sf[@c='f']"/> </xsl:if>
        <xsl:if test="sf[@c='1']">
	   <xsl:variable name="idn2" select="substring(sf[@c='1'],4,10)"/>
	   (<xsl:value-of select="$idn2"/>)
        </xsl:if>
        <!-- ( <xsl:value-of select="$idn"/> ) -->
   </a> 
   </xsl:for-each>
  </xsl:for-each>
 </altraedizione>
 </xsl:if>
</xsl:template>


<!-- ==================================	-->
<!--	fa parte di	[461, 462]	-->
<!-- ==================================	-->
<xsl:template name="partedi">
	 <xsl:param name="livello"/>
 <xsl:if test="df[@t=461] or (df[@t=462] and ($livello = '2'))">
 <partedi>
 &br2;
 <b>
 <xsl:call-template name="translate">
 <xsl:with-param name="section">traduzioni</xsl:with-param>
 <xsl:with-param name="sigla">fa_parte_di</xsl:with-param>
 </xsl:call-template>: 
 </b>
 <xsl:apply-templates select="df[@t=461]/s1/df[@t=200]"/>
 <xsl:if test="df[@t=462] and ($livello = '2')"><xsl:call-template name="contiene462"/></xsl:if>
 </partedi>
 </xsl:if>
</xsl:template>

<!-- ==================================	-->
<!--	fa parte di	[461]		-->
<!-- ==================================	-->
<xsl:template match="df[@t=461]/s1/df[@t=200]">
  <a><xsl:attribute name="href"><xsl:value-of select="$contextpath"/>/fcsearch?sf1=bid&amp;sv1=<xsl:value-of select="substring(/rec/df[@t='461']/s1/cf[@t='001'],1,10)"/> 
     </xsl:attribute>
    <xsl:attribute name="title">
   	<xsl:call-template name="translate">
   	<xsl:with-param name="section">traduzioni</xsl:with-param>
   	<xsl:with-param name="sigla">ricerca_notizie_titolo</xsl:with-param>
   	</xsl:call-template>
    </xsl:attribute>
	<xsl:call-template name="substDelim">
	  <xsl:with-param name="string"><xsl:value-of select="sf[@c='a']"/></xsl:with-param>
	</xsl:call-template>
	<xsl:if test="sf[@c='e']"> : <xsl:value-of select="sf[@c='e']"/> </xsl:if>
	<xsl:if test="sf[@c='f']"> / <xsl:value-of select="sf[@c='f']"/> </xsl:if>
	<xsl:if test="sf[@c='g']"> ; <xsl:value-of select="sf[@c='g']"/> </xsl:if>
 </a> 
</xsl:template>



<!-- ==================================	-->
<!--	contiene	[462,463]	-->
<!-- ==================================	-->
<xsl:template name="contiene">
	 <xsl:param name="livello"/>
 <xsl:if test="df[@t=463] or (df[@t=462] and ($livello = '1'))">
 <contiene>
 &br2;
 <b>
 <xsl:call-template name="translate">
 <xsl:with-param name="section">traduzioni</xsl:with-param>
 <xsl:with-param name="sigla">contiene</xsl:with-param>
 </xsl:call-template>:
 </b>
 <xsl:choose>
  <xsl:when test="($livello = '1')">
    <xsl:call-template name="contiene462e463"/>
  </xsl:when>
  <xsl:otherwise>
    <xsl:if test="df[@t=463]"><xsl:call-template name="contiene463"/></xsl:if>
  </xsl:otherwise>
 </xsl:choose>
 </contiene>
 </xsl:if>
</xsl:template>


<!-- ==================================	-->
<!--	contiene	[462]		-->
<!-- ==================================	-->
<xsl:template name="contiene462">
 <xsl:for-each select="df[@t=462]">
  <xsl:sort select="s1/df[@t=200]/sf[@c='a']" data-type="number"/>
  <xsl:variable name="idn" select="substring(s1/cf[@t='001'],1,10)"/>

 <xsl:for-each select="s1/df[@t=200]">
   &br1;
   <a><xsl:attribute name="href"><xsl:value-of select="$contextpath"/>/fcsearch?sf1=bid&amp;sv1=<xsl:value-of select="$idn"/></xsl:attribute>
    <xsl:attribute name="title">
   	<xsl:call-template name="translate">
   	<xsl:with-param name="section">traduzioni</xsl:with-param>
   	<xsl:with-param name="sigla">ricerca_notizie_titolo</xsl:with-param>
   	</xsl:call-template>
    </xsl:attribute>
	<xsl:if test="sf[@c='v'] and (sf[@c='v'] != substring(sf[@c='a'],1,1))"><xsl:value-of select="sf[@c='v']"/> : </xsl:if>
        <xsl:call-template name="titolo"/>
   </a> 
  </xsl:for-each>
 </xsl:for-each>
</xsl:template>


<!-- ==================================	-->
<!--	contiene	[463]		-->
<!-- ==================================	-->
<xsl:template name="contiene463">
 <xsl:for-each select="df[@t=463]">
   <xsl:sort select="s1/df[@t=200]/sf[@c='a']" data-type="number"/>

  <xsl:variable name="idn" select="substring(s1/cf[@t='001'],1,10)"/>
  <xsl:for-each select="s1/df[@t=200]">
   &br1;
   <a><xsl:attribute name="href"><xsl:value-of select="$contextpath"/>/fcsearch?sf1=bid&amp;sv1=<xsl:value-of select="$idn"/></xsl:attribute>
    <xsl:attribute name="title">
   	<xsl:call-template name="translate">
   	<xsl:with-param name="section">traduzioni</xsl:with-param>
   	<xsl:with-param name="sigla">ricerca_notizie_titolo</xsl:with-param>
   	</xsl:call-template>
    </xsl:attribute>
	<xsl:variable name="tit">
	<xsl:call-template name="substDelim">
	   <xsl:with-param name="string"><xsl:value-of select="sf[@c='a']"/></xsl:with-param>
	</xsl:call-template>
	</xsl:variable>
	<xsl:variable name="titn"><xsl:value-of select="substring($tit,1,1)"/></xsl:variable>
	<xsl:if test="sf[@c='v'] and ($titn != sf[@c='v'])">
		<xsl:value-of select="sf[@c='v']"/> : </xsl:if>
        <xsl:call-template name="titolo"/>
        <xsl:if test="sf[@c='1']">
	   <xsl:variable name="idn2" select="substring(sf[@c='1'],4,10)"/>
	   (<xsl:value-of select="$idn2"/>)
        </xsl:if>
   </a> 
  </xsl:for-each>
 </xsl:for-each>
</xsl:template>


<!-- ==========================================	-->
<!--	contiene 462 e 463 			-->
<!-- ==========================================	-->
<xsl:template name="contiene462e463">

 <xsl:for-each select="df[@t=462]|df[@t=463]">
  <xsl:sort select="s1/df[@t=200]/sf[@c='v']" data-type="number"/>
  <xsl:variable name="idn" select="substring(s1/cf[@t='001'],1,10)"/>

 <xsl:for-each select="s1/df[@t=200]">
   &br1;
   <a><xsl:attribute name="href"><xsl:value-of select="$contextpath"/>/fcsearch?sf1=bid&amp;sv1=<xsl:value-of select="$idn"/></xsl:attribute>
    <xsl:attribute name="title">
   	<xsl:call-template name="translate">
   	<xsl:with-param name="section">traduzioni</xsl:with-param>
   	<xsl:with-param name="sigla">ricerca_notizie_titolo</xsl:with-param>
   	</xsl:call-template>
    </xsl:attribute>
	<xsl:if test="sf[@c='v'] and (sf[@c='v'] != substring(sf[@c='a'],1,1))"><xsl:value-of select="sf[@c='v']"/> : </xsl:if>
        <xsl:call-template name="titolo"/>
        <xsl:if test="sf[@c='1']">
	   <xsl:variable name="idn2" select="substring(sf[@c='1'],4,10)"/>
	   (<xsl:value-of select="$idn2"/>)
        </xsl:if>
   </a> 
  </xsl:for-each>
 </xsl:for-each>
</xsl:template>


<!-- ==========================================	-->
<!--	titolo per richiesta fascicolo		-->
<!-- ==========================================	-->
<xsl:template name="titolofasc">
 <xsl:for-each select="/rec/df[@t=200]">
  <xsl:variable name="ind" select="@i1"/>
    <xsl:for-each select="sf">
	<xsl:if test="@c='a'">
	  <xsl:if test="position() > 1"> ; </xsl:if>
          <xsl:call-template name="substDelim">
            <xsl:with-param name="string"><xsl:value-of select="."/></xsl:with-param>
          </xsl:call-template>
        </xsl:if>
	<xsl:if test="@c='e'"> : <xsl:value-of select="."/> </xsl:if>
	<xsl:if test="@c='i'"> = <xsl:value-of select="."/> </xsl:if>
	<xsl:if test="@c='c'"> . <xsl:value-of select="."/> </xsl:if>
	<xsl:if test="@c='f'"> / <xsl:value-of select="."/> </xsl:if>
	<xsl:if test="@c='g'"> ; <xsl:value-of select="."/> </xsl:if>
    </xsl:for-each>
 </xsl:for-each>
 <xsl:if test="/rec/df[@t=207]">. <xsl:value-of select="/rec/df[@t=207]/sf[@c='a']"/></xsl:if>
 <xsl:if test="/rec/df[@t=210]"> - <xsl:call-template name="edizione"/></xsl:if>
 <xsl:if test="/rec/df[@t=215]"> - <xsl:apply-templates select="/rec/df[@t=215]"/></xsl:if>
 <xsl:if test="/rec/df[@t=300]"> (<xsl:apply-templates select="/rec/df[@t=300]"/>)</xsl:if>
</xsl:template>


<!-- =========================================	-->
<!--	collocazione				-->
<!-- =========================================	-->
<xsl:template name="collocazione">
	 <xsl:param name="natura"/>
	 <xsl:param name="livello"/>

 <xsl:if test="df[@t=960] and (($natura='s') or ($livello='0') or ($livello='2' and not(/rec/df[@t=463])))">
   <xsl:call-template name="colloc960"/>
 </xsl:if>

 <xsl:if test="df[@t=950] and (($natura='s') or ($livello='0') or ($livello='2' and not(/rec/df[@t=463])))">
   <xsl:call-template name="colloc950"/>
 </xsl:if>
</xsl:template>

<!-- ========================================== -->
<!--  keys per raggruppamento			-->
<!-- ========================================== -->

<xsl:key name="group-by-codbib" match="df[@t=960]" use="substring(sf[@c='e'],1,2)"/>
<xsl:key name="group-by-colloc" match="df[@t=960]" use="concat(substring(sf[@c='e'],1,2),sf[@c='g'])"/>


<!-- ========================================== -->
<!--  colloc 960				-->
<!-- ========================================== -->

<xsl:template name="colloc960">
   &br1;
  <span><xsl:attribute name="class">collocazione</xsl:attribute>
   <!-- raggruppamento delle biblioteche -->
   <xsl:apply-templates mode="biblioteca-group"
	select="df[@t=960][generate-id(.)=generate-id(key('group-by-codbib',substring(sf[@c='e'],1,2))[1])]">
        <xsl:sort select="substring(sf[@c='e'],1,2)"/>
   </xsl:apply-templates>
   </span>
</xsl:template>


<!-- ========================================== -->
<!--   960 : raggruppamento delle biblioteche   -->
<!-- ========================================== -->

<xsl:template match="df[@t=960]" mode="biblioteca-group">

	<xsl:variable name="codbib" select="substring(sf[@c='e'],1,2)"/>
	<xsl:variable name="bibl" select="sf[@c='a']"/>
	<xsl:variable name="posa" select="position()"/>
  <table>
	<xsl:attribute name="border">0</xsl:attribute>
	<xsl:attribute name="width">100%</xsl:attribute>
	<xsl:attribute name="class">colloc</xsl:attribute>
   <tr>
	<td><xsl:attribute name="colspan">2</xsl:attribute>
	<b><xsl:value-of select="$bibl"/></b>

	<xsl:if test="$codbib='CF'">
	   <xsl:call-template name="msg_960_natura"/>
	</xsl:if>
	&br1;&br1;
	</td>
    </tr>

   <!-- raggruppamento delle collocazioni -->
   <xsl:apply-templates mode="colloc-group"
	select="key('group-by-codbib',substring(sf[@c='e'],1,2))[generate-id()=generate-id(key('group-by-colloc', concat(substring(sf[@c='e'],1,2),sf[@c='g']))[1])]">
        <xsl:sort select="sf[@c='g']"/>
   </xsl:apply-templates>
	<tr><td></td></tr>
  </table>
   <br/>

</xsl:template>


<!-- =========================================== -->
<!--   960 : raggruppamento delle collocazioni   -->
<!-- =========================================== -->

<xsl:template match="df[@t=960]" mode="colloc-group">

  <xsl:apply-templates select="sf[@c='g']">
	<xsl:with-param name="codbib" select="substring(sf[@c='e'],1,2)"/>
  </xsl:apply-templates>

</xsl:template>


<!-- ==================================================	-->
<!--	960$g : output della collocazione (generico)	-->
<!-- ==================================================	-->

<xsl:template match="df[@t=960]/sf[@c='g']">
	<xsl:param name="codbib"/>

   <xsl:variable name="coll" select="."/>
   <xsl:variable name="coll2" select="../sf[@c='f']"/>
   <xsl:variable name="collUC"
    select="translate($coll,'.abcdefghijklmnopqrstuvwxyz0123456789',' ABCDEFGHIJKLMNOPQRSTUVWXYZ##########')"/>
   <xsl:variable name="segn3" select="substring($collUC,1,3)"/>
<!-- controllo vecchio unimarc
   <xsl:variable name="ricman"><xsl:if test="($segn3='TDR') or ($segn3 = 'GF ')">1</xsl:if></xsl:variable>
-->
   <xsl:variable name="ricman"><xsl:if test="($segn3 = 'GF ')">1</xsl:if></xsl:variable>

	<tr>
		<td><xsl:attribute name="nowrap">1</xsl:attribute>
		            <xsl:call-template name="getColloc">
				<xsl:with-param name="codbib" select="$codbib"/>
				<xsl:with-param name="segn" select="$collUC"/>
		           </xsl:call-template>
		</td>
			<!-- segn3 = INF : Ufficio Informazioni -->
			<!-- Richiesta manuale -->
			<!-- Distribuzione -->
		<td><xsl:attribute name="width">90%</xsl:attribute>

		      <xsl:choose>
		      <xsl:when test="$segn3 = 'INF'">
         	<xsl:call-template name="translate">
         	<xsl:with-param name="section">traduzioni</xsl:with-param>
         	<xsl:with-param name="sigla">ufficio_informazioni</xsl:with-param>
         	</xsl:call-template>
				<xsl:value-of select="substring($coll,4,string-length($coll)-3)"/></xsl:when>
		      <xsl:otherwise><xsl:value-of select="$coll"/></xsl:otherwise>
		      </xsl:choose>

		      <xsl:if test="$ricman = 1"> (<xsl:call-template name="translate"><xsl:with-param name="section">traduzioni</xsl:with-param><xsl:with-param name="sigla">richiesta manuale</xsl:with-param></xsl:call-template>)</xsl:if>
		
		      <xsl:if test="$codbib = 'CF'">
			<xsl:call-template name="getDistrib">
				<xsl:with-param name="tipo" select="$collUC"/>
			</xsl:call-template>
		      </xsl:if>
		      <xsl:if test="$coll2"> (<xsl:call-template name="trim">
  			<xsl:with-param name="string" select="$coll2"/></xsl:call-template>)</xsl:if>
		</td>
	</tr>

   <xsl:variable name="natura" select="substring(/rec/lab,8,1)"/>

   <!-- periodico -->
   <xsl:if test="$natura = 's'">
	<xsl:apply-templates select="." mode="periodico">
		<xsl:with-param name="codbib" select="$codbib"/>
		<xsl:with-param name="collUC" select="$collUC"/>
	</xsl:apply-templates>
   </xsl:if>

   <!-- monografia -->
   <xsl:if test="$natura = 'm'">
	<xsl:apply-templates mode="monografia"
		   select="key('group-by-colloc',concat(substring(../sf[@c='e'],1,2),.))/sf[@c='e']">
	</xsl:apply-templates>
   </xsl:if>

</xsl:template>


<!-- ==================================================	-->
<!--	960$g : output della collocazione  (periodico)	-->
<!-- ==================================================	-->

<xsl:template match="df[@t=960]/sf[@c='g']" mode="periodico">
	<xsl:param name="codbib"/>
	<xsl:param name="collUC"/>
   <xsl:variable name="segn3" select="substring($collUC,1,3)"/>
   <xsl:variable name="segn4" select="substring($collUC,1,4)"/>
   <xsl:variable name="ricman"><xsl:if test="($codbib!='CF') or ($segn3='TDR') or ($segn3 = 'GF ') or ($segn4='CONS') or ($segn4='S M ') or ($segn4='S L ') or ($segn4='F ST')">1</xsl:if></xsl:variable>

   <xsl:variable name="pos" select="count(../preceding-sibling::*)"/>

	<!-- annate possedute -->
	<tr>
		<td><xsl:attribute name="nowrap">1</xsl:attribute>
         	<xsl:call-template name="translate">
         	<xsl:with-param name="section">traduzioni</xsl:with-param>
         	<xsl:with-param name="sigla">annate_possedute</xsl:with-param>
         	</xsl:call-template>
		</td>
		<td>
		   <xsl:choose>
		   <xsl:when test="$ricman=1"><xsl:value-of select="../sf[@c='b']"/></xsl:when>
		   <xsl:otherwise>
			<xsl:call-template name="getRichiestaLinkAnnate">
				<xsl:with-param name="label" select="../sf[@c='b']"/>
			</xsl:call-template>
		   </xsl:otherwise>
		   </xsl:choose>
		</td>
	</tr>
	<!-- annate possedute // -->


	<!-- Dettaglio annate -->
	<xsl:variable name="dettid">dettaglio<xsl:value-of select="$pos"/></xsl:variable>
	<tr>
		<td><xsl:attribute name="colspan">2</xsl:attribute>
		<a> <xsl:attribute name="href"
			>javascript:ExpandCollapse('<xsl:value-of select="$dettid"/>')</xsl:attribute>
			<xsl:attribute name="title">
         	<xsl:call-template name="translate">
         	<xsl:with-param name="section">traduzioni</xsl:with-param>
         	<xsl:with-param name="sigla">apri_box_dettaglio_annate</xsl:with-param>
         	</xsl:call-template>
         </xsl:attribute>
			<img>
			<xsl:attribute name="align">absmiddle</xsl:attribute>
			<xsl:attribute name="hspace">2</xsl:attribute>
			<xsl:attribute name="id"><xsl:value-of select="$dettid"/>_img</xsl:attribute>
			<xsl:attribute name="src"><xsl:value-of select="$contextpath"/>/img/folderclose.gif</xsl:attribute>
			</img>
         	<xsl:call-template name="translate">
         	<xsl:with-param name="section">traduzioni</xsl:with-param>
         	<xsl:with-param name="sigla">dettaglio_annate</xsl:with-param>
         	</xsl:call-template>
		</a>
		</td>
	</tr>

	<tr>
		<xsl:attribute name="id"><xsl:value-of select="$dettid"/></xsl:attribute>
		<xsl:attribute name="style">display:none</xsl:attribute>
		<td>&br1;</td>
		<td>
			<xsl:if test="/rec/df[@t=961]">
				<xsl:call-template name="getAbbo961">
					<xsl:with-param name="codbib" select="$codbib"/>
				</xsl:call-template>
			</xsl:if>
			<xsl:apply-templates mode="periodico"
			   select="key('group-by-colloc',concat(substring(../sf[@c='e'],1,2),.))/sf[@c='e']">
			</xsl:apply-templates>
		</td>
	</tr>
	<xsl:if test="/rec/df[@t=961] and (($codbib = 'CF')or($codbib = 'MF'))">
	<tr><td></td></tr>
	<tr>
		<td>Visualizza fascicoli:</td>
		<td>
			<xsl:call-template name="getLinkFascicoli">
				<xsl:with-param name="codbib" select="$codbib"/>
			</xsl:call-template>
		</td>
	</tr>
	</xsl:if>
	<!-- stacco fre le collocazioni -->
	<tr><td></td></tr>
	<tr><td></td></tr>
 
</xsl:template>


<!-- ==========================================================	-->
<!--   composizione dell'inventario normalizzato (periodico)	-->
<!-- ========================================================== -->
<xsl:template match="df[@t=960]/sf[@c='e']" mode="normalizzatoSer">
 <xsl:variable name="codbib" select="substring(.,1,2)"/> 
 <xsl:variable name="ser2" select="substring(.,3,2)"/> 
 <xsl:variable name="codserie">
	<xsl:choose>
		<xsl:when test="$ser2='  '">00</xsl:when>
		<xsl:otherwise><xsl:value-of select="$ser2"/></xsl:otherwise>
	</xsl:choose>
 </xsl:variable>
 <xsl:value-of select="$codserie"/><xsl:value-of select="substring(.,8,7)"/>
</xsl:template>


<!-- ==========================================================	-->
<!--   composizione dell'inventario normalizzato (monografia)	-->
<!-- ========================================================== -->
<xsl:template match="df[@t=960]/sf[@c='e']" mode="normalizzatoMono">
 <xsl:variable name="codbib" select="substring(.,1,2)"/> 
 <xsl:variable name="ser2" select="substring(.,3,2)"/> 
 <xsl:variable name="codserie">
	<xsl:choose>
		<xsl:when test="$ser2='  '">00</xsl:when>
		<xsl:otherwise><xsl:value-of select="$ser2"/></xsl:otherwise>
	</xsl:choose>
 </xsl:variable>
 <xsl:value-of select="$codserie"/><xsl:value-of select="substring(.,8,7)"/>
</xsl:template>


<!-- ==========================================================	-->
<!--   composizione del Link per la richiesta delle annate	-->
<!-- ========================================================== -->

<xsl:template name="getRichiestaLinkAnnate">
	<xsl:param name="label"/>

	<xsl:variable name="bid" select="substring(/rec/cf[@t='001'],1,10)"/>
	<xsl:variable name="annoed" select="translate(/rec/df[@t='210']/sf[@c='d'],'[] -.','')"/>
	<xsl:variable name="tit0"><xsl:apply-templates select="/rec/df[@t=200]"/></xsl:variable>

	<xsl:variable name="tit"><xsl:call-template name="getMaxString">
		<xsl:with-param name="text" select="$tit0"/>
		<xsl:with-param name="maxlen" select="40"/></xsl:call-template>
	</xsl:variable>
	<xsl:variable name="aut"><xsl:call-template name="autore_breve"/></xsl:variable>
	<xsl:variable name="richinv"><xsl:apply-templates mode="normalizzatoSer"
				select="preceding-sibling::sf[@c='e'][1]"/></xsl:variable>

<!--
  <a><xsl:attribute name="title">Cliccare per richiedere le annate</xsl:attribute><xsl:attribute name="href">http://richiestev2.bncf.lan/richieste/Servlet/Pubblica?BIB=%20CF&amp;amp;INV=1%20%20<xsl:value-of select="$richinv"/>&amp;amp;AUTO=Y&amp;amp;BID=<xsl:value-of select="$bid"/><xsl:if test="$annoed">&amp;amp;NAT=S&amp;amp;ANNO=<xsl:value-of select="$annoed"/></xsl:if>&amp;amp;<xsl:if test="not($aut='')">AUT=<xsl:value-of select="$aut"/>&amp;amp;</xsl:if>TIT=<xsl:value-of select="$tit"/></xsl:attribute><xsl:value-of select="$label"/></a>
-->
  <a><xsl:attribute name="title">
   	<xsl:call-template name="translate">
   	<xsl:with-param name="section">traduzioni</xsl:with-param>
   	<xsl:with-param name="sigla">cliccare_richiedere_annate</xsl:with-param>
   	</xsl:call-template>
     </xsl:attribute>
     <xsl:attribute name="href">http://servizi.bncf.firenze.sbn.it/richieste/Servlet/Pubblica?BIB=%20CF&amp;amp;INV=1%20%20<xsl:value-of select="$richinv"/>&amp;amp;AUTO=Y&amp;amp;BID=<xsl:value-of select="$bid"/><xsl:if test="$annoed">&amp;amp;NAT=S&amp;amp;ANNO=<xsl:value-of select="$annoed"/></xsl:if>&amp;amp;<xsl:if test="not($aut='')">AUT=<xsl:value-of select="$aut"/>&amp;amp;</xsl:if>TIT=<xsl:value-of select="$tit"/></xsl:attribute><xsl:value-of select="$label"/>
  </a>

<!--
 <xsl:otherwise><a><xsl:attribute name="title">Clicca per richiedere il documento</xsl:attribute><xsl:attribute name="href">http://servizi.bncf.firenze.sbn.it/richieste/Servlet/Pubblica?BIB=%20<xsl:value-of select="$bib"/>&amp;amp;INV=1%20%20<xsl:value-of select="$inv"/>&amp;amp;AUTO=Y&amp;amp;BID=<xsl:value-of select="$bid"/><xsl:if test="$annoed">&amp;amp;NAT=M&amp;amp;ANNO=<xsl:value-of select="$annoed"/></xsl:if>&amp;amp;AUT=<xsl:call-template name="autore_breve"/>&amp;amp;TIT=<xsl:value-of select="$tit"/></xsl:attribute><xsl:value-of select="$invm"/><xsl:if test="$anno">&nbsp;&nbsp;<xsl:value-of select="$anno"/></xsl:if></a>
-->

</xsl:template>

<!-- ==================================================	-->
<!--	960$e : output dell'inventario (monografia)	-->
<!-- ==================================================	-->

<xsl:template match="df[@t=960]/sf[@c='e']" mode="monografia">

	<xsl:variable name="codbib" select="substring(.,1,2)"/> 
	<xsl:variable name="ser2" select="substring(.,3,2)"/> 
	<xsl:variable name="disp" select="substring(.,45,2)"/> 
	<xsl:variable name="codserie">
		<xsl:choose>
			<xsl:when test="$ser2='  '">00</xsl:when>
			<xsl:otherwise><xsl:value-of select="$ser2"/></xsl:otherwise>
		</xsl:choose>
	</xsl:variable>
	<xsl:variable name="invm"><xsl:value-of select="$codbib"/><xsl:value-of select="$codserie"/><xsl:value-of select="substring(.,8,7)"/>&nbsp;&nbsp;<xsl:value-of select="substring(.,54)"/></xsl:variable>

	<tr>
		<td>
   	<xsl:call-template name="translate">
   	<xsl:with-param name="section">traduzioni</xsl:with-param>
   	<xsl:with-param name="sigla">inventario</xsl:with-param>
   	</xsl:call-template>:
      &nbsp;</td>
		<td>
 <xsl:choose>
  <xsl:when test="$codbib='CF'">
      <xsl:choose>
	<!-- inventario cliccabile -->
	<xsl:when test="$disp='  '">
			<xsl:call-template name="getRichiestaLinkMonografia">
				<xsl:with-param name="codbib" select="$codbib"/>
				<xsl:with-param name="invm" select="$invm"/>
			</xsl:call-template>
	</xsl:when>
	<!-- inventario NON cliccabile (CF) -->
	<xsl:otherwise>
   	<xsl:call-template name="inventarioDispCF">
   	<xsl:with-param name="disp" select="$disp" />
   	<xsl:with-param name="invm" select="$invm"/>
   	</xsl:call-template>
	</xsl:otherwise>
      </xsl:choose>
  </xsl:when>
  <xsl:otherwise><xsl:value-of select="$invm"/>
  </xsl:otherwise>
 </xsl:choose>
		</td>
	</tr>

</xsl:template>


<!-- ==========================================================	-->
<!--   composizione del Link per la richiesta della monografia	-->
<!-- ========================================================== -->

<xsl:template name="getRichiestaLinkMonografia">
	<xsl:param name="codbib"/>
	<xsl:param name="invm"/>

	<xsl:variable name="annoed" select="translate(/rec/df[@t='210']/sf[@c='d'],'[].','')"/>

	<xsl:variable name="tit0"><xsl:apply-templates select="/rec/df[@t=200]"/></xsl:variable>
	<xsl:variable name="tit"><xsl:call-template name="getMaxString">
		<xsl:with-param name="text" select="$tit0"/>
		<xsl:with-param name="maxlen" select="40"/></xsl:call-template>
	</xsl:variable>
	<xsl:variable name="bid" select="substring(/rec/cf[@t='001'],1,10)"/>
	<xsl:variable name="inv" select="substring(.,8,7)"/>
	<xsl:variable name="richinv"><xsl:apply-templates select="." mode="normalizzatoMono"/></xsl:variable>

<!--
  <a><xsl:attribute name="title">Clicca per richiedere il documento</xsl:attribute><xsl:attribute name="href">http://richiestev2.bncf.lan/richieste/Servlet/Pubblica?BIB=%20<xsl:value-of select="$codbib"/>&amp;amp;INV=1%20%20<xsl:value-of select="$richinv"/>&amp;amp;AUTO=Y&amp;amp;BID=<xsl:value-of select="$bid"/><xsl:if test="$annoed">&amp;amp;NAT=M&amp;amp;ANNO=<xsl:value-of select="$annoed"/></xsl:if>&amp;amp;AUT=<xsl:call-template name="autore_breve"/>&amp;amp;TIT=<xsl:value-of select="$tit"/></xsl:attribute><xsl:value-of select="$invm"/></a>
-->
  <a><xsl:attribute name="title">
   	<xsl:call-template name="translate">
   	<xsl:with-param name="section">traduzioni</xsl:with-param>
   	<xsl:with-param name="sigla">cliccare_richiedere_documento</xsl:with-param>
   	</xsl:call-template>
  </xsl:attribute><xsl:attribute name="href">http://servizi.bncf.firenze.sbn.it/richieste/Servlet/Pubblica?BIB=%20<xsl:value-of select="$codbib"/>&amp;amp;INV=1%20%20<xsl:value-of select="$richinv"/>&amp;amp;AUTO=Y&amp;amp;BID=<xsl:value-of select="$bid"/><xsl:if test="$annoed">&amp;amp;NAT=M&amp;amp;ANNO=<xsl:value-of select="$annoed"/></xsl:if>&amp;amp;AUT=<xsl:call-template name="autore_breve"/>&amp;amp;TIT=<xsl:value-of select="$tit"/></xsl:attribute><xsl:value-of select="$invm"/></a>

</xsl:template>


<!-- ========================================== -->
<!--  colloc 950 (deprecated)			-->
<!-- ========================================== -->

<xsl:template name="colloc950">
    <xsl:variable name="natura" select="substring(/rec/lab,8,1)"/>
&br1;
  <span><xsl:attribute name="class">collocazione</xsl:attribute>

 <xsl:for-each select="df[@t=950]/sf[@c='a']">

	<xsl:variable name="bibl" select="."/>
	<xsl:variable name="posa" select="position()"/>
	<xsl:variable name="bibnaz">
	<xsl:choose>
	  <xsl:when test="$bibl='Bibl. Nazionale Centrale di Firenze'">1</xsl:when>
	  <xsl:when test="$bibl='Bibl. Nazionale Centrale Firenze'">1</xsl:when>
	  <xsl:otherwise>0</xsl:otherwise>
	</xsl:choose>
	</xsl:variable>

 <table>
	<xsl:attribute name="border">0</xsl:attribute>
	<xsl:attribute name="width">100%</xsl:attribute>
	<xsl:attribute name="class">colloc</xsl:attribute>
  <tr>
	<td><xsl:attribute name="colspan">2</xsl:attribute>
	<b><xsl:value-of select="$bibl"/></b>

     <xsl:if test="$bibnaz = 1">
<span><xsl:attribute name="class">avv</xsl:attribute>
&br1;
<xsl:choose>
 <xsl:when test="$natura = 'm'">
   	<xsl:call-template name="colloc950naturam"></xsl:call-template>
</xsl:when>
<xsl:when test="$natura = 's'">
   	<xsl:call-template name="colloc950naturam"></xsl:call-template>
</xsl:when>
</xsl:choose>
</span>
     </xsl:if>&br1;&br1;
    </td></tr>

  <xsl:for-each select="following-sibling::sf[@c='f']">

  <xsl:variable name="coll" select="."/>
  <xsl:variable name="collUC">
   <xsl:call-template name="compactSpace">
     <xsl:with-param name="string">
	<xsl:call-template name="trim">
	  <xsl:with-param name="string" select="translate($coll,'.abcdefghijklmnopqrstuvwxyz0123456789',' ABCDEFGHIJKLMNOPQRSTUVWXYZ##########')"/>
	</xsl:call-template>
     </xsl:with-param>
    </xsl:call-template>
  </xsl:variable>

    <xsl:variable name="segn2" select="substring($collUC,1,2)"/>
    <xsl:variable name="segn3" select="substring($collUC,1,3)"/>
    <xsl:variable name="segn4" select="substring($collUC,1,4)"/>
    <xsl:variable name="ricman">
      <xsl:if test="($segn3='TDR') or ($segn3 = 'GF ')">1</xsl:if>
    </xsl:variable>

    <tr><td><xsl:attribute name="nowrap">1</xsl:attribute>

      <xsl:choose>
       <xsl:when test="$bibnaz = 1">
         <xsl:variable name="colloc">
            <xsl:call-template name="getColloc1">
		<xsl:with-param name="segn" select="$collUC"/>
           </xsl:call-template>
         </xsl:variable>
	 <xsl:value-of select="$colloc"/>
       </xsl:when>
       <xsl:otherwise>Collocazione:</xsl:otherwise>
      </xsl:choose>

    </td><td><xsl:attribute name="width">90%</xsl:attribute>

      <xsl:choose>
      <xsl:when test="$segn3 = 'INF'">
   	<xsl:call-template name="translate">
   	<xsl:with-param name="section">traduzioni</xsl:with-param>
   	<xsl:with-param name="sigla">ufficio_informazioni</xsl:with-param>
   	</xsl:call-template>:
      <xsl:value-of select="substring($coll,4,string-length($coll)-3)"/></xsl:when>
      <xsl:otherwise><xsl:value-of select="$coll"/></xsl:otherwise>
      </xsl:choose>
      <xsl:if test="$ricman = 1"> (<xsl:call-template name="translate"><xsl:with-param name="section">traduzioni</xsl:with-param><xsl:with-param name="sigla">richiesta_manuale</xsl:with-param></xsl:call-template>)</xsl:if>
      <xsl:if test="$bibnaz = 1">
         <xsl:variable name="distrib">
            <xsl:call-template name="getDistrib">
		<xsl:with-param name="tipo" select="$collUC"/>
           </xsl:call-template>
         </xsl:variable>
	 <xsl:if test="$distrib != ''">
	  (<i><xsl:value-of select="$distrib"/></i>) 
	 </xsl:if>
      </xsl:if> <!-- bibnaz=1 -->
     </td>
    </tr>
   <xsl:if test="$natura = 's'">
	<!-- annate possedute -->
 
    <tr>
     <xsl:if test="$bibnaz = 1">
      <td><xsl:attribute name="nowrap">1</xsl:attribute>
      <xsl:variable name="bid" select="substring(/rec/cf[@t='001'],1,10)"/>

<!-- <a><xsl:attribute name="href">http://catalogo.bncf.firenze.sbn.it/cgi-opac/carica/carica.cgi?BIB=%20<xsl:value-of select="$bib"/>&amp;amp;INV=1%20%20<xsl:value-of select="$inv"/>&amp;amp;AUTO=Y&amp;amp;BID=<xsl:value-of select="$bid"/><xsl:if test="$annoed">&amp;amp;NAT=M&amp;amp;ANNO=<xsl:value-of select="$annoed"/></xsl:if>&amp;amp;AUT=<xsl:call-template name="autore_breve"/>&amp;amp;TIT=<xsl:value-of select="$tit"/></xsl:attribute><xsl:value-of select="$invm"/><xsl:if test="$anno">&nbsp;&nbsp;<xsl:value-of select="$anno"/></xsl:if></a> -->


  <xsl:variable name="annoed" select="translate(/rec/df[@t='210']/sf[@c='d'],'[] -.','')"/>
  <xsl:variable name="tit0"><xsl:apply-templates select="/rec/df[@t=200]"/></xsl:variable>
  <xsl:variable name="tit">
    <xsl:variable  name="titlen" select="string-length($tit0)"/>
    <xsl:choose>
      <xsl:when test="$titlen > 40"><xsl:value-of select="substring($tit0,1,40)"/>...</xsl:when>
      <xsl:otherwise><xsl:value-of select="$tit0"/></xsl:otherwise>
    </xsl:choose>
  </xsl:variable>
  <xsl:variable name="bid" select="substring(/rec/cf[@t='001'],1,10)"/>
  <xsl:variable name="aut"><xsl:call-template name="autore_breve"/></xsl:variable>

<!--
       <a><xsl:attribute name="title">Cliccare per richiedere le annate</xsl:attribute><xsl:attribute name="href">http://193.206.206.159:8082/richieste/Servlet/Pubblica?BIB=%20CF&amp;amp;INV=1%20%20<xsl:value-of select="substring(.,3,8)"/>&amp;amp;AUTO=Y&amp;amp;BID=<xsl:value-of select="$bid"/><xsl:if test="$annoed">&amp;amp;NAT=S&amp;amp;ANNO=<xsl:value-of select="$annoed"/></xsl:if>&amp;amp;<xsl:if test="not($aut='')">AUT=<xsl:value-of select="$aut"/>&amp;amp;</xsl:if>TIT=<xsl:value-of select="$tit"/></xsl:attribute>Annate&nbsp;possedute:&nbsp;</a>
-->

  <xsl:variable name="richinv" select="substring(preceding-sibling::sf[@c='e'][1],3,9)"/>
  <xsl:choose>
   <xsl:when test="$ricman = 1">
   	<xsl:call-template name="translate">
   	<xsl:with-param name="section">traduzioni</xsl:with-param>
   	<xsl:with-param name="sigla">annate_possedute</xsl:with-param>
   	</xsl:call-template>:
   </xsl:when>
   <xsl:when test="contains($segn4,'CONS') or contains($segn4,'S M ') or contains($segn4,'S L ') or contains($segn4,'F ST')"><xsl:call-template name="translate"><xsl:with-param name="section">traduzioni</xsl:with-param><xsl:with-param name="sigla">annate_possedute</xsl:with-param></xsl:call-template>::&nbsp;</xsl:when>
   <xsl:otherwise>
      <a>
      <xsl:attribute name="title">
   	<xsl:call-template name="translate">
   	<xsl:with-param name="section">traduzioni</xsl:with-param>
   	<xsl:with-param name="sigla">cliccare_richiedere_annate</xsl:with-param>
   	</xsl:call-template>
      </xsl:attribute>
      <xsl:attribute name="href">http://servizi.bncf.firenze.sbn.it/richieste/Servlet/Pubblica?BIB=%20CF&amp;amp;INV=1%20%20<xsl:value-of select="$richinv"/>&amp;amp;AUTO=Y&amp;amp;BID=<xsl:value-of select="$bid"/><xsl:if test="$annoed">&amp;amp;NAT=S&amp;amp;ANNO=<xsl:value-of select="$annoed"/></xsl:if>&amp;amp;<xsl:if test="not($aut='')">AUT=<xsl:value-of select="$aut"/>&amp;amp;</xsl:if>TIT=<xsl:value-of select="$tit"/></xsl:attribute><xsl:call-template name="translate"><xsl:with-param name="section">traduzioni</xsl:with-param><xsl:with-param name="sigla">annate_possedute</xsl:with-param></xsl:call-template>::&nbsp;
      </a>
   </xsl:otherwise>
  </xsl:choose>

</td>
      </xsl:if><!-- bibnaz = 1 -->

      <xsl:if test="$bibnaz != 1">
      <td><xsl:attribute name="nowrap">1</xsl:attribute><xsl:call-template name="translate"><xsl:with-param name="section">traduzioni</xsl:with-param><xsl:with-param name="sigla">annate_possedute</xsl:with-param></xsl:call-template>:</td>
      </xsl:if>

   <td>
    <xsl:variable name="annateposs1">
    <xsl:for-each
     select="preceding-sibling::sf[@c='b'][count(following-sibling::sf[@c='f'][1]|$coll) = 1]">
        <xsl:value-of select="."/>&br1;
    </xsl:for-each>
    </xsl:variable>

    <xsl:variable name="annateposs">
     <xsl:choose>
      <xsl:when test="$annateposs1 != ''"><xsl:value-of select="$annateposs1"/></xsl:when>
      <xsl:otherwise><xsl:value-of select="preceding-sibling::sf[@c='b']"/>&br1;</xsl:otherwise>
     </xsl:choose>
    </xsl:variable>
    <xsl:value-of select="$annateposs"/>
   </td>
  </tr>
 <!-- </xsl:if> --> <!-- annate possedute -->



    <!-- Dettaglio annate -->
   <xsl:variable name="pos"><xsl:value-of select="$posa"/><xsl:value-of select="position()"/></xsl:variable>
   <tr>
    <td><xsl:attribute name="colspan">2</xsl:attribute>
      <a><xsl:attribute name="href">javascript:ExpandCollapse('dettagli<xsl:value-of select="$pos"/>')</xsl:attribute>
      <xsl:attribute name="title">
     	<xsl:call-template name="translate">
     	<xsl:with-param name="section">traduzioni</xsl:with-param>
     	<xsl:with-param name="sigla">apri_box_dettaglio_annate</xsl:with-param>
     	</xsl:call-template>
      </xsl:attribute>
	<img>
	<xsl:attribute name="align">absmiddle</xsl:attribute>
	<xsl:attribute name="hspace">2</xsl:attribute>
	<xsl:attribute name="id">dettagli<xsl:value-of select="$pos"/>_img</xsl:attribute>
	<xsl:attribute name="src"><xsl:value-of select="$contextpath"/>/img/folderclose.gif</xsl:attribute></img><xsl:call-template name="translate"><xsl:with-param name="section">traduzioni</xsl:with-param><xsl:with-param name="sigla">dettaglio_annate</xsl:with-param></xsl:call-template>
	</a>
    </td>
   </tr>


    <tr><xsl:attribute name="id">dettagli<xsl:value-of select="$pos"/></xsl:attribute>
	<xsl:attribute name="style">display:none</xsl:attribute>
     <td>&br1;</td><td>
    <xsl:if test="/rec/df[@t=951]">
	<xsl:call-template name="getAbbo951">
		<xsl:with-param name="bib" select="$bibl"/>
	</xsl:call-template>
        <br/>
    </xsl:if>
     <xsl:for-each
     select="preceding-sibling::sf[@c='e'][count(following-sibling::sf[@c='f'][1]|$coll) = 1]">

	<xsl:variable name="anno" select="substring(.,33)"/> 
	<xsl:variable name="cfe" select="substring(/rec/df[@t=951]/sf[@c='b'],1,8)"/>
	<xsl:variable name="inv" select="substring(.,3,9)"/>
	<xsl:variable name="bib" select="substring(.,1,2)"/>
	<xsl:variable name="strarg"><xsl:call-template name="titolofasc"/></xsl:variable>

      <xsl:if test="$bibnaz = 1">
<!--
	<a><xsl:attribute name="href">http://catalogo.bncf.firenze.sbn.it/cgi-opac/schedbib/fascicoli.pl?biblio=<xsl:value-of select="/rec/cf[@t=001]"/>&amp;amp;anno=<xsl:value-of select="$cfe"/><xsl:value-of select="$anno"/><xsl:value-of select="$inv"/>&amp;amp;isbd=<xsl:value-of select="java_net:URLEncoder.encode($strarg)"/>&amp;amp;Lingua=ITA&amp;amp;unicode=&amp;amp;biblioteca=<xsl:value-of select="java_net:URLEncoder.encode($bibl)"/></xsl:attribute>    <xsl:attribute name="title">Vai al documento</xsl:attribute><xsl:value-of select="$anno"/></a>
-->
	<xsl:value-of select="$anno"/>
      </xsl:if>
      <xsl:if test="$bibnaz != 1">
	<xsl:value-of select="$anno"/>
      </xsl:if>
	&br1;
    </xsl:for-each>

    <xsl:if test="position() = last()">
      <xsl:for-each
       select="following-sibling::sf[@c='e'][count(preceding-sibling::sf[@c='f'][1]|$coll)= 1]">
	<xsl:variable name="anno" select="substring(.,33)"/> 
	<xsl:variable name="cfe" select="substring(/rec/df[@t=951]/sf[@c='b'],1,8)"/>
	<xsl:variable name="inv" select="substring(.,3,9)"/>
	<xsl:variable name="bib" select="substring(.,1,2)"/>
	<xsl:variable name="strarg"><xsl:call-template name="titolofasc"/></xsl:variable>

	<xsl:value-of select="$anno"/> 
	&br1;
      </xsl:for-each>
    </xsl:if>
    </td></tr>
    <xsl:if test="position() != last()">
    <tr><td>&br1;</td><td>&br1;</td></tr>
    </xsl:if>

 
   </xsl:if> <!-- natura = 's' -->
 

    <xsl:if test="$natura = 'm'">
    <xsl:for-each
     select="preceding-sibling::sf[@c='e'][count(following-sibling::sf[@c='f'][1]|$coll) = 1]">

	<xsl:variable name="anno" select="substring(.,33)"/> 
	<xsl:variable name="cfe" select="substring(/rec/df[@t=951]/sf[@c='b'],1,8)"/>
	<xsl:variable name="inv" select="substring(.,3,9)"/>
	<xsl:variable name="invm" select="substring(.,1,11)"/>
	<xsl:variable name="bib" select="substring(.,1,2)"/>
	<xsl:variable name="strarg"><xsl:call-template name="titolofasc"/></xsl:variable>

	<xsl:variable name="type" select="substring(.,12,1)"/> 
	<xsl:variable name="displim">
	   <xsl:choose>
	     <xsl:when test="not($type)">1</xsl:when> 
	     <xsl:when test="$type=1 or $type=2 or $type=3">1</xsl:when> 
	     <xsl:otherwise>0</xsl:otherwise> 
	   </xsl:choose>
	</xsl:variable>

      <tr><td>
     	<xsl:call-template name="translate">
     	<xsl:with-param name="section">traduzioni</xsl:with-param>
     	<xsl:with-param name="sigla">inventario</xsl:with-param>
     	</xsl:call-template>:&nbsp;
      </td><td>

      <xsl:choose>
       <xsl:when test="contains($segn4,'CONS') or contains($segn4,'S M ') or contains($segn4,'S L ') or contains($segn4,'F ST')">
         <xsl:value-of select="$invm"/>&nbsp;&nbsp;<xsl:value-of select="$anno"/>
       </xsl:when>

       <xsl:when test="($type = '5') or ($type = '6') or ($type = '4') or not($type)">
	 <xsl:choose>
	   <xsl:when test="$ricman = 1">
		<xsl:value-of select="$invm"/>&nbsp;&nbsp;<xsl:value-of select="$anno"/>
	   </xsl:when>
	   <xsl:otherwise>
		<xsl:if test="$displim != 1">

		  <xsl:if test="$bibnaz = 1">
                     <xsl:variable name="annoed" select="translate(/rec/df[@t='210']/sf[@c='d'],'[].','')"/>
                     <xsl:variable name="tit0"><xsl:apply-templates select="/rec/df[@t=200]"/></xsl:variable>
		     <xsl:variable name="tit">
			 <xsl:variable  name="titlen" select="string-length($tit0)"/>
			 <xsl:choose>
			  <xsl:when test="$titlen > 40"><xsl:value-of select="substring($tit0,1,40)"/>...</xsl:when>
			  <xsl:otherwise><xsl:value-of select="$tit0"/></xsl:otherwise>
			 </xsl:choose>
		     </xsl:variable>
                     <xsl:variable name="bid" select="substring(/rec/cf[@t='001'],1,10)"/>

	<xsl:choose>
	<xsl:when test="$segn3 = 'INF'">
	<xsl:value-of select="$invm"/><xsl:if test="$anno">&nbsp;&nbsp;<xsl:value-of select="$anno"/></xsl:if>
	</xsl:when>
	<xsl:otherwise>
    <a>
      <xsl:attribute name="title">
     	<xsl:call-template name="translate">
     	<xsl:with-param name="section">traduzioni</xsl:with-param>
     	<xsl:with-param name="sigla">cliccare_richiedere_documento</xsl:with-param>
     	</xsl:call-template>
      </xsl:attribute>
      <xsl:attribute name="href">http://servizi.bncf.firenze.sbn.it/richieste/Servlet/Pubblica?BIB=%20<xsl:value-of select="$bib"/>&amp;amp;INV=1%20%20<xsl:value-of select="$inv"/>&amp;amp;AUTO=Y&amp;amp;BID=<xsl:value-of select="$bid"/><xsl:if test="$annoed">&amp;amp;NAT=M&amp;amp;ANNO=<xsl:value-of select="$annoed"/></xsl:if>&amp;amp;AUT=<xsl:call-template name="autore_breve"/>&amp;amp;TIT=<xsl:value-of select="$tit"/></xsl:attribute><xsl:value-of select="$invm"/><xsl:if test="$anno">&nbsp;&nbsp;<xsl:value-of select="$anno"/></xsl:if>
    </a>
	</xsl:otherwise>
	</xsl:choose>


		  </xsl:if><!-- bibnaz == 1 -->
		  <xsl:if test="$bibnaz != 1">
		     <xsl:value-of select="$invm"/><xsl:if test="$anno">&nbsp;&nbsp;<xsl:value-of select="$anno"/></xsl:if>
		  </xsl:if>
		</xsl:if><!-- displim != 1 -->

		<xsl:if test="$displim = 1">
		  <xsl:value-of select="$invm"/><xsl:if test="$anno">&nbsp;&nbsp;<xsl:value-of select="$anno"/></xsl:if>
      (<a><xsl:attribute name="href">inlavorazione.jsp</xsl:attribute><xsl:call-template name="translate"><xsl:with-param name="section">traduzioni</xsl:with-param><xsl:with-param name="sigla">disponibilita_limitata</xsl:with-param></xsl:call-template></a>)
		</xsl:if>

	   </xsl:otherwise>
	 </xsl:choose>
	</xsl:when>

	<xsl:when test="$type = 'A'">
		<xsl:value-of select="$invm"/>&nbsp;&nbsp;<xsl:value-of select="$anno"/><xsl:call-template name="translate"><xsl:with-param name="section">traduzioni</xsl:with-param><xsl:with-param name="sigla">mancante</xsl:with-param></xsl:call-template>
	</xsl:when>
	 <xsl:when test="$type = 'B'">
			<xsl:value-of select="$invm"/>&nbsp;&nbsp;<xsl:value-of select="$anno"/>
			&nbsp;(<xsl:value-of select="following-sibling::sf[@c='g'][1]"/>)
	</xsl:when>
	<xsl:otherwise>
		<xsl:choose>
		<xsl:when test="$bibnaz = 1">
		   (<a>
          <xsl:attribute name="href">inlavorazione.jsp</xsl:attribute>
          <xsl:attribute name="title">
            <xsl:call-template name="translate"><xsl:with-param name="section">traduzioni</xsl:with-param><xsl:with-param name="sigla">richiedi_il_documento</xsl:with-param></xsl:call-template>
          </xsl:attribute><xsl:call-template name="translate"><xsl:with-param name="section">traduzioni</xsl:with-param><xsl:with-param name="sigla">disponibilita_limitata</xsl:with-param></xsl:call-template>
        </a>)
		</xsl:when>
		<xsl:otherwise>(<xsl:call-template name="translate"><xsl:with-param name="section">traduzioni</xsl:with-param><xsl:with-param name="sigla">disponibilita_limitata</xsl:with-param></xsl:call-template>)</xsl:otherwise>
		</xsl:choose>
	</xsl:otherwise>
      </xsl:choose>
	&br1;
	</td></tr>
    </xsl:for-each>
   </xsl:if> <!-- natura = m -->


  </xsl:for-each>
  </table>
  <xsl:if test="position() != last()">&br1;</xsl:if>

 </xsl:for-each><!-- select="df[@t=950]/sf[@c='a']" -->

 </span><!--collocazione-->
</xsl:template>


<!-- ==========================	-->
<!--	951 : getAbbo		-->
<!-- ========================== -->
<xsl:template name="getAbbo951">
<xsl:param name="bib"/>
<xsl:for-each select="/rec/df[@t=951]/sf[@c='a'][.=$bib]">
<xsl:call-template name="translate"><xsl:with-param name="section">traduzioni</xsl:with-param><xsl:with-param name="sigla">abb</xsl:with-param></xsl:call-template>.&nbsp;
  <xsl:for-each select="following-sibling::sf[not(@c='a')]">
   <xsl:choose>
    <xsl:when test="@c='b'"><xsl:value-of select="substring(.,1,8)"/></xsl:when>
    <xsl:when test="@c='c'">&nbsp;&nbsp;<xsl:value-of select="."/></xsl:when>
   </xsl:choose>
  </xsl:for-each>
</xsl:for-each>
</xsl:template>


<!-- ==========================	-->
<!--	961 : getAbbo		-->
<!-- ========================== -->
<xsl:template name="getAbbo961">
<xsl:param name="codbib"/>
<xsl:if test="($codbib!='CF') and ($codbib!='MF')">
<xsl:for-each select="/rec/df[@t=961]/sf[@c='b'][substring(.,1,2)=$codbib]">
<xsl:if test="position()>1"><br/></xsl:if>
<xsl:call-template name="translate"><xsl:with-param name="section">traduzioni</xsl:with-param><xsl:with-param name="sigla">abb</xsl:with-param></xsl:call-template>.&nbsp;<xsl:value-of select="."/>
<!--
   <xsl:choose>
    <xsl:when test="@c='b'"><xsl:value-of select="substring(.,1,8)"/></xsl:when>
    <xsl:when test="@c='c'">&nbsp;&nbsp;<xsl:value-of select="."/></xsl:when>
   </xsl:choose>
-->
</xsl:for-each>
<br/>
</xsl:if>
</xsl:template>


<!-- ==========================================================	-->
<!--   composizione del Link per la richiesta dei fascicoli	-->
<!-- ========================================================== -->
<xsl:template name="getLinkFascicoli">
<xsl:param name="codbib"/>
<xsl:for-each select="/rec/df[@t=961]/sf[@c='b'][substring(.,1,2)=$codbib]">
<xsl:variable name="abbo" select="substring(.,3,10)"/>
<xsl:if test="position()>1">,&nbsp;&nbsp;&nbsp;</xsl:if>
<a><xsl:attribute name="title">
   	<xsl:call-template name="translate">
   	<xsl:with-param name="section">traduzioni</xsl:with-param>
   	<xsl:with-param name="sigla">cliccare_visualizzare_fascicoli</xsl:with-param>
   	</xsl:call-template>
   </xsl:attribute>
	<xsl:attribute name="href"><xsl:value-of select="$contextpath"/>/abbonamento/<xsl:value-of select="$codbib"/>/<xsl:value-of select="$abbo"/></xsl:attribute><xsl:call-template name="translate"><xsl:with-param name="section">traduzioni</xsl:with-param><xsl:with-param name="sigla">abb</xsl:with-param></xsl:call-template>.&nbsp;<xsl:value-of select="$abbo"/></a>
</xsl:for-each>
</xsl:template>



<!-- ==================================================	-->
<!--	intestazione					-->
<!-- ==================================================	-->
<!-- ! e' ripetibile ?					-->
<!-- ==================================================	-->
<xsl:template name="intestazione">

  <xsl:call-template name="autore_breve"/>
  <xsl:apply-templates select="/rec/df[@t=200]"/>
  <xsl:call-template name="edizione"/>
</xsl:template>


<!-- ==================================================	-->
<!--	classi						-->
<!-- ==================================================	-->
<xsl:template name="classi">
 <xsl:if test="df[@t=676]">
 &br1;
 <classi>
 <xsl:for-each select="df[@t=676]">
  <xsl:if test="position() > 1">&br1;</xsl:if>

  <xsl:variable name="display">
	<xsl:call-template name="subfieldSelect">
		<xsl:with-param name="codes">a</xsl:with-param>
		<xsl:with-param name="delimiter"> - </xsl:with-param>
	</xsl:call-template>
	<xsl:text> (ed. </xsl:text>
	<xsl:call-template name="subfieldSelect">
		<xsl:with-param name="codes">v</xsl:with-param>
	</xsl:call-template>
	<xsl:text>)</xsl:text>
	<xsl:text> - </xsl:text>
	<xsl:call-template name="subfieldSelect">
		<xsl:with-param name="codes">9</xsl:with-param>
	</xsl:call-template>
  </xsl:variable>

   <a>	<xsl:attribute name="href"><xsl:value-of select="$contextpath"/>/fcsearch?deweycod_fc=<xsl:value-of select="sf[@c='a']"/></xsl:attribute>
	<xsl:attribute name="title">
   	<xsl:call-template name="translate">
   	<xsl:with-param name="section">traduzioni</xsl:with-param>
   	<xsl:with-param name="sigla">ricerca_notizie_dewey</xsl:with-param>
   	</xsl:call-template>
   </xsl:attribute>
        <xsl:value-of select="$display"/></a> 

 </xsl:for-each>
 </classi>
 </xsl:if>
</xsl:template>


<!-- ==================================================	-->
<!--	cod. materia					-->
<!-- ==================================================	-->
<xsl:template name="codmateria">
 <xsl:for-each select="df[@t=686]">
  <xsl:if test="sf[@c='9'] or sf[@c='a']">&br1;<xsl:call-template name="translate"><xsl:with-param name="section">traduzioni</xsl:with-param><xsl:with-param name="sigla">cod_materia</xsl:with-param></xsl:call-template>:
  <xsl:value-of select="sf[@c='a']"/>&nbsp;-&nbsp;<xsl:value-of select="sf[@c='9']"/>
  </xsl:if>
 </xsl:for-each>
</xsl:template>



<!-- ==================================================	-->
<!--	soggetti					-->
<!-- ==================================================	-->
<!--	! obsoleto: 610					-->
<!-- ==================================================	-->
<xsl:template name="soggetti">
 <xsl:if test="df[@t=610]|df[@t=606]">
 &br1;
 <soggetti>
   <xsl:apply-templates select="df[@t=606]"/>
   <xsl:apply-templates select="df[@t=610]"/>
 </soggetti>
 </xsl:if>
</xsl:template>


<!-- ==================================================	-->
<!--	soggetti	[606]				-->
<!-- ==================================================	-->
<xsl:template match="df[@t=606]">
 <soggetto>
	<xsl:value-of select="position()"/><xsl:text>. </xsl:text>

  <xsl:variable name="soggetto"><xsl:call-template name="substDelim">
	  <xsl:with-param name="string">
		<xsl:value-of select="sf[@c='a']"/><xsl:apply-templates select="sf[@c='x']"/>
	  </xsl:with-param>
	</xsl:call-template></xsl:variable>

  <a><xsl:attribute name="href"><xsl:value-of select="$contextpath"/>/fcsearch?soggetto_fc="<xsl:value-of select="$soggetto"/>"</xsl:attribute>
     <xsl:attribute name="title">
   	<xsl:call-template name="translate">
   	<xsl:with-param name="section">traduzioni</xsl:with-param>
   	<xsl:with-param name="sigla">ricerca_notizie_soggetto</xsl:with-param>
   	</xsl:call-template>
     </xsl:attribute>
	<xsl:value-of select="$soggetto"/>
  </a>
  <xsl:text> &#160; </xsl:text>
 </soggetto>
</xsl:template>

<xsl:template match="df[@t=606]/sf[@c='x']">
   <xsl:text> - </xsl:text><xsl:value-of select="."/>
</xsl:template>

<!-- ==================================================	-->
<!--	soggetti	[610 obsoleto]			-->
<!-- ==================================================	-->
<xsl:template match="df[@t=610]">
 <soggetto>
	<xsl:value-of select="position()"/><xsl:text>. </xsl:text>

  <a><xsl:attribute name="href">
      <xsl:choose>
       <xsl:when test="sf[@c='3']"><xsl:value-of select="$contextpath"/>/controller?action=search_bysoggettosearch&amp;amp;query_fieldname_1=cidtutti&amp;amp;query_querystring_1=<xsl:value-of select="sf[@c='3']"/>
      </xsl:when>
       <xsl:otherwise><xsl:variable name="soggurl"><xsl:call-template name="subfieldSelect"><xsl:with-param name="codes">a</xsl:with-param><xsl:with-param name="delimiter"> </xsl:with-param></xsl:call-template></xsl:variable><xsl:value-of select="$contextpath"/>/controller?action=search_bysoggettosearch&amp;amp;query_fieldname_1=soggettonorm&amp;amp;query_querystring_1=<xsl:value-of select="translate($soggurl,'&lt;&gt;','')"/>
      </xsl:otherwise>
      </xsl:choose>
      </xsl:attribute>

<xsl:attribute name="title">
   	<xsl:call-template name="translate">
   	<xsl:with-param name="section">traduzioni</xsl:with-param>
   	<xsl:with-param name="sigla">ricerca_notizie_soggetto</xsl:with-param>
   	</xsl:call-template>
</xsl:attribute>

	<xsl:call-template name="substDelim">
	  <xsl:with-param name="string">
	    <xsl:call-template name="subfieldSelect">
		<xsl:with-param name="codes">a</xsl:with-param>
		<xsl:with-param name="delimiter"> - </xsl:with-param>
	    </xsl:call-template>
	</xsl:with-param>
	</xsl:call-template>
	<!-- <xsl:if test="sf[@c='3']"> (<xsl:value-of select="sf[@c='3']"/>)</xsl:if> -->
  </a>
  <xsl:text> &#160; </xsl:text>
 </soggetto>
</xsl:template>


<!-- ==================================================	-->
<!--	reponsabilita secondaria			-->
<!--	[701, 702, 712, 500, 510, 517, 532]		-->
<!-- ==================================================	-->
<xsl:template name="responsec">
 <xsl:if test="df[@t=701]|df[@t=702]|df[@t=712]|df[@t=500]|df[@t=510]|df[@t=517]|df[@t=532]">
 &br1;
 <responsec>
 <xsl:for-each select="df[@t=701]|df[@t=702]|df[@t=712]">

  <xsl:variable name="autore_fc"><xsl:call-template name="autore_fc"/></xsl:variable>

  <xsl:if test="position() > 1">&nbsp;&nbsp;</xsl:if>
  <xsl:number format="I. " level="single" count="df[@t=701]|df[@t=702]|df[@t=712]"/> 

  <xsl:variable name="params"><xsl:call-template name="subfieldSelectVirg">
				<xsl:with-param name="codes">abcef</xsl:with-param>
				</xsl:call-template></xsl:variable>
  <xsl:variable name="display"><xsl:call-template name="subfieldSelectVirg">
				<xsl:with-param name="codes">abcdef</xsl:with-param>
				</xsl:call-template></xsl:variable>
  <a><xsl:attribute name="href"><xsl:value-of select="$contextpath"/>/fcsearch?autore_fc="<xsl:value-of select="normalize-space($autore_fc)"/>"</xsl:attribute>
     <xsl:attribute name="title">
   	<xsl:call-template name="translate">
   	<xsl:with-param name="section">traduzioni</xsl:with-param>
   	<xsl:with-param name="sigla">ricerca_notizie_autore</xsl:with-param>
   	</xsl:call-template>
     </xsl:attribute>
     <xsl:value-of select="$display"/>
  </a>

  <xsl:choose>
    <xsl:when test="sf[@c='4']=320">
	&nbsp;<i>[<xsl:call-template name="translate"><xsl:with-param name="section">traduzioni</xsl:with-param><xsl:with-param name="sigla">possessore</xsl:with-param></xsl:call-template>]</i>&nbsp;<xsl:value-of select="sf[@c='5']"/>  </xsl:when>
    <xsl:when test="sf[@c='4']=390">
	&nbsp;[<i><xsl:call-template name="translate"><xsl:with-param name="section">traduzioni</xsl:with-param><xsl:with-param name="sigla">provenienza</xsl:with-param></xsl:call-template></i>&nbsp;<xsl:value-of select="sf[@c='5']"/>] </xsl:when>
    <xsl:when test="sf[@c='4']=650">
	&nbsp;<i>[<xsl:call-template name="translate"><xsl:with-param name="section">traduzioni</xsl:with-param><xsl:with-param name="sigla">editore</xsl:with-param></xsl:call-template>]</i>     </xsl:when>
  </xsl:choose>
  &nbsp;&nbsp;
  
 </xsl:for-each>

 <xsl:variable name="C701" select="count(df[@t=701])"/>
 <xsl:variable name="C702" select="count(df[@t=702])"/>
 <xsl:variable name="C712" select="count(df[@t=712])"/>

 <xsl:if test="not(df[@t=700]/sf[@c=3] = df[@t=500]/sf[@c=9])">

 <xsl:for-each select="df[@t=500 and @i2='0']|df[@t=510]|df[@t=517]|df[@t=532]">

 <xsl:variable name="C500_9" select="count(sf[@c='9'])"/>

  <xsl:number format="I. " level="single"
		value="$C701+$C702+$C712+position()"
		count="df[@t=500 and @i2='0']|df[@t=510]|df[@t=517]|df[@t=532]"/>
  <xsl:choose>
	<xsl:when test="@t=500">
   	<xsl:call-template name="translate">
   	<xsl:with-param name="section">traduzioni</xsl:with-param>
   	<xsl:with-param name="sigla">tit</xsl:with-param>
   	</xsl:call-template>: 
	</xsl:when>
	<xsl:when test="@t=510">
   	<xsl:call-template name="translate">
   	<xsl:with-param name="section">traduzioni</xsl:with-param>
   	<xsl:with-param name="sigla">tit_parallelo</xsl:with-param>
   	</xsl:call-template>: 
	</xsl:when>
	<xsl:when test="$C500_9=0">
   	<xsl:call-template name="translate">
   	<xsl:with-param name="section">traduzioni</xsl:with-param>
   	<xsl:with-param name="sigla">titolo</xsl:with-param>
   	</xsl:call-template>: 
	</xsl:when> 
	<xsl:when test="$C500_9=1">
   	<xsl:call-template name="translate">
   	<xsl:with-param name="section">traduzioni</xsl:with-param>
   	<xsl:with-param name="sigla">titolo_originale</xsl:with-param>
   	</xsl:call-template>: 
	</xsl:when>
  </xsl:choose>

  <xsl:choose>
   <!-- df[@t=510], df[@t=517], df[@t=532] non clickabile -->
   <xsl:when test="(@t=510) or (@t=517) or (@t=532)">
	<xsl:call-template name="substDelim">
	  <xsl:with-param name="string"><xsl:value-of select="sf[@c='a']"/></xsl:with-param>
	</xsl:call-template>
        <xsl:if test="sf[@c='b']"> <xsl:value-of select="sf[@c='b']"/></xsl:if>
        <xsl:if test="sf[@c='c']">&nbsp;<xsl:value-of select="sf[@c='c']"/></xsl:if>
        <xsl:if test="sf[@c='m']">&nbsp;<xsl:value-of select="sf[@c='m']"/></xsl:if>
   </xsl:when>
   <xsl:otherwise>
    <a><xsl:attribute name="href">
      <xsl:choose>
       <xsl:when test="sf[@c='3']"><xsl:value-of select="$contextpath"/>/fcsearch?sf1=bid&amp;sv1=<xsl:value-of select="sf[@c='3']"/>
      </xsl:when>
       <xsl:otherwise><xsl:value-of select="$contextpath"/>/fcsearch?sf1=titolo_fc&amp;sv1=<xsl:value-of select="sf[@c='a']"/><xsl:value-of select="sf[@c='b']"/><xsl:text> </xsl:text><xsl:value-of select="sf[@c='c']"/>
      </xsl:otherwise>
      </xsl:choose>
     </xsl:attribute>
     <xsl:attribute name="title">
   	<xsl:call-template name="translate">
   	<xsl:with-param name="section">traduzioni</xsl:with-param>
   	<xsl:with-param name="sigla">ricerca_notizie_titolo</xsl:with-param>
   	</xsl:call-template>
     </xsl:attribute>
	<xsl:call-template name="substDelim">
	  <xsl:with-param name="string"><xsl:value-of select="sf[@c='a']"/></xsl:with-param>
	</xsl:call-template>
        <xsl:if test="sf[@c='b']"> <xsl:value-of select="sf[@c='b']"/></xsl:if>
        <xsl:if test="sf[@c='c']">&nbsp;<xsl:value-of select="sf[@c='c']"/></xsl:if>
        <xsl:if test="sf[@c='m']">&nbsp;<xsl:value-of select="sf[@c='m']"/></xsl:if>
    </a>
   </xsl:otherwise>
  </xsl:choose>


  <xsl:text> </xsl:text>
  &nbsp;&nbsp;
 </xsl:for-each>
 </xsl:if> <!-- not(df[@t=700]/sf[@c=3] = df[@t=500]/sf[@c=9]) -->


 </responsec>
 </xsl:if>
</xsl:template>


<!-- ==================================================	-->
<!--	titoli nelle note	[500]			-->
<!-- ==================================================	-->
<xsl:template name="notetit">
 <xsl:for-each select="df[@t=500 and @i1=1 and @i2=0]">
   <xsl:if test="./sf[@c=9] = /rec/df[@t=700]/sf[@c=3]">
   <!-- area note -->
     &br1;<xsl:call-template name="translate"><xsl:with-param name="section">traduzioni</xsl:with-param><xsl:with-param name="sigla">titolo_originale</xsl:with-param></xsl:call-template>: 
   <a><xsl:attribute name="href"><xsl:value-of select="$contextpath"/>/fcsearch?sf1=bid&amp;sv1=<xsl:call-template name="getNotetitBid"><xsl:with-param name="field" select="."/></xsl:call-template></xsl:attribute><xsl:call-template name="substDelim"><xsl:with-param name="string"><xsl:value-of select="sf[@c='a']"/></xsl:with-param></xsl:call-template></a>
   </xsl:if>
 </xsl:for-each>
</xsl:template>

<!-- ==================================	-->
<!--	getNoteBid	[500]		-->
<!-- ==================================	-->
 <xsl:template name="getNotetitBid">
	<xsl:param name="field"/>
  <xsl:choose>
   <xsl:when test="sf[@c='3']">
     <xsl:value-of select="./sf[@c=3]"/>
   </xsl:when>
   <xsl:otherwise>
     <xsl:for-each select="./sf[@c=9]">
        <xsl:if test="not(substring(.,4,1) = 'V')"><xsl:value-of select="."/> </xsl:if>
     </xsl:for-each>
   </xsl:otherwise>
  </xsl:choose>
 </xsl:template>


<!-- ==================================================	-->
<!--	titolo originale	[454/s1]		-->
<!-- ==================================================	-->
<!--	! e' ripetibile ?				-->
<!-- ==================================================	-->
<xsl:template name="titolo_orig">
 <xsl:if test="//rec/df[@t=454]/s1">
 &br1;
 <titolo_originale><xsl:call-template name="translate"><xsl:with-param name="section">traduzioni</xsl:with-param><xsl:with-param name="sigla">titolo_originale</xsl:with-param></xsl:call-template>:
 <xsl:if test="//rec/df[@t=454]">
 <xsl:for-each select="//rec/df[@t=454]">
 <a><xsl:attribute name="href"><xsl:value-of select="$contextpath"/>/fcsearch?sf1=bid&amp;sv1=<xsl:value-of select="substring(s1/cf[@t='009'],1,10)"/><xsl:value-of select="substring(s1/cf[@t='001'],1,10)"/> 
     </xsl:attribute>

    <xsl:attribute name="title">
   	<xsl:call-template name="translate">
   	<xsl:with-param name="section">traduzioni</xsl:with-param>
   	<xsl:with-param name="sigla">ricerca_notizie_titolo</xsl:with-param>
   	</xsl:call-template>
    </xsl:attribute>
   <xsl:call-template name="substDelim">
       <xsl:with-param name="string"><xsl:value-of select="s1/df[@t='200']/sf[@c='a']"/>
       </xsl:with-param>
   </xsl:call-template>
  </a>
 </xsl:for-each>
 </xsl:if>
 </titolo_originale>
 </xsl:if>
</xsl:template>


<!-- ==========================================	-->
<!--	titolo					-->
<!-- ==========================================	-->
<xsl:template name="titolo">
  <xsl:variable name="ind" select="@i1"/>
  <xsl:choose>
   <xsl:when test="$ind=x"> <xsl:call-template name="titolo461"/> </xsl:when>
   <xsl:otherwise>
    <xsl:for-each select="sf">
	<xsl:if test="@c='a'">
	  <xsl:if test="position() > 1"> ; </xsl:if>
          <xsl:call-template name="substDelim">
            <xsl:with-param name="string"><xsl:value-of select="."/></xsl:with-param>
          </xsl:call-template>
        </xsl:if>
	<xsl:if test="@c='e'"> : <xsl:call-template name="substDelim">
	  <xsl:with-param name="string" select="."/></xsl:call-template></xsl:if>
	<xsl:if test="@c='i'"> = <xsl:value-of select="."/> </xsl:if>
	<xsl:if test="@c='c'"> . <xsl:value-of select="."/> </xsl:if>
	<xsl:if test="@c='f'"> / <xsl:value-of select="."/> </xsl:if>
	<xsl:if test="@c='g'"> ; <xsl:value-of select="."/> </xsl:if>
    </xsl:for-each>
    <xsl:if test="df[@t=200]">.</xsl:if>
   </xsl:otherwise>
  </xsl:choose>
</xsl:template>


<!-- ==========================================	-->
<!--	[200]					-->
<!-- ==========================================	-->
<xsl:template match="/rec/df[@t=200]">
 <span><xsl:attribute name="class">titolo</xsl:attribute>
  <xsl:call-template name="titolo"/>
 </span>
</xsl:template>


<!-- ==========================================	-->
<!--	titolo [461]				-->
<!-- ==========================================	-->
<!--	! e' ripetibile ?			-->
<!-- ==========================================	-->
<xsl:template name="titolo461">
 <xsl:for-each select="//rec/df[@t=461]/s1/df[@t=200]">
  <xsl:call-template name="titolo"/>
 </xsl:for-each>
    <xsl:if test="//rec/df[@t=461]/s1/df[@t=200]">.</xsl:if>
</xsl:template>


<!-- ==========================================	-->
<!--	autore_fc  [700, 710,500]		-->
<!-- ==========================================	-->
<!-- ==========================================	-->
<xsl:template name="autore_fc">
  <xsl:call-template name="trim">
      <xsl:with-param name="string"><xsl:value-of select="sf[@c='a']"/><xsl:value-of select="sf[@c='b']"/></xsl:with-param>
  </xsl:call-template>
  <xsl:if test="sf[@c='c'] != ''"><xsl:text> </xsl:text><xsl:value-of select="sf[@c='c']"/></xsl:if><xsl:if test="sf[@c='f'] != ''"><xsl:text> </xsl:text><xsl:value-of select="normalize-space(sf[@c='f'])"/></xsl:if><xsl:if test="sf[@c='e'] != ''"><xsl:text> </xsl:text><xsl:value-of select="normalize-space(sf[@c='e'])"/></xsl:if>
</xsl:template>

<!-- ==========================================	-->
<!--	autore breve	[700, 710,500]		-->
<!-- ==========================================	-->
<!--	! e' ripetibile ?			-->
<!-- ==========================================	-->
<xsl:template name="autore_breve">
 <xsl:if test="/rec/df[@t=700]|/rec/df[@t=710]|/rec/df[@t=500 and @i2='1']">
 <autore-breve>
 <xsl:for-each select="/rec/df[@t=700]|/rec/df[@t=710]">

  <xsl:variable name="autore"><xsl:call-template name="compattaPunct"><xsl:with-param name="string"><xsl:call-template name="substDelim"><xsl:with-param name="string"><xsl:call-template name="subfieldSelect"><xsl:with-param name="codes">abcdfe</xsl:with-param><xsl:with-param name="delimiter"><xsl:text> </xsl:text></xsl:with-param></xsl:call-template></xsl:with-param></xsl:call-template></xsl:with-param></xsl:call-template></xsl:variable>

  <xsl:variable name="autore_fc"><xsl:call-template name="autore_fc"/></xsl:variable>

  <a><xsl:attribute name="href"><xsl:value-of select="$contextpath"/>/fcsearch?autore_fc="<xsl:value-of select="normalize-space($autore_fc)"/>"</xsl:attribute>
     <xsl:attribute name="title">
   	<xsl:call-template name="translate">
   	<xsl:with-param name="section">traduzioni</xsl:with-param>
   	<xsl:with-param name="sigla">ricerca_notizie_autore</xsl:with-param>
   	</xsl:call-template>
     </xsl:attribute>
     <xsl:value-of select="$autore"/>
  </a>
  <xsl:text> </xsl:text>
 </xsl:for-each>

 <xsl:for-each select="df[@t=500 and @i2='1']">

  <a><xsl:attribute name="href">
      <xsl:choose>

	<xsl:when test="sf[@c='9']"><xsl:value-of select="$contextpath"/>fcsearch?&amp;amp;query_fieldname_1=bidtutti&amp;amp;query_querystring_1=<xsl:value-of select="sf[@c='9']"/>
	</xsl:when>
	<xsl:otherwise><xsl:value-of select="$contextpath"/>/controller?action=search_bytitolosearch&amp;amp;query_fieldname_1=titolonorm&amp;amp;query_querystring_1=<xsl:value-of select="sf[@c='a']"/>
	</xsl:otherwise>

      </xsl:choose>

      </xsl:attribute>

<xsl:attribute name="title">
   	<xsl:call-template name="translate">
   	<xsl:with-param name="section">traduzioni</xsl:with-param>
   	<xsl:with-param name="sigla">ricerca_notizie_titolo</xsl:with-param>
   	</xsl:call-template>
</xsl:attribute>

	<xsl:call-template name="substDelim">
	    <xsl:with-param name="string">
		<xsl:value-of select="sf[@c='a']"/>
	    </xsl:with-param>
	</xsl:call-template>
        <xsl:if test="sf[@c='b']"> <xsl:value-of select="sf[@c='b']"/></xsl:if>
        <xsl:if test="sf[@c='c']">&nbsp;<xsl:value-of select="sf[@c='c']"/></xsl:if>
        <xsl:if test="sf[@c='m']">&nbsp;<xsl:value-of select="sf[@c='m']"/></xsl:if>
  </a>
  <xsl:text> </xsl:text>
 </xsl:for-each>
  </autore-breve>
 &br1;
 </xsl:if>
</xsl:template>


<!-- ==================================================	-->
<!--	edizione	(generale)			-->
<!-- ==================================================	-->
<xsl:template name="edizione">
 <span>
  <xsl:apply-templates select="/rec/df[@t=205]"/>
  <xsl:apply-templates select="/rec/df[@t=206]/sf[@c='a']"/>
  <xsl:apply-templates select="/rec/df[@t=207]/sf[@c='a']"/>
  <xsl:apply-templates select="/rec/df[@t=208]"/>
  <xsl:apply-templates select="/rec/df[@t=230]/sf[@c='a']"/>
  <xsl:apply-templates select="/rec/df[@t=210]"/>
 </span><!--edizione-->
</xsl:template>


<!-- ==================================================	-->
<!--	edizione	[205]				-->
<!-- ==================================================	-->
<xsl:template match="/rec/df[@t=205]">
  &br1;
  <xsl:attribute name="class">edizione</xsl:attribute>
    <xsl:for-each select="sf">
     <xsl:choose>
      <xsl:when test="@c='a'"> <xsl:if test="position() > 1"> ; </xsl:if>
		       <xsl:value-of select="text()"/>
      </xsl:when>
      <xsl:when test="@c='a'"> : <xsl:value-of select="text()"/> </xsl:when>
      <xsl:when test="@c='d'"><xsl:text> </xsl:text> <xsl:value-of select="text()"/> </xsl:when>
      <xsl:when test="@c='b'">, <xsl:value-of select="text()"/> </xsl:when>
      <xsl:when test="@c='f'"><xsl:if
		test="position() > 1"> / </xsl:if><xsl:value-of select="text()"/> </xsl:when>
      <xsl:when test="@c='g'"><xsl:if
		test="position() > 1">; </xsl:if><xsl:value-of select="text()"/> </xsl:when>
     </xsl:choose>
    </xsl:for-each>
   <xsl:text>. </xsl:text> 
  <xsl:text> </xsl:text>
</xsl:template>


<!-- ==================================================	-->
<!--	edizione	[206$a]				-->
<!-- ==================================================	-->
<xsl:template match="/rec/df[@t=206]/sf[@c='a']">
	&br1;<xsl:value-of select="."/>
</xsl:template>


<!-- ==================================================	-->
<!--	edizione	[207$a]				-->
<!-- ==================================================	-->
<xsl:template match="/rec/df[@t=207]/sf[@c='a']">
	&br1;<xsl:value-of select="."/>
</xsl:template>


<!-- ==================================================	-->
<!--	edizione	[208]				-->
<!-- ==================================================	-->
<xsl:template match="/rec/df[@t=208]">
	&br1;<xsl:value-of select="sf[@c='a']"/> <xsl:value-of select="sf[@c='d']"/>
</xsl:template>


<!-- ==================================================	-->
<!--	edizione	[210]				-->
<!-- ==================================================	-->
<xsl:template match="/rec/df[@t=210]">
   &br1;
   <xsl:variable name="ediz">
   <xsl:for-each select="sf">
    <xsl:choose>
     <xsl:when test="@c = 'a'"> <xsl:if test="position() > 1"> ; </xsl:if>
		<xsl:value-of select="text()"/>
     </xsl:when>
     <xsl:when test="contains('c', @c)"> : <xsl:value-of select="text()"/> </xsl:when>
     <xsl:when test="contains('d', @c)"><xsl:if test="position() > 1">, </xsl:if><xsl:value-of select="text()"/> </xsl:when>
     <xsl:when test="contains('h', @c)"><xsl:if test="position() > 1">, </xsl:if><xsl:value-of select="text()"/> </xsl:when>
    </xsl:choose>
   </xsl:for-each>
   <xsl:if test="sf[@c='e'] or sf[@c='f'] or sf[@c='g']">
     (<xsl:value-of select="sf[@c='e']"/>
     <xsl:if test="sf[@c='e'] and sf[@c='f']"> : </xsl:if> <xsl:value-of select="sf[@c='f']"/>
     <xsl:if test="(sf[@c='e'] or sf[@c='f']) and sf[@c='g']">, </xsl:if> <xsl:value-of select="sf[@c='g']"/>)
   </xsl:if>
  </xsl:variable>
  <xsl:value-of select="$ediz"/>
   <xsl:if test="substring($ediz,string-length($ediz),1) != '.'">.</xsl:if>
</xsl:template>


<!-- ==================================================	-->
<!--	edizione	[230$a]				-->
<!-- ==================================================	-->
<xsl:template match="/rec/df[@t=230]/sf[@c='a']">
	&br1;<xsl:value-of select="."/>
</xsl:template>


<!-- ==================================================	-->
<!--	national use	[790, 791, 900, 910]			-->
<!-- ==================================================	-->
<xsl:template name="nationaluse">
 <xsl:if test="df[@t=790]|df[@t=791]|df[@t=900]|df[@t=910]|df[@t=969]">
 &br1;
 &br1;
 <nationaluse>
  <xsl:if test="df[@t=900]">
    <xsl:for-each select="df[@t=900]">
	<xsl:sort select="sf[@c='z']"/>
	<xsl:variable name="prec" select="preceding-sibling::*[position()=1]/sf[@c='z']"/>
	<xsl:variable name="this" select="sf[@c='z']"/>
	<xsl:if test="not($this = $prec)">
	  <xsl:call-template name="substDelim">
		<xsl:with-param name="string">
			<xsl:value-of select="$this"/>
		</xsl:with-param>
	  </xsl:call-template>
     <xsl:text> </xsl:text>
	  <i> 
   	<xsl:call-template name="translate">
   	<xsl:with-param name="section">traduzioni</xsl:with-param>
   	<xsl:with-param name="sigla">e_forma_preferita_per</xsl:with-param>
   	</xsl:call-template>:
     </i>&br1;
	</xsl:if>
	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
	   <xsl:call-template name="compattaPunct">
	     <xsl:with-param name="string">
	     <xsl:call-template name="substDelim">
		<xsl:with-param name="string">
	         <xsl:call-template name="subfieldSelect">
			<xsl:with-param name="codes">abcdfe</xsl:with-param>
	         </xsl:call-template>
		</xsl:with-param>
	     </xsl:call-template>
	    </xsl:with-param>
	   </xsl:call-template>
      &br1;
    </xsl:for-each>
  </xsl:if>

  <xsl:if test="df[@t=790]">
    <xsl:for-each select="df[@t=790]">
	<xsl:sort select="sf[@c='z']"/>
	<xsl:variable name="prec" select="preceding-sibling::*[position()=1]/sf[@c='z']"/>
	<xsl:variable name="this" select="sf[@c='z']"/>
	<xsl:if test="not($this = $prec)">
	  <xsl:call-template name="substDelim">
		<xsl:with-param name="string">
			<xsl:value-of select="$this"/>
		</xsl:with-param>
		</xsl:call-template>
      <xsl:text> </xsl:text>
		<i> 
   	<xsl:call-template name="translate">
   	<xsl:with-param name="section">traduzioni</xsl:with-param>
   	<xsl:with-param name="sigla">e_forma_preferita_per</xsl:with-param>
   	</xsl:call-template>:
     </i>&br1;
	</xsl:if>
	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
	   <xsl:call-template name="compattaPunct">
	     <xsl:with-param name="string">
	     <xsl:call-template name="substDelim">
		<xsl:with-param name="string">
	         <xsl:call-template name="subfieldSelect">
			<xsl:with-param name="codes">abcdfe</xsl:with-param>
	         </xsl:call-template>
		</xsl:with-param>
	     </xsl:call-template>
	    </xsl:with-param>
	   </xsl:call-template>
      &br1;
    </xsl:for-each>
  </xsl:if>

  <xsl:if test="df[@t=910]">
    <xsl:for-each select="df[@t=910]">
	<xsl:sort select="sf[@c='z']|sf[@c='y']"/>
	<xsl:variable name="prec" select="preceding-sibling::*[position()=1]/sf[@c='z']|preceding-sibling::*[position()=1]/sf[@c='y']"/>
	<xsl:variable name="this" select="sf[@c='z']|sf[@c='y']"/>
	<xsl:if test="not($this = $prec)">
	  <xsl:value-of select="$this"/> 
     <xsl:text> </xsl:text>
     <i> 
   	<xsl:call-template name="translate">
   	<xsl:with-param name="section">traduzioni</xsl:with-param>
   	<xsl:with-param name="sigla">e_forma_preferita_per</xsl:with-param>
   	</xsl:call-template>:
     </i>&br1;
	</xsl:if>
	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
	   <xsl:call-template name="compattaPunct">
	     <xsl:with-param name="string">
	     <xsl:call-template name="substDelim">
		<xsl:with-param name="string">
	         <xsl:call-template name="subfieldSelect">
			<xsl:with-param name="codes">abcdfe</xsl:with-param>
	         </xsl:call-template>
		</xsl:with-param>
	     </xsl:call-template>
	    </xsl:with-param>
	   </xsl:call-template>
	&br1;
    </xsl:for-each>
  </xsl:if>

  <xsl:if test="df[@t=969]">

    <xsl:for-each select="df[@t=969][sf[@c='y']]">
	<xsl:sort select="sf[@c='y']"/>
	<xsl:variable name="prec" select="preceding-sibling::*[position()=1]/sf[@c='y']"/>
	<xsl:variable name="this" select="sf[@c='y']"/>
	<xsl:if test="not($this = $prec)">
	  <xsl:value-of select="$this"/>&nbsp;&nbsp;&nbsp;
     <i>
   	<xsl:call-template name="translate">
   	<xsl:with-param name="section">traduzioni</xsl:with-param>
   	<xsl:with-param name="sigla">forma_preferita_per_nuovo_soggettario</xsl:with-param>
   	</xsl:call-template>:
     </i>&br1;
	</xsl:if>
	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
	   <xsl:call-template name="compattaPunct">
	     <xsl:with-param name="string">
	     <xsl:call-template name="substDelim">
		<xsl:with-param name="string">
	         <xsl:call-template name="subfieldSelect">
			<xsl:with-param name="codes">abcdfe</xsl:with-param>
	         </xsl:call-template>
		</xsl:with-param>
	     </xsl:call-template>
	    </xsl:with-param>
	   </xsl:call-template>
	&br1;
    </xsl:for-each>

    <xsl:for-each select="df[@t=969][sf[@c='z']]">
	<xsl:sort select="sf[@c='z']"/>
	<xsl:variable name="prec" select="preceding-sibling::*[position()=1]/sf[@c='z']"/>
	<xsl:variable name="this" select="sf[@c='z']"/>
	<xsl:if test="not($this = $prec)">
	  <xsl:value-of select="$this"/>&nbsp;&nbsp;&nbsp;
    <i>
   	<xsl:call-template name="translate">
   	<xsl:with-param name="section">traduzioni</xsl:with-param>
   	<xsl:with-param name="sigla">forma_preferita_per</xsl:with-param>
   	</xsl:call-template>:
    </i>&br1;
	</xsl:if>
	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
	   <xsl:call-template name="compattaPunct">
	     <xsl:with-param name="string">
	     <xsl:call-template name="substDelim">
		<xsl:with-param name="string">
	         <xsl:call-template name="subfieldSelect">
			<xsl:with-param name="codes">abcdfe</xsl:with-param>
	         </xsl:call-template>
		</xsl:with-param>
	     </xsl:call-template>
	    </xsl:with-param>
	   </xsl:call-template>
	&br1;
    </xsl:for-each>

  </xsl:if>



  <xsl:if test="df[@t=791]">

    <xsl:for-each select="df[@t=791][sf[@c='y']]">
	<xsl:sort select="sf[@c='y']"/>
	<xsl:variable name="prec" select="preceding-sibling::*[position()=1]/sf[@c='y']"/>
	<xsl:variable name="this" select="sf[@c='y']"/>
	<xsl:if test="not($this = $prec)">
	  <xsl:value-of select="$this"/>&nbsp;&nbsp;&nbsp;
     <i>
   	<xsl:call-template name="translate">
   	<xsl:with-param name="section">traduzioni</xsl:with-param>
   	<xsl:with-param name="sigla">altra_forma_per</xsl:with-param>
   	</xsl:call-template>:
     </i>&br1;
	</xsl:if>
	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
	   <xsl:call-template name="compattaPunct">
	     <xsl:with-param name="string">
	     <xsl:call-template name="substDelim">
		<xsl:with-param name="string">
	         <xsl:call-template name="subfieldSelect">
			<xsl:with-param name="codes">abcdfe</xsl:with-param>
	         </xsl:call-template>
		</xsl:with-param>
	     </xsl:call-template>
	    </xsl:with-param>
	   </xsl:call-template>
	&br1;
    </xsl:for-each>

    <xsl:for-each select="df[@t=791][sf[@c='z']]">
	<xsl:sort select="sf[@c='z']"/>
	<xsl:variable name="prec" select="preceding-sibling::*[position()=1]/sf[@c='z']"/>
	<xsl:variable name="this" select="sf[@c='z']"/>
	<xsl:if test="not($this = $prec)">
	  <xsl:value-of select="$this"/>&nbsp;&nbsp;&nbsp;
     <i>
   	<xsl:call-template name="translate">
   	<xsl:with-param name="section">traduzioni</xsl:with-param>
   	<xsl:with-param name="sigla">forma_preferita_per</xsl:with-param>
   	</xsl:call-template>:
     </i>&br1;
	</xsl:if>
	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
	   <xsl:call-template name="compattaPunct">
	     <xsl:with-param name="string">
	     <xsl:call-template name="substDelim">
		<xsl:with-param name="string">
	         <xsl:call-template name="subfieldSelect">
			<xsl:with-param name="codes">abcdfe</xsl:with-param>
	         </xsl:call-template>
		</xsl:with-param>
	     </xsl:call-template>
	    </xsl:with-param>
	   </xsl:call-template>
	&br1;
    </xsl:for-each>

  </xsl:if>

  </nationaluse>
  </xsl:if>
</xsl:template>


<!-- ==================================================	-->
<!--	rft_au	[700]				-->
<!-- ==================================================	-->
<xsl:template name="rft_au">
  <xsl:for-each select="df[@t=700]">
	<xsl:call-template name="subfieldSelect">
		<xsl:with-param name="codes">abcdfeghi</xsl:with-param>
	</xsl:call-template>
   <xsl:text> </xsl:text>
  </xsl:for-each>
</xsl:template>


 <!--============================= keywords ======================== -->

 <!-- keywords autore -->

<!-- ==================================================	-->
<!--	keywords autore					-->
<!-- ==================================================	-->
<xsl:template name="keywords_autore">
  <keywords-autore>
  <xsl:for-each select="df[@t=700]|df[@t=701]|df[@t=702]|df[@t=710]|df[@t=711]|df[@t=712]|df[@t=900]|df[@t=910]|df[@t=790]|df[@t=791]">
	<xsl:call-template name="subfieldSelect">
		<xsl:with-param name="codes">abcdfe</xsl:with-param>
	</xsl:call-template>
   <xsl:text> </xsl:text>
  </xsl:for-each>
  </keywords-autore>
</xsl:template>


<!-- ==================================================	-->
<!--	keywords titolo					-->
<!-- ==================================================	-->
<xsl:template name="keywords_titolo">
  <keywords-titolo>
  <xsl:for-each select="df[@t=454]|df[@t=510]|df[@t=517]|df[@t=520]|df[@t=530]|df[@t=531]|df[@t=532]|df[@t=500]|df[@t=225]|df[@t=462]|df[@t=423]">
	<xsl:call-template name="subfieldSelect">
		<xsl:with-param name="codes">abcdef</xsl:with-param>
	</xsl:call-template>
   <xsl:text> </xsl:text>
  </xsl:for-each>
  </keywords-titolo>
</xsl:template>



<!-- ==================================================	-->
<!--	coins						-->
<!-- ==================================================	-->
<xsl:template name="coins">

   <xsl:variable name="bid" select="substring(/rec/cf[@t='001'],1,10)"/>
   <xsl:variable name="nbn" select="/rec/df[@t=020]/sf[@c='b']"/>
   <xsl:variable name="isbn" select="/rec/df[@t=010]/sf[@c='a']"/>
   <xsl:variable name="issn" select="/rec/df[@t=011]/sf[@c='a']"/>
   <xsl:variable name="date" select="substring(/rec/df[@t=100]/sf[@c='a'],10,4)"/>
   <xsl:variable name="tit1"><xsl:call-template name="substDelim"><xsl:with-param name="string"><xsl:value-of select="/rec/df[@t=200]/sf[@c='a']"/></xsl:with-param></xsl:call-template></xsl:variable>
   <xsl:variable name="title">
   <xsl:variable name="apos">&apos;</xsl:variable>
   <xsl:choose>
	<xsl:when test="contains($tit1, $apos)">
	<xsl:call-template name="escape"><xsl:with-param name="string"><xsl:value-of select="$tit1"/></xsl:with-param></xsl:call-template>
	</xsl:when>
	<xsl:otherwise><xsl:value-of select="$tit1"/></xsl:otherwise>
   </xsl:choose>
   </xsl:variable>

   <xsl:variable name="autor"><xsl:call-template name="rft_au"/></xsl:variable>
   <xsl:variable name="aulst1" select="/rec/df[@t=700]/sf[@c='a']"/>
   <xsl:variable name="aulast">
   <xsl:choose>
	<xsl:when test="contains($aulst1, ',')">
		<xsl:value-of select="substring-before($aulst1, ',')"/></xsl:when>
	<xsl:otherwise><xsl:value-of select="$aulst1"/></xsl:otherwise>
   </xsl:choose>
   </xsl:variable>
   <xsl:variable name="natura" select="substring(/rec/lab,8,1)"/>

   <xsl:variable name="coins_title">url_ver=Z39.88-2004&amp;amp;rft_id=info:sbn/<xsl:value-of select="$bid"/>&amp;amp;<xsl:if test="$nbn and not($nbn='')">rft_id=urn:NBN:IT:<xsl:value-of select="$nbn"/>&amp;amp;</xsl:if><xsl:if test="$isbn and not($isbn='')">rft.isbn=<xsl:value-of select="$isbn"/>&amp;amp;</xsl:if><xsl:if test="$issn and not($issn='')">rft.issn=<xsl:value-of select="$issn"/>&amp;amp;</xsl:if><xsl:if test="$date and not($date='')">rft.date=<xsl:value-of select="$date"/>&amp;amp;</xsl:if><xsl:if test="$autor and not($autor='')">rft.au=<xsl:value-of select="$autor"/>&amp;amp;</xsl:if><xsl:if test="$aulast and not($aulast='')">rft.aulast=<xsl:value-of select="$aulast"/>&amp;amp;</xsl:if><xsl:choose>
   <xsl:when test="$natura='m'">rft_val_fmt=info:ofi/fmt:kev:mtx:book</xsl:when>
   <xsl:when test="$natura='s'">rft_val_fmt=info:ofi/fmt:kev:mtx:book</xsl:when>
   <xsl:otherwise>rft_val_fmt=info:ofi/fmt:kev:mtx:unknown</xsl:otherwise></xsl:choose>&amp;amp;rfr_id=info:sid/bncf.firenze.sbn.it:catalogo&amp;amp;url_ctx_fmt=info:ofi/fmt:kev:mtx:ctx&amp;amp;ctx_ver=Z39.88-2004&amp;amp;<xsl:if test="$title and not($title='')">rft.title=<xsl:value-of select="$title"/></xsl:if></xsl:variable>

<div><xsl:attribute name="class">coins</xsl:attribute>
 <span><xsl:attribute name="class">Z3988</xsl:attribute>
	<xsl:attribute name="title"><xsl:value-of select="$coins_title"/></xsl:attribute></span>
</div>
</xsl:template>


<!-- ==========================================	-->
<!--	risdigitale() 				-->
<!-- ==========================================	-->
 <xsl:template name="risdigitale">
  <xsl:param name="cpath"/>
  <xsl:if test="df[@t=899]/sf[@c='u']|df[@t=956]/sf[@c='a']|df[@t=856]">
<div><xsl:attribute name="class">risdigit</xsl:attribute>
   <xsl:for-each select="df[@t=899]/sf[@c='u']|df[@t=956]/sf[@c='a']">
    <A>
	<xsl:attribute name="href">javascript: loadArsbni('<xsl:value-of select="."/>');</xsl:attribute><xsl:choose>

	<xsl:when test="../@i2='0'">
	<xsl:attribute name="title">
   	<xsl:call-template name="translate">
   	<xsl:with-param name="section">traduzioni</xsl:with-param>
   	<xsl:with-param name="sigla">accesso_risorsa_digitalizzata_parzialmente</xsl:with-param>
   	</xsl:call-template>:
	</xsl:attribute>
	<img border="0" align="center" style="vertical-align: middle;">
	  <xsl:attribute name="src"><xsl:value-of select="$cpath"/>/img/ARS.jpg</xsl:attribute>
	  &nbsp;<xsl:call-template name="translate"><xsl:with-param name="section">traduzioni</xsl:with-param><xsl:with-param name="sigla">digitalizzazione_parziale</xsl:with-param></xsl:call-template>
	</img>
        </xsl:when>
	<xsl:when test="../@i2='1'">
	<xsl:attribute name="title">
   	<xsl:call-template name="translate">
   	<xsl:with-param name="section">traduzioni</xsl:with-param>
   	<xsl:with-param name="sigla">accesso_copia_digitale</xsl:with-param>
   	</xsl:call-template>
	</xsl:attribute>
	<img border="0" align="center" style="vertical-align: middle;">
	  <xsl:attribute name="src"><xsl:value-of select="$cpath"/>/img/CD.jpg</xsl:attribute>
	  &nbsp;<xsl:call-template name="translate"><xsl:with-param name="section">traduzioni</xsl:with-param><xsl:with-param name="sigla">copia_digitale</xsl:with-param></xsl:call-template>
	</img>
        </xsl:when>
	 <xsl:when test="../@i2='2'">
	<xsl:attribute name="title">
   	<xsl:call-template name="translate">
   	<xsl:with-param name="section">traduzioni</xsl:with-param>
   	<xsl:with-param name="sigla">accesso_copia_depositata_bncf</xsl:with-param>
   	</xsl:call-template>
	</xsl:attribute>
	<img border="0" align="center" style="vertical-align: middle;">
	  <xsl:attribute name="src="><xsl:value-of select="$cpath"/>/img/ECPDEP.gif</xsl:attribute>
	  &nbsp;<xsl:call-template name="translate">
   	<xsl:with-param name="section">traduzioni</xsl:with-param>
   	<xsl:with-param name="sigla">copia_depositata_bncf</xsl:with-param>
   	</xsl:call-template>
	</img>
	</xsl:when>
	</xsl:choose></A>&nbsp;&nbsp;&nbsp;
   </xsl:for-each>
<!--
   <xsl:for-each select="df[@t=856]/sf[@c='u']">
    <A>
	<xsl:attribute name="title">Accesso alla risorsa presente su un sito internet esterno (apre in un altra finestra)</xsl:attribute>
	<xsl:attribute name="target">risext</xsl:attribute>
	<xsl:attribute name="href"><xsl:value-of select="."/></xsl:attribute>
	 <img src="img/www.gif" border="0" align="center"/>&nbsp;<xsl:value-of select="."/>&nbsp;&nbsp;&nbsp;
    </A>
   </xsl:for-each>
-->
</div>
  </xsl:if>

 </xsl:template>


<!-- %%%%%%%%%%%%%%%%%%%%%%%%%%% utils begin %%%%%%%%%%%%%%%%%%%%%%%%%%% -->

<!-- ========================================== -->
<!--  getMaxString(text,maxlen)			-->
<!-- ========================================== -->

<xsl:template name="getMaxString">
  <xsl:param name="text"/>
  <xsl:param name="maxlen"/>
  <xsl:variable  name="strlen" select="string-length($text)"/>
  <xsl:choose>
	<xsl:when test="$strlen > $maxlen"><xsl:value-of select="substring($text,1,$maxlen)"/>...</xsl:when>
	<xsl:otherwise><xsl:value-of select="$text"/></xsl:otherwise>
  </xsl:choose>
</xsl:template>

<!-- ================================== -->
<!--  trim(string)			-->
<!-- ================================== -->
<xsl:template name="trim">
 <xsl:param name="string"/>
 <xsl:variable name="length" select="string-length($string)"/>
  <xsl:choose>
   <xsl:when test="$length=0"/>
   <xsl:when test="substring($string,1,1) = ' '">
    <xsl:call-template name="trim">
     <xsl:with-param name="string" select="substring($string,2,$length - 1)"/>
    </xsl:call-template>
   </xsl:when>
   <xsl:when test="substring($string,$length,1) = ' '">
    <xsl:call-template name="trim">
     <xsl:with-param name="string" select="substring($string,1,$length - 1)"/>
    </xsl:call-template>
   </xsl:when>
   <xsl:otherwise>
    <xsl:value-of select="$string"/>
   </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<!-- ================================== -->
<!--  compactSpace(string)		-->
<!-- ================================== -->
<xsl:template name="compactSpace">
 <xsl:param name="string"/>
 <xsl:variable name="length" select="string-length($string)"/>
 <xsl:choose>
  <xsl:when test="$length=0"/>
  <xsl:when test="contains($string, '  ')">
   <xsl:call-template name="compactSpace">
     <xsl:with-param name="string">
    <xsl:value-of select="substring-before($string,'  ')"/><xsl:text> </xsl:text><xsl:value-of select="substring-after($string,'  ')"/>
     </xsl:with-param>
   </xsl:call-template>
  </xsl:when>
  <xsl:otherwise><xsl:value-of select="$string"/></xsl:otherwise>
 </xsl:choose>
</xsl:template>

<!-- ================================== -->
<!--	df(tag,ind1,ind2,subfields)	-->
<!-- ================================== -->
<xsl:template name="df">
	<xsl:param name="tag"/>
	<xsl:param name="ind1"><xsl:text> </xsl:text></xsl:param>
	<xsl:param name="ind2"><xsl:text> </xsl:text></xsl:param>
	<xsl:param name="subfields"/>
	<xsl:element name="df">
		<xsl:attribute name="t"><xsl:value-of select="$tag"/></xsl:attribute>
		<xsl:attribute name="i1"><xsl:value-of select="$ind1"/></xsl:attribute>
		<xsl:attribute name="i2"><xsl:value-of select="$ind2"/></xsl:attribute>
		<xsl:copy-of select="$subfields"/>
	</xsl:element>
</xsl:template>

<!-- ================================== -->
<!--	subfieldSelect(codes,delimiter)	-->
<!-- ================================== -->
<xsl:template name="subfieldSelect">
 <xsl:param name="codes"/>
 <xsl:param name="delimiter"><xsl:text></xsl:text></xsl:param>
 <xsl:variable name="str">
  <xsl:for-each select="sf">
   <xsl:if test="contains($codes, @c)"><xsl:value-of
           select="text()"/><xsl:value-of select="$delimiter"/></xsl:if>
  </xsl:for-each>
 </xsl:variable>
 <xsl:value-of select="substring($str,1,string-length($str)-string-length($delimiter))"/>
</xsl:template>

<!-- ========================================== -->
<!--	subfieldSelectVirg(codes,delimiter)	-->
<!-- ========================================== -->
<xsl:template name="subfieldSelectVirg">
   <xsl:param name="codes"/>
   <xsl:param name="delimiter"><xsl:text> </xsl:text></xsl:param>
   <xsl:variable name="str">
	<xsl:for-each select="sf">
		<xsl:if test="contains($codes, @c)">
			<xsl:if test="(position() > 1) and not(contains('.:,;', substring(text(),1,1)))">
				<xsl:value-of select="$delimiter"/>
			</xsl:if>
			<xsl:value-of select="text()"/>
		</xsl:if>
	</xsl:for-each>
   </xsl:variable>
   <xsl:value-of select="substring($str,1,string-length($str))"/>
</xsl:template>

<!-- ================================== -->
<!--	buildSpaces(string,char)	-->
<!-- ================================== -->
<xsl:template name="buildSpaces">
		<xsl:param name="spaces"/>
		<xsl:param name="char"><xsl:text> </xsl:text></xsl:param>
		<xsl:if test="$spaces>0">
			<xsl:value-of select="$char"/>
			<xsl:call-template name="buildSpaces">
				<xsl:with-param name="spaces" select="$spaces - 1"/>
				<xsl:with-param name="char" select="$char"/>
			</xsl:call-template>
		</xsl:if>
</xsl:template>

<!-- ================================================== -->
<!--	chopPunctuationFront(chopString,punctuation)	-->
<!-- ================================================== -->
<xsl:template name="chopPunctuation">
   <xsl:param name="chopString"/>
   <xsl:param name="punctuation"><xsl:text>.:,;/ </xsl:text></xsl:param>
   <xsl:variable name="length" select="string-length($chopString)"/>
   <xsl:choose>
	<xsl:when test="$length=0"/>
	<xsl:when test="contains($punctuation, substring($chopString,$length,1))">
		<xsl:call-template name="chopPunctuation">
			<xsl:with-param name="chopString" select="substring($chopString,1,$length - 1)"/>
			<xsl:with-param name="punctuation" select="$punctuation"/>
		</xsl:call-template>
	</xsl:when>
	<xsl:when test="not($chopString)"/>
	<xsl:otherwise><xsl:value-of select="$chopString"/></xsl:otherwise>
   </xsl:choose>
</xsl:template>

<!-- ========================================== -->
<!--	chopPunctuationFront(chopString)	-->
<!-- ========================================== -->
<xsl:template name="chopPunctuationFront">
   <xsl:param name="chopString"/>
   <xsl:variable name="length" select="string-length($chopString)"/>
   <xsl:choose>
	<xsl:when test="$length=0"/>
	<xsl:when test="contains('.:,;/[ ', substring($chopString,1,1))">
		<xsl:call-template name="chopPunctuationFront">
			<xsl:with-param name="chopString" select="substring($chopString,2,$length - 1)"/>
		</xsl:call-template>
	</xsl:when>
	<xsl:when test="not($chopString)"/>
	<xsl:otherwise><xsl:value-of select="$chopString"/></xsl:otherwise>
   </xsl:choose>
</xsl:template>

<!-- ================================== -->
<!--	compattaPunct(string)		-->
<!-- ================================== -->
<xsl:template name="compattaPunct">
<xsl:param name="string"/>
 <xsl:choose>
  <xsl:when test="contains($string,' ,')"><xsl:value-of
	select="substring-before($string, ' ,')"/>, <xsl:value-of
	select="substring-after($string,' ,')"/></xsl:when>
  <xsl:otherwise><xsl:value-of select="$string"/></xsl:otherwise>
 </xsl:choose>
</xsl:template>


<!-- ========================================== -->
<!--	substDelim98(string)	[obsoleto]	-->
<!-- ========================================== -->
<xsl:template name="substDelim98">
		<xsl:param name="string"/>
		<xsl:choose>
		<xsl:when test="contains($string, '&#x98;')">
			<xsl:value-of select="substring-before($string, '&#x98;')"/>
			<xsl:value-of select="substring-after($string, '&#x98;')"/>
		</xsl:when>
		<!-- supporta temporaneamente la codifica vecchia -->
		<xsl:when test="contains($string, '&#x88;')">
			<xsl:value-of select="substring-before($string, '&#x88;')"/>
			<xsl:value-of select="substring-after($string, '&#x88;')"/>
		</xsl:when>
		<xsl:otherwise>
		   <xsl:value-of select="$string"/>
		</xsl:otherwise>
		</xsl:choose>
</xsl:template>

<!-- ================================== -->
<!--	substDelim9C(string)		-->
<!-- ================================== -->
<xsl:template name="substDelim9C">
		<xsl:param name="string"/>
		<xsl:choose>
		<xsl:when test="contains($string, '&#x9C;')">
			<xsl:value-of select="substring-before($string, '&#x9C;')"/>
			<xsl:value-of select="substring-after($string, '&#x9C;')"/>
		</xsl:when>
		<!-- supporta temporaneamente la codifica vecchia -->
		<xsl:when test="contains($string, '&#x89;')">
			<xsl:value-of select="substring-before($string, '&#x89;')"/>
			<xsl:value-of select="substring-after($string, '&#x89;')"/>
		</xsl:when>

		<xsl:otherwise>
		   <xsl:value-of select="$string"/>
		</xsl:otherwise>
		</xsl:choose>
</xsl:template>

<!-- ================================== -->
<!--	substDelim(string)		-->
<!-- ================================== -->
<xsl:template name="substDelim">
		<xsl:param name="string"/>
		<xsl:choose>
		<xsl:when test="contains($string, '&#x98;')">
			<xsl:call-template name="substDelim9C">
			<xsl:with-param name="string">
				<xsl:call-template name="substDelim98">
					<xsl:with-param name="string" select="$string"/>
				</xsl:call-template>
			</xsl:with-param>
			</xsl:call-template>
		</xsl:when>
		<!-- supporta temporaneamente la codifica vecchia -->
		<xsl:when test="contains($string, '&#x88;')">
			<xsl:call-template name="substDelim9C">
			<xsl:with-param name="string">
				<xsl:call-template name="substDelim98">
					<xsl:with-param name="string" select="$string"/>
				</xsl:call-template>
			</xsl:with-param>
			</xsl:call-template>
		</xsl:when>
		<xsl:otherwise>
		   <xsl:value-of select="$string"/>
		</xsl:otherwise>
		</xsl:choose>
</xsl:template>

<!-- ================================== -->
<!--	escape(string)			-->
<!-- ================================== -->
<xsl:template name="escape">
	<xsl:param name="string"/>
	<xsl:variable name="apos">&apos;</xsl:variable>
  <xsl:choose>
    <xsl:when test="contains($string, $apos)">
	<xsl:value-of select="substring-before($string, $apos)"/>
	<xsl:text> </xsl:text>
	<xsl:call-template name="escape">
	  <xsl:with-param name="string">
		<xsl:value-of select="substring-after($string, $apos)"/>
	  </xsl:with-param>
	</xsl:call-template>
    </xsl:when>
    <xsl:otherwise><xsl:value-of select="$string"/></xsl:otherwise>
  </xsl:choose>
</xsl:template>


</xsl:stylesheet>


