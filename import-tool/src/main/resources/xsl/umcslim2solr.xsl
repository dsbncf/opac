<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE umcslim2oi [
<!ENTITY nl '<xsl:text>
</xsl:text>'>
]>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" >
<xsl:output method="xml" encoding="UTF-8" indent="yes" omit-xml-declaration="no" />
<!--
 !  converte un documento XML con root '<rec>'
 !  conforme all'elemento "<rec>" dello schema unimarcslim
 !  della BNCF in formato "solr"  per la indicizzazione della notizia opac.
 -->

<xsl:template match="rec">
	<xsl:variable name="label" select="lab"/>
	<xsl:variable name="label5" select="substring($label,6,1)"/>
	<xsl:variable name="label6" select="substring($label,7,1)"/>
	<xsl:variable name="label7" select="substring($label,8,1)"/>
	<xsl:variable name="controlField008" select="cf[@t=008]"/>
<xsl:if test="$label5!='d'">
<doc>&nl;
 <xsl:call-template name="idn"/>
 <xsl:call-template name="dataagg"/>
 <xsl:call-template name="titolo"/> <!-- titolo_dp, titolo_srt -->
 <xsl:call-template name="autore1"/> <!-- autore_dp, autore_srt -->

 <xsl:call-template name="titolo_kw"/>
 <xsl:call-template name="titoli"/>
 <xsl:call-template name="autore"/> <!-- autore_fc e autore_kw -->
 <xsl:call-template name="collana"/>
 <xsl:call-template name="editore"/>
 <xsl:call-template name="luoghi"/>
 <xsl:call-template name="soggetto"/>
 <xsl:call-template name="descrittore"/>
 <xsl:call-template name="classi"/>
 <xsl:call-template name="identificatori"/>
 <xsl:call-template name="marca"/>
 <xsl:call-template name="colloc"/>
 <xsl:call-template name="inventario"/>
 <xsl:call-template name="bid_tutti"/>
 <xsl:call-template name="keywords"/>
 <xsl:call-template name="bid_tutti"/>
 <xsl:call-template name="cid_tutti"/>
 <xsl:call-template name="vid_tutti"/>
 <!-- filtri -->
 <xsl:call-template name="categoria"/>
 <xsl:call-template name="lingua"/>
 <xsl:call-template name="paese"/>
 <xsl:call-template name="natura"/>
 <xsl:call-template name="biblioteca"/>
 <xsl:call-template name="opera_fc"/>

 <xsl:call-template name="anno1"/>
 <xsl:call-template name="anno2"/>
 <xsl:call-template name="tipomat"/>
 <xsl:call-template name="tipodig"/>
</doc>
</xsl:if>
</xsl:template>


	<!-- =================== control-fields  ==================== -->

	<!-- Identificatore del record / BID della notizia -->

<xsl:template name="idn" >
<xsl:variable name="smallcase" select="'abcdefghijklmnopqrstuvwxyz'" />
<xsl:variable name="uppercase" select="'ABCDEFGHIJKLMNOPQRSTUVWXYZ'" />
<xsl:for-each select="cf[@t=001]">
	<field name="idn"><xsl:value-of select="translate(text(), $uppercase, $smallcase)"/></field>&nl;
</xsl:for-each>
</xsl:template>

	<!-- dataagg : data di aggiornamento del record -->

<xsl:template name="dataagg" >
	<field name="dataagg"><xsl:value-of select="substring(cf[@t=005],1,8)"/></field>&nl;
</xsl:template>



	<!-- ============== templates per i filtri ==============  -->

	<!-- filtri:	categoria -->

<xsl:template name="categoria" >

 <xsl:variable name="L7" select="substring(lab,7,1)"/>
 <xsl:variable name="L8" select="substring(lab,8,1)"/>

 <xsl:variable name="ckED" select="df[@t=856]"/>
 <xsl:variable name="ckDI" select="df[@t=956 and (@i2='1')] or df[@t=899 and (@i2='1')]"/>
 <xsl:variable name="ckDC" select="df[@t=956 and (@i2='0')] or df[@t=899 and (@i2='0')]"/>
 <xsl:variable name="ckTD" select="(substring(df[@t='105']/sf[@c='a'],5,1)='m') or ($L7='b' and $L8='m')"/>
 <xsl:variable name="ckCL" select="($L8='s') and (substring(df[@t='110']/sf[@c='a'],1,1)='b')"/>

 <xsl:if test="$ckED"><field name="categoria">ED</field>&nl;</xsl:if>
 <xsl:if test="$ckDI"><field name="categoria">DI</field>&nl;</xsl:if>
 <xsl:if test="$ckDC"><field name="categoria">DC</field>&nl;</xsl:if>
 <xsl:if test="$ckTD"><field name="categoria">TD</field>&nl;</xsl:if>
 <xsl:if test="$ckCL"><field name="categoria">CL</field>&nl;</xsl:if>

 <xsl:variable name="categ">
 <xsl:choose>
   <xsl:when test="$L7='a' and $L8='m'">LI</xsl:when>
   <xsl:when test="$L7='c'">SS</xsl:when>
   <xsl:when test="$L7='d'">SM</xsl:when>
   <xsl:when test="$L7='e'">CS</xsl:when>
   <xsl:when test="$L7='f'">CM</xsl:when>
   <xsl:when test="$L7='g'">AV</xsl:when>
   <xsl:when test="$L7='i'">SO</xsl:when>
   <xsl:when test="$L7='j'">RM</xsl:when>
   <xsl:when test="$L7='k'">GR</xsl:when>
   <xsl:when test="$L7='l'">EL</xsl:when>
   <xsl:when test="$L7='m'">MM</xsl:when>
   <xsl:when test="$L7='r'">AT</xsl:when>
 </xsl:choose>
 </xsl:variable>
 <xsl:if test="$categ!=''">
	<field name="categoria"><xsl:value-of select="$categ"/></field>&nl;
 </xsl:if>

 <xsl:variable name="nat">
  <xsl:choose>
   <xsl:when test="$L8='a'">CB</xsl:when>
   <xsl:when test="$L8='c'">CO</xsl:when>
   <xsl:when test="$L8='s'">PE</xsl:when>
   <xsl:when test="$L8='z'">MS</xsl:when>
  </xsl:choose>
 </xsl:variable>

 <xsl:if test="$nat!=''">
	<field name="categoria"><xsl:value-of select="$nat"/></field>&nl;
 </xsl:if>

 <xsl:if test="($nat='') and ($categ='') and not($ckED) and not($ckDI) and not($ckDC) and not(ckTD) and not(ckCL)">
	<field name="categoria">AL</field>&nl;
 </xsl:if>

</xsl:template>


	<!-- filtri:	lingua -->

 <xsl:template name="lingua" >
 <xsl:for-each select="df[@t=101]/sf[@c='a']">
 	<field name="lingua"><xsl:value-of select="."/></field>&nl;
 </xsl:for-each>
 </xsl:template>


	<!-- filtri:	paese -->

 <xsl:template name="paese" >
  <xsl:for-each select="df[@t=102]/sf[@c='a']">
    <xsl:if test="(.!='') and (.!='  ')"><field name="paese_fc"><xsl:value-of select="."/></field>&nl;</xsl:if>
  </xsl:for-each>
 </xsl:template>


	<!-- filtri:	data_ins -->

 <xsl:template name="data_ins" >
   <field name="data_ins"><xsl:value-of select="substring(df[@t=100]/sf[@c='a'],1,8)"/></field>&nl;
 </xsl:template>


	<!-- filtri:	anno1 / annopub_fc -->

 <xsl:template name="anno1" >
   <xsl:variable name="dt" select="substring(df[@t=100]/sf[@c='a'],10,4)"/>
   <xsl:if test="$dt!='0000' and $dt!='9999' and $dt!='    '">
     <field name="anno1"><xsl:value-of select="$dt"/></field>&nl;
     <xsl:variable name="range">
     <xsl:choose>
        <xsl:when test="$dt &lt; 1440">- 1439</xsl:when>
        <xsl:when test="($dt &gt; 1439) and ($dt &lt; 1501)">1440 - 1500</xsl:when>
        <xsl:when test="($dt &gt; 1500) and ($dt &lt; 1600)">1501 - 1599</xsl:when>
        <xsl:when test="($dt &gt; 1599) and ($dt &lt; 1651)">1600 - 1650</xsl:when>
        <xsl:when test="($dt &gt; 1650) and ($dt &lt; 1700)">1651 - 1699</xsl:when>
        <xsl:when test="($dt &gt; 1699) and ($dt &lt; 1751)">1700 - 1750</xsl:when>
        <xsl:when test="($dt &gt; 1750) and ($dt &lt; 1800)">1751 - 1799</xsl:when>
        <xsl:when test="($dt &gt; 1799) and ($dt &lt; 1831)">1800 - 1830</xsl:when>
        <xsl:when test="($dt &gt; 1830) and ($dt &lt; 1861)">1831 - 1860</xsl:when>
        <xsl:when test="($dt &gt; 1860) and ($dt &lt; 1886)">1861 - 1885</xsl:when>
        <xsl:when test="($dt &gt; 1885) and ($dt &lt; 1900)">1886 - 1899</xsl:when>
        <xsl:when test="($dt &gt; 1899) and ($dt &lt; 1921)">1900 - 1920</xsl:when>
        <xsl:when test="($dt &gt; 1920) and ($dt &lt; 1941)">1921 - 1940</xsl:when>
        <xsl:when test="($dt &gt; 1940) and ($dt &lt; 1961)">1941 - 1960</xsl:when>
        <xsl:when test="($dt &gt; 1960) and ($dt &lt; 1981)">1961 - 1980</xsl:when>
        <xsl:when test="($dt &gt; 1980) and ($dt &lt; 2001)">1981 - 2000</xsl:when>
        <xsl:when test="($dt &gt; 2000)">2001 -</xsl:when>
     </xsl:choose>
     </xsl:variable>
      <xsl:if test="$range!=''">
          <field name="annopub_fc"><xsl:value-of select="$range"/></field>&nl;
      </xsl:if>
   </xsl:if>
 </xsl:template>


	<!-- filtri:	anno2 -->

 <xsl:template name="anno2" >
   <xsl:variable name="dt" select="substring(df[@t=100]/sf[@c='a'],14,4)"/>
   <xsl:if test="$dt!='0000' and $dt!='9999' and $dt!='    '">
     <field name="anno2"><xsl:value-of select="$dt"/></field>&nl;
   </xsl:if>
 </xsl:template>


	<!-- filtri:	natura -->
	<!--
		CB : Contributo
		CO : Collana
		MO : Monografia
		PE : Periodico
		MS : Manoscritto
	-->

 <xsl:template name="natura" >
	<xsl:variable name="nat" select="substring(/rec/lab,8,1)"/>
  <xsl:choose>
    <xsl:when test="$nat='a'">	<field name="natura">CB</field>&nl;</xsl:when>
    <xsl:when test="$nat='c'">	<field name="natura">CO</field>&nl;</xsl:when>
    <xsl:when test="$nat='m'">	<field name="natura">MO</field>&nl;</xsl:when>
    <xsl:when test="$nat='s'">	<field name="natura">PE</field>&nl;</xsl:when>
    <xsl:when test="$nat='z'">	<field name="natura">MS</field>&nl;</xsl:when>
  </xsl:choose>
 </xsl:template>


	<!-- filtri:	tipomat -->

 <xsl:template name="tipomat" >
  <field name="tipomat"><xsl:value-of select="substring(/rec/lab,7,1)"/></field>&nl;
 </xsl:template>


	<!-- filtri:	biblioteca -->

 <xsl:template name="biblioteca" >
    <xsl:for-each select="df[@t='950']/sf[@c='d' or @c='e'][1]">
	<field name="biblioteca"><xsl:value-of select="substring(.,1,2)"/></field>&nl;
   </xsl:for-each>
	<xsl:apply-templates select="df[@t=960]" mode="codbib-group"/>
 </xsl:template>


<!-- ========================================== -->
<!--   960 : raggruppamento delle biblioteche   -->
<!-- ========================================== -->
<xsl:template match="df[@t=960]" mode="codbib-group">
 <xsl:variable name="current" select="substring(sf[@c='e'],1,2)"/>
 <xsl:variable name="preceding" select="substring(preceding-sibling::df[@t=960][1]/sf[@c='e'],1,2)"/>
 <xsl:if test="((position()=1) or ($current!=$preceding)) and ($current!='')">
	<field name="biblioteca"><xsl:value-of select="$current"/></field>&nl;
 </xsl:if>
</xsl:template>





	<!-- filtri:	tipodig -->

 <xsl:template name="tipodig" >
   <xsl:variable name="td" select="df[@t=956]/@i2|df[@t=856]/@i2"/>
 <xsl:if test="$td != ''">
 <field name="tipodig">
	<xsl:choose>
	  <xsl:when test="$td=0">a</xsl:when>
	  <xsl:when test="$td=1">b</xsl:when>
	  <xsl:when test="$td=2">c</xsl:when>
	  <xsl:when test="$td=4">d</xsl:when>
	</xsl:choose>
 </field>&nl;
 </xsl:if>
 </xsl:template>



	<!-- ==============  templates per il display ==============  -->


		<!-- titolo display (titolo_dp, titolo_srt) -->

 <xsl:template name="titolo" >

     <xsl:variable name="titolo_dp"><xsl:call-template name="titolo_dp"/></xsl:variable>
     <xsl:variable name="titolo_srt">
	<xsl:call-template name="cutSort">
		<xsl:with-param name="string" select="$titolo_dp"/>
	</xsl:call-template>
     </xsl:variable>

     <field name="titolo_dp"><xsl:value-of select="$titolo_dp"/></field>&nl;
     <field name="titolo_srt"><xsl:value-of select="normalize-space($titolo_srt)"/></field>&nl;

</xsl:template>



		<!-- titolo_dp -->

 <xsl:template name="titolo_dp" >
   <xsl:call-template name="trim">
    <xsl:with-param name="s">

     <xsl:for-each select="df[@t=200]">
        <xsl:value-of select="sf[@c='a']"/>

        <xsl:variable name="ind" select="@i1"/>
        <xsl:if test="$ind=0">
         <xsl:choose>
          <xsl:when test="/rec/df[@t=461]/s1/df[@t=200]">
                <xsl:text> --&gt; </xsl:text>
                <xsl:call-template name="snippet461"/>
          </xsl:when>
          <xsl:when test="/rec/df[@t=462]/s1/df[@t=200]">
                <xsl:text> --&gt; </xsl:text>
                <xsl:call-template name="snippet462"/>
          </xsl:when>
         </xsl:choose>
        </xsl:if>

        <xsl:if test="sf[@c='c' or @c='d' or @c='h' or @c='i']">
		<xsl:text> </xsl:text>
        	<xsl:call-template name="subfieldSelect">
                	<xsl:with-param name="codes">cdhi</xsl:with-param>
                	<xsl:with-param name="delimiter"> </xsl:with-param>
        	</xsl:call-template>
        </xsl:if>
        <xsl:if test="sf[@c='e']"> : <xsl:value-of select="sf[@c='e']"/> </xsl:if>
                                                                                                
        <xsl:if test="/rec/df[@t=205]/sf[@c='a']">
          <xsl:text>. </xsl:text>
          <xsl:call-template name="snippet205"/>
        </xsl:if>

        <xsl:variable name="ediz" select="translate(/rec/df[@t=210]/sf[@c='c'],'sn','SN')"/>
        <xsl:if test="$ediz and not(contains($ediz,'S.N.') or contains($ediz,'S. N.'))">
          <xsl:text> - </xsl:text>
          <xsl:value-of select="/rec/df[@t=210]/sf[@c='c']"/>
        </xsl:if>
     </xsl:for-each>

   </xsl:with-param>
  </xsl:call-template>
 </xsl:template>


		<!-- accesori  per titolo display -->
 <xsl:template name="snippet461" >
  <xsl:for-each select="/rec/df[@t=461]/s1/df[@t=200]">
	<xsl:text> </xsl:text>
        <xsl:call-template name="subfieldSelect">
                <xsl:with-param name="codes">adchi</xsl:with-param>
        </xsl:call-template>
        <xsl:if test="sf[@c='e']"> : <xsl:value-of select="sf[@c='e']"/> </xsl:if>
  </xsl:for-each>
 </xsl:template>

 <xsl:template name="snippet462" >
 <xsl:for-each select="/rec/df[@t=462]">
	<xsl:text> </xsl:text>
        <xsl:call-template name="subfieldSelect">
                <xsl:with-param name="codes">adchi</xsl:with-param>
        </xsl:call-template>
        <xsl:if test="sf[@c='e']"> : <xsl:value-of select="sf[@c='e']"/> </xsl:if>
 </xsl:for-each>
 </xsl:template>


 <xsl:template name="snippet205" >
 <xsl:for-each select="/rec/df[@t=205]">
        <xsl:text> </xsl:text>
        <xsl:call-template name="subfieldSelect">
                <xsl:with-param name="codes">adgfb</xsl:with-param>
        </xsl:call-template>
 </xsl:for-each>
 </xsl:template>



 <!-- fopera -->

<xsl:template name="opera_fc" >

 <xsl:if test="df[@t=700]">
  <xsl:variable name="autore">
   <xsl:call-template name="trim">
	<xsl:with-param name="s">
	<xsl:value-of select="df[@t=700]/sf[@c='a']"/>
	<xsl:value-of select="df[@t=700]/sf[@c='b']"/>
	</xsl:with-param>
   </xsl:call-template>
  </xsl:variable>

  <xsl:variable name="titolo">
   <xsl:choose>
    <xsl:when test="(df[@t=500]/sf[@c='9'] != df[@t=700]/sf[@c='3']) and (df[@t=500]/sf[@c='a'] != '')">
	<xsl:text> </xsl:text>
	<xsl:call-template name="trim">
		<xsl:with-param name="s" select="df[@t=500]/sf[@c='a']"/>
	</xsl:call-template>
    </xsl:when>
    <xsl:when test="df[@t=200]/sf[@c='a']!=''">
	<xsl:text> </xsl:text>
	<xsl:call-template name="trim">
		<xsl:with-param name="s" select="df[@t=200]/sf[@c='a']"/>
	</xsl:call-template>
    </xsl:when>
   </xsl:choose>
  </xsl:variable>

 <xsl:variable name="uppercase" select="'ABCDEFGHIJKLMNOPQRSTUVWXYZ'" />
 <xsl:variable name="smallcase" select="'abcdefghijklmnopqrstuvwxyz'" />
 <field name="opera_fc"><xsl:value-of select="translate($autore, $uppercase, $smallcase)"/><xsl:if test="$titolo"><xsl:text>.</xsl:text></xsl:if><xsl:value-of select="translate($titolo, $uppercase, $smallcase)"/></field>&nl;
 </xsl:if>

</xsl:template>


	<!-- ==============  templates per le liste / canali di ricerca  ==============  -->


 <!-- titoli : per la lista dei titoli -->

 <xsl:template name="titoli" >

 <xsl:for-each select="df[@t=200]">
    <field name="titolo">
        <xsl:variable name="ind" select="@i1"/>
	<xsl:if test="$ind=1">
		<xsl:call-template name="subfieldSelect">
			<xsl:with-param name="codes">ahi</xsl:with-param>
		</xsl:call-template>
	</xsl:if>
    </field>&nl;
 </xsl:for-each>

  <!-- titoli contenuti in 4xx -->
 <xsl:for-each select="df[@t=421]/s1/df[@t=200]|df[@t=422]/s1/df[@t=200]|df[@t=423]/s1/df[@t=200]|df[@t=430]/s1/df[@t=200]|df[@t=431]/s1/df[@t=200]|df[@t=434]/s1/df[@t=200]|df[@t=440]/s1/df[@t=200]|df[@t=441]/s1/df[@t=200]|df[@t=444]/s1/df[@t=200]|df[@t=454]/s1/df[@t=200]">
    <field name="titolo">
	<xsl:call-template name="subfieldSelect">
		<xsl:with-param name="codes">ahi</xsl:with-param>
	</xsl:call-template>
    </field>&nl;
 </xsl:for-each>

  <!-- titoli 500 - ->
  <xsl:for-each select="df[@t=500]">
    <field name="titolo">
	<xsl:call-template name="subfieldSelect">
		<xsl:with-param name="codes">a</xsl:with-param>
	</xsl:call-template>
	<xsl:if test="position()&lt;last()"><xsl:text> </xsl:text></xsl:if>
    </field>&nl;
  </xsl:for-each>
  -->

  <!-- titoli 500 -->
  <xsl:for-each select="df[@t=500]/sf[@c='a']">
    <field name="titolo">
	<xsl:call-template name="trim"><xsl:with-param name="s" select="."/></xsl:call-template>
    </field>&nl;
  </xsl:for-each>

  <!-- titoli 5xx -->
  <xsl:for-each select="df[@t=510]|df[@t=517]|df[@t=520]|df[@t=530]|df[@t=531]|df[@t=532]">
    <field name="titolo"><xsl:call-template name="trim"><xsl:with-param name="s" select="sf[@c='a']"/></xsl:call-template></field>&nl;
  </xsl:for-each>

 </xsl:template>


 <!-- autore1   tags: 700, 720-->
		<!-- titolo display (titolo_dp, titolo_srt) -->

 <xsl:template name="autore1" >

     <xsl:variable name="autore_dp"><xsl:call-template name="autore_dp"/></xsl:variable>
     <xsl:variable name="autore_srt">
	<xsl:call-template name="cutSort">
		<xsl:with-param name="string" select="$autore_dp"/>
		<xsl:with-param name="within" select="10"/>
	</xsl:call-template>
     </xsl:variable>

     <field name="autore_dp"><xsl:value-of select="$autore_dp"/></field>&nl;
     <field name="autore_srt"><xsl:value-of select="normalize-space($autore_srt)"/></field>&nl;

</xsl:template>


 <!-- TODO: separatore fra le varie occorenze ? - per ora solo spazio -->
 <xsl:template name="autore_dp" >
	 <xsl:for-each select="df[@t=700]|df[@t=710]">
		<xsl:value-of select="sf[@c='a']"/><xsl:value-of select="sf[@c='b']"/>
		<xsl:if test="sf[@c='c'] != ''">
                       <xsl:text> </xsl:text><xsl:value-of select="sf[@c='c']"/></xsl:if>
                <xsl:if test="sf[@c='f'] != ''">
                       <xsl:text> </xsl:text><xsl:value-of select="sf[@c='f']"/></xsl:if>
		<xsl:if test="position()&lt;last()"><xsl:text> </xsl:text></xsl:if>
	</xsl:for-each>
 </xsl:template>


 <xsl:template name="autore_fc" >
    <xsl:call-template name="trim">
	<xsl:with-param name="s"><xsl:value-of select="sf[@c='a']"/><xsl:value-of select="sf[@c='b']"/></xsl:with-param>
    </xsl:call-template>
    <xsl:if test="sf[@c='c'] != ''"><xsl:text> </xsl:text><xsl:value-of select="sf[@c='c']"/></xsl:if><xsl:if test="sf[@c='f'] != ''"><xsl:text> </xsl:text><xsl:value-of select="sf[@c='f']"/></xsl:if><xsl:if test="sf[@c='e'] != ''"><xsl:text> </xsl:text><xsl:value-of select="sf[@c='e']"/></xsl:if>
 </xsl:template>

 <!-- autore (tutti): autore_fc, autore_kw   tags: 700,701,702,710,711,712,790,791,900,910 -->

 <xsl:template name="autore" >
 <xsl:for-each select="df[@t=700]|df[@t=701]|df[@t=702]|df[@t=710]|df[@t=711]|df[@t=712]|df[@t=790]|df[@t=791]|df[@t=900]|df[@t=910]">
     <xsl:variable name="autore_fc"><xsl:call-template name="autore_fc"/></xsl:variable>

	<field name="autore_fc"><xsl:value-of select="normalize-space($autore_fc)"/></field>&nl;

	<field name="autore_kw">
		<xsl:value-of select="sf[@c='a']"/><xsl:value-of select="sf[@c='b']"/>
		<xsl:if test="sf[@c='c'] != ''">
                       <xsl:text> </xsl:text><xsl:value-of select="sf[@c='c']"/></xsl:if>
		<xsl:if test="sf[@c='d'] != ''">
                       <xsl:text> </xsl:text><xsl:value-of select="sf[@c='d']"/></xsl:if>
		<xsl:if test="sf[@c='f'] != ''">
                       <xsl:text> </xsl:text><xsl:value-of select="normalize-space(sf[@c='f'])"/></xsl:if>
		<xsl:if test="sf[@c='e'] != ''">
                       <xsl:text> </xsl:text><xsl:value-of select="normalize-space(sf[@c='e'])"/></xsl:if>
	</field>&nl;
	<!--
	<xsl:attribute name="vid"><xsl:value-of select="node()[@c='3']"/></xsl:attribute>
	-->
 </xsl:for-each>
 </xsl:template>


 		<!-- soggetto    tags: 600,601,602,603,605,606,607,610 -->

 <xsl:template name="soggetto" >

	<xsl:variable name="smallcase" select="'abcdefghijklmnopqrstuvwxyz'" />
	<xsl:variable name="uppercase" select="'ABCDEFGHIJKLMNOPQRSTUVWXYZ'" />

 <xsl:for-each select="df[@t=605]">
    <field name="soggetto_text"><xsl:call-template name="subfieldSelect"><xsl:with-param name="codes">aixkn</xsl:with-param><xsl:with-param name="delimiter"> - </xsl:with-param></xsl:call-template></field>&nl;
    <field name="soggetto_cid"><xsl:value-of select="node()[@c='3']"/></field>&nl;
 </xsl:for-each>

 <xsl:for-each select="df[@t=606]">
    <field name="soggetto_cid"><xsl:value-of select="node()[@c='3']"/></field>&nl;
    <field name="soggetto_text"><xsl:call-template name="subfieldSelect"><xsl:with-param name="codes">abcfxyz</xsl:with-param><xsl:with-param name="delimiter"> - </xsl:with-param></xsl:call-template></field>&nl;
    <field name="tiposogg"><xsl:value-of select="translate(node()[@c='2'], $uppercase, $smallcase)"/></field>&nl;
 </xsl:for-each>

 <xsl:for-each select="df[@t=600]|df[@t=601]|df[@t=602]|df[@t=603]|df[@t=607]|df[@t=610]">
    <field name="soggetto_cid"><xsl:value-of select="node()[@c='3']"/></field>&nl;
    <field name="soggetto_text"><xsl:call-template name="subfieldSelect"><xsl:with-param name="codes">abcfxyz</xsl:with-param><xsl:with-param name="delimiter"> - </xsl:with-param></xsl:call-template></field>&nl;
 </xsl:for-each>

 <xsl:for-each select="df[@t=969]">
    <field name="soggetto_text"><xsl:value-of select="sf[@c='a']"/></field>&nl;
    <field name="soggetto_text"><xsl:value-of select="sf[@c='y']|sf[@c='z']"/></field>&nl;
<!--
  <xsl:if test="sf[@c='y']">
    <field name="soggetto_text"><xsl:value-of select="sf[@c='y']"/></field>&nl;
  </xsl:if>
  <xsl:if test="sf[@c='z']">
    <field name="soggetto_text"><xsl:value-of select="sf[@c='z']"/></field>&nl;
  </xsl:if>
-->
 </xsl:for-each>

 </xsl:template>

 		<!-- descrittore    tags: 606 -->

 <xsl:template name="descrittore" >

 <xsl:for-each select="df[@t=606]/sf[@c='a']|df[@t=606]/sf[@c='x']">
    <xsl:call-template name="extractDescrittori"><xsl:with-param name="s" select="."/></xsl:call-template>
 </xsl:for-each>

 <field name="descrittore_kw">
 <xsl:for-each select="df[@t=606]/sf[@c='a']|df[@t=606]/sf[@c='x']">
    <xsl:call-template name="removeConnettivi"><xsl:with-param name="s" select="."/></xsl:call-template>
    <xsl:if test="@c='a'"><xsl:text> </xsl:text></xsl:if>
 </xsl:for-each>
 </field>&nl;

 <xsl:for-each select="df[@t=969]/sf[@c='a']|df[@t=969]/sf[@c='y']|df[@t=969]/sf[@c='z']">
    <xsl:call-template name="extractDescrittori"><xsl:with-param name="s" select="."/></xsl:call-template>
    <field name="descrittore_kw"><xsl:call-template name="trim"><xsl:with-param name="s" select="."/></xsl:call-template></field>&nl;
 </xsl:for-each>

 </xsl:template>

 <xsl:template name="removeConnettivi" >
  <xsl:param name="s"/>
  <xsl:if test="$s != ''">
     <xsl:choose>
       <xsl:when test="contains($s,'[')">
         <xsl:value-of select="substring-before($s,'[')"/>
         <xsl:if test="contains($s,']')">
             <xsl:call-template name="removeConnettivi">
               <xsl:with-param name="s" select="substring-after($s,']')"/>
             </xsl:call-template>
         </xsl:if>
       </xsl:when>
       <xsl:otherwise>
         <xsl:call-template name="trim"><xsl:with-param name="s" select="$s"/></xsl:call-template>
       </xsl:otherwise>
     </xsl:choose>
  </xsl:if>
</xsl:template>


 <xsl:template name="extractDescrittori" >
  <xsl:param name="s"/>
  <xsl:choose>
    <xsl:when test="contains($s,'[')">
       <field name="descrittore_fc"><xsl:call-template name="trim">
             <xsl:with-param name="s" select="substring-before($s,'[')"/></xsl:call-template></field>&nl;
       <xsl:if test="contains($s,']')">
          <xsl:call-template name="extractDescrittori">
              <xsl:with-param name="s" select="substring-after($s,']')"/>
          </xsl:call-template>
       </xsl:if>
    </xsl:when>
    <xsl:otherwise>
       <xsl:if test="$s != ''">
           <field name="descrittore_fc"><xsl:call-template name="trim">
                <xsl:with-param name="s" select="$s"/></xsl:call-template></field>&nl;
       </xsl:if>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>


		<!-- classi -->


 <xsl:template name="classi" >
  <xsl:for-each select="df[@t=676]">
    <field name="dewey_cod1"><xsl:value-of select="substring(node()[@c='a'],1,1)"/></field>&nl;
    <field name="dewey_cod2"><xsl:value-of select="substring(node()[@c='a'],1,2)"/></field>&nl;
    <field name="dewey_cod3"><xsl:value-of select="substring(node()[@c='a'],1,3)"/></field>&nl;
    <field name="dewey_cod"><xsl:value-of select="node()[@c='a']"/></field>&nl;
    <field name="deweyediz_fc"><xsl:value-of select="node()[@c='v']"/></field>&nl;
    <field name="dewey_text"><xsl:call-template name="trim"><xsl:with-param name="s" select="node()[@c='9']"/></xsl:call-template></field>&nl;
    <field name="dewey"><xsl:call-template name="fixedlen"><xsl:with-param name="s" select="node()[@c='a']"/><xsl:with-param name="len" select="30"/></xsl:call-template><xsl:call-template name="trim"><xsl:with-param name="s" select="node()[@c='9']"/></xsl:call-template></field>&nl;
  </xsl:for-each>
 </xsl:template>




	<!-- =========  templates per i canali di ricerca ==============  -->

	<!-- 1. keywords degli autori ricavati dalle liste -->
	<!-- 3. keywords dei soggetti ricavati dalle liste -->
	<!-- 5. codici delle classi ricavati dalle liste -->
	<!-- 6. keywords delle classi ricavati dalle liste -->



		<!-- titolo_kw:	keywords titolo -->

 <xsl:template name="titolo_kw" >
   <xsl:if test="df[@t=200]">
  <field name="titolo_kw">
   <xsl:call-template name="trim">
    <xsl:with-param name="s">

    <xsl:variable name="ind" select="df[@t=200]/@i1"/>
    <xsl:choose>
      <xsl:when test="$ind=0">
         <xsl:choose>
           <xsl:when test="/rec/df[@t=461]/s1/df[@t=200]">
	     <xsl:for-each select="/rec/df[@t=461]/s1/df[@t=200]">
		<xsl:call-template name="subfieldSelect">
			<xsl:with-param name="codes">acdhi</xsl:with-param>
		</xsl:call-template>
		<xsl:text> </xsl:text>
	     </xsl:for-each>
          </xsl:when>
          <xsl:when test="/rec/df[@t=462]/s1/df[@t=200]">
	     <xsl:for-each select="/rec/df[@t=462]/s1/df[@t=200]">
		<xsl:call-template name="subfieldSelect">
			<xsl:with-param name="codes">acdhi</xsl:with-param>
		</xsl:call-template>
		<xsl:text> </xsl:text>
	     </xsl:for-each>
          </xsl:when>
	  <xsl:otherwise>
		<!-- TODO: segnalare errore -->
	  </xsl:otherwise>
         </xsl:choose>
      </xsl:when>
      <xsl:otherwise>
	     <xsl:for-each select="df[@t=200]">
		<xsl:call-template name="subfieldSelect">
			<xsl:with-param name="codes">acdhi</xsl:with-param>
		</xsl:call-template>
		<xsl:text> </xsl:text>
	     </xsl:for-each>
      </xsl:otherwise>
    </xsl:choose>

    </xsl:with-param>
   </xsl:call-template>
  </field>&nl;
  </xsl:if>

  <xsl:for-each select="df[@t=510]/sf[@c='a']|df[@t=517]/sf[@c='a']|df[@t=520]/sf[@c='a']|df[@t=530]/sf[@c='a']|df[@t=531]/sf[@c='a']|df[@t=532]/sf[@c='a']">
   <field name="titolo_kw"><xsl:value-of select="sf[@c='a']"/></field>&nl;
  </xsl:for-each>

  <xsl:for-each select="df[@t=500]">
   <field name="titolo_kw">
	<xsl:call-template name="subfieldSelect">
		<xsl:with-param name="codes">abcdeimn</xsl:with-param>
	</xsl:call-template>
   </field>&nl;
  </xsl:for-each>

  <!-- 200 contenute in 4xx -->
 <xsl:for-each select="df[@t=421]/s1/df[@t=200]|df[@t=422]/s1/df[@t=200]|df[@t=423]/s1/df[@t=200]|df[@t=430]/s1/df[@t=200]|df[@t=431]/s1/df[@t=200]|df[@t=434]/s1/df[@t=200]|df[@t=440]/s1/df[@t=200]|df[@t=441]/s1/df[@t=200]|df[@t=444]/s1/df[@t=200]|df[@t=454]/s1/df[@t=200]">
   <field name="titolo_kw">
	<xsl:call-template name="subfieldSelect">
		<xsl:with-param name="codes">acdhi</xsl:with-param>
	</xsl:call-template>
  </field>&nl;
  </xsl:for-each>

 </xsl:template>


	
		<!-- collana	-->


 <xsl:template name="collana" >
  <xsl:for-each select="df[@t=225]">
  <field name="collana_kw">
	<xsl:call-template name="subfieldSelect">
		<xsl:with-param name="codes">adefhi</xsl:with-param>
	</xsl:call-template>
  </field>&nl;
  </xsl:for-each>
 </xsl:template>


		<!-- editore	-->

 <xsl:template name="editore" >
 <xsl:for-each select="df[@t=210]">

   <xsl:variable name="ucC" select="translate(/rec/df[@t=210]/sf[@c='c'],'sn','SN')"/>
   <xsl:variable name="C210"><xsl:if test="$ucC and not(contains($ucC,'S.N.') or contains($ucC,'S. N.'))"><xsl:value-of select="/rec/df[@t=210]/sf[@c='c']"/></xsl:if></xsl:variable>
   <xsl:variable name="F210" select="sf[@c='f']"/>
   <xsl:variable name="editore"><xsl:value-of select="$C210"/><xsl:if test="$C210 != '' and $F210 != ''"><xsl:text> </xsl:text><xsl:value-of select="$F210"/></xsl:if></xsl:variable>

    <xsl:if test="$editore != ''">
	<field name="editore_kw"><xsl:value-of select="$editore"/></field>&nl;
    </xsl:if>
    <xsl:if test="$C210 != ''">
	<field name="editore_fc"><xsl:value-of select="$C210"/></field>&nl;
    </xsl:if>
 </xsl:for-each>

 <xsl:for-each select="df[@t=712]">
   <xsl:variable name="tg" select="substring(sf[@c='4'],1,3)"/>
   <!-- if substring(1,3) = 650  -->
   <xsl:if test="$tg='650'">
    <field name="editore_kw"><xsl:call-template name="trim"><xsl:with-param name="s" select="./sf[@c='a']"/></xsl:call-template></field>&nl;
   </xsl:if>
 </xsl:for-each>
 </xsl:template>



		<!-- luoghi:  -->

 <xsl:template name="luoghi" >
  <xsl:for-each select="df[@t=210]/sf[@c='a']|df[@t=620]/df[@c='d']">
    <field name="luogo_kw"><xsl:call-template name="trim"><xsl:with-param name="s" select="."/></xsl:call-template></field>&nl;
  </xsl:for-each>
 </xsl:template>


		<!-- identificatori	-->

		<!-- numeri standard  tags: 010,011,012,013,020,071,090 -->

 <xsl:template name="identificatori" >
 <xsl:for-each select="df[@t=020]">
    <field name="identificatore_kw">
		<xsl:call-template name="subfieldSelect">
			<xsl:with-param name="codes">bz</xsl:with-param>
		</xsl:call-template>
    </field>&nl;
 </xsl:for-each>
 <xsl:for-each select="df[@t=225]/sf[@c='x']">
    <field name="dentificatore_kw"><xsl:value-of select="."/></field>&nl;
 </xsl:for-each>

 <xsl:for-each select="df[@t=010]|df[@t=011]|df[@t=013]|df[@t=012]|df[@t=071]|df[@t=090]">
    <field name="identificatore_kw">
		<xsl:call-template name="subfieldSelect">
			<xsl:with-param name="codes">az</xsl:with-param>
		</xsl:call-template>
    </field>&nl;
 </xsl:for-each>
 </xsl:template>


		<!-- marca	-->

 <xsl:template name="marca" >
 <xsl:for-each select="df[@t=921]/sf[@c='b']">
	<field name="marca_kw"><xsl:value-of select="."/></field>&nl;
 </xsl:for-each>
 </xsl:template>


		<!-- colloc	-->

 <xsl:template name="colloc" >
 <xsl:for-each select="df[@t=950]/sf[@c='f']">
	<field name="collocazione_kw"><xsl:value-of select="."/></field>&nl;
 </xsl:for-each>
 <xsl:for-each select="df[@t=960]/sf[@c='g']">
	<field name="collocazione_kw"><xsl:value-of select="."/></field>&nl;
 </xsl:for-each>
 </xsl:template>

		<!-- inventario	950$e, 960$g-->

 <xsl:template name="inventario" >
    <xsl:for-each select="df[@t=950]/sf[@c='e']">
	<field name="inventario_kw"><xsl:value-of select="substring(.,1,11)"/></field>&nl;
    </xsl:for-each>
    <xsl:for-each select="df[@t=960]/sf[@c='e']">
	<field name="inventario_kw"><xsl:value-of select="translate(substring(.,1,4),' ','0')"/><xsl:value-of select="substring(.,8,7)"/></field>&nl;
    </xsl:for-each>
 </xsl:template>



	<!-- keywords -->
	<!-- sono da considerare anche i precedenti canali di ricerca
	 !   tranne i titoli che vengono inseriti qui completamente
	 !-->


<xsl:template name="keywords" >
  <xsl:call-template name="keywords_titoli"/>
  <xsl:call-template name="keywords_mid"/>
  <xsl:call-template name="keywords_note"/>
  <xsl:call-template name="keywords_205"/>
  <xsl:call-template name="keywords_206"/>
  <xsl:call-template name="keywords_207"/>
  <xsl:call-template name="keywords_208"/>
  <xsl:call-template name="keywords_215"/>
  <xsl:call-template name="keywords_686"/>
  <xsl:call-template name="keywords_950e"/>

</xsl:template>


		<!-- keywords:  titoli  -->

<xsl:template name="keywords_titoli" >

  <xsl:for-each select="df[@t=200]|df[@t=500]|df[@t=510]|df[@t=517]|df[@t=520]|df[@t=530]|df[@t=531]|df[@t=532]|df[@t=421]/s1/df[@t=200]|df[@t=422]/s1/df[@t=200]|df[@t=423]/s1/df[@t=200]|df[@t=430]/s1/df[@t=200]|df[@t=431]/s1/df[@t=200]|df[@t=434]/s1/df[@t=200]|df[@t=440]/s1/df[@t=200]|df[@t=441]/s1/df[@t=200]|df[@t=444]/s1/df[@t=200]|df[@t=454]/s1/df[@t=200]">
	<field name="titoli_kw">
	<xsl:call-template name="trim">
	<xsl:with-param name="s">
	  <xsl:for-each select="sf">
		<xsl:value-of select="."/>
		<xsl:if test="position()&lt;last()"><xsl:text> </xsl:text></xsl:if>
	  </xsl:for-each>
	</xsl:with-param>
	</xsl:call-template>
	</field>&nl;
  </xsl:for-each>

</xsl:template>



		<!-- keywords:  mid -->

 <xsl:template name="keywords_mid" >
  <xsl:for-each select="df[@t=921]/sf[@c='3']">
	<field name="mid_kw"><xsl:value-of select="."/></field>&nl;
  </xsl:for-each>
 </xsl:template>


	<!-- keywords:  note /  tags: 300-308,310-316,320,321,324,326,327,328,330,337 -->

 <xsl:template name="keywords_note" >
 <xsl:for-each select="df[@t=300]|df[@t=301]|df[@t=302]|df[@t=303]|df[@t=304]|df[@t=305]|df[@t=306]|df[@t=307]|df[@t=308]|df[@t=310]|df[@t=311]|df[@t=312]|df[@t=313]|df[@t=314]|df[@t=315]|df[@t=316]|df[@t=320]|df[@t=321]|df[@t=324]|df[@t=326]|df[@t=327]|df[@t=328]|df[@t=330]|df[@t=337]">
 <field name="note_kw"><xsl:call-template name="trim"><xsl:with-param name="s" select="sf[@c='a']"/></xsl:call-template></field>&nl;
 </xsl:for-each>
 </xsl:template>



		<!-- keywords:   edizione / 205 -->

 <xsl:template name="keywords_205" >
 <xsl:for-each select="df[@t=205]/sf">
	<field name="205_kw"><xsl:call-template name="trim"><xsl:with-param name="s" select="."/></xsl:call-template></field>&nl;
 </xsl:for-each>
 </xsl:template>


		<!-- keywords:   206 (materiale cartogr.)-->

 <xsl:template name="keywords_206" >
 <xsl:for-each select="df[@t=206]/sf">
	<field name="206_kw"><xsl:call-template name="trim"><xsl:with-param name="s" select="."/></xsl:call-template></field>&nl;
 </xsl:for-each>
 </xsl:template>


		<!-- keywords:   207 (materiale specif. serials numbering)-->

 <xsl:template name="keywords_207" >
 <xsl:for-each select="df[@t=207]/sf">
	<field name="207_kw"><xsl:call-template name="trim"><xsl:with-param name="s" select="."/></xsl:call-template></field>&nl;
 </xsl:for-each>
 </xsl:template>


		<!-- keywords:   208 (materiale specif. printed music)-->

 <xsl:template name="keywords_208" >
 <xsl:for-each select="df[@t=208]/sf">
	<field name="208_kw"><xsl:call-template name="trim"><xsl:with-param name="s" select="."/></xsl:call-template></field>&nl;
 </xsl:for-each>
 </xsl:template>

		<!-- keywords:   215 -->

 <xsl:template name="keywords_215" >
 <xsl:for-each select="df[@t=215]/sf[@c='e']">
	<field name="215_kw"><xsl:call-template name="trim"><xsl:with-param name="s" select="."/></xsl:call-template></field>&nl;
 </xsl:for-each>
 </xsl:template>


		<!-- keywords:   686 (other class numbers)-->

 <xsl:template name="keywords_686" >
 <xsl:for-each select="df[@t=686]/sf[@c='a']|df[@t=686]/sf[@c='9']">
	<field name="686_kw"><xsl:call-template name="trim"><xsl:with-param name="s" select="."/></xsl:call-template></field>&nl;
 </xsl:for-each>
 </xsl:template>


		<!-- keywords:   950$e [1-11] -->

 <xsl:template name="keywords_950e" >
 <xsl:for-each select="df[@t=950]/sf[@c='e']">
    <field name="950e_kw"><xsl:call-template name="trim"><xsl:with-param name="s" select="substring(.,1,11)"/></xsl:call-template></field>&nl;
    <field name="950e33_kw"><xsl:call-template name="trim"><xsl:with-param name="s" select="substring(.,33)"/></xsl:call-template></field>&nl;
 </xsl:for-each>
 </xsl:template>
                                                                                                






	<!-- ===== uso nelle keywords e chiavi di accesso per la navigazione ======= -->


		<!--  bid tutti -->

 <xsl:template name="bid_tutti" >

	 <!-- tags: 001 -->
 <xsl:for-each select="cf[@t=001]">
	<field name="bid"><xsl:value-of select="text()"/></field>&nl;
 </xsl:for-each>

 <!-- tags: 410(cf=001) -->
 <xsl:for-each select="df[@t=410]/s1/cf[@t=001]">
	<field name="bid"><xsl:value-of select="text()"/></field>&nl;
 </xsl:for-each>

 <!-- tags: 423(cf=001), 454(cf=001) -->
 <xsl:for-each select="df[@t=423]/s1/cf[@t=001]|df[@t=454]/s1/cf[@t=001]">
	<field name="bid"><xsl:value-of select="text()"/></field>&nl;
 </xsl:for-each>

 <!-- tags: 500(sf=3) -->
 <xsl:for-each select="df[@t=500]/sf[@c='3']">
	<field name="bid"><xsl:value-of select="."/></field>&nl;
 </xsl:for-each>
 <!-- tags: 500(sf=9) con 4. char != 'V' -->
 <!--
 <xsl:for-each select="df[@t=500]/sf[@c='9']">
   <xsl:variable name="v" select="substring(.,4,1)"/>
   <xsl:if test="$v!='V'">
	<field name="bid"><xsl:value-of select="."/></field>&nl;
   </xsl:if>
 </xsl:for-each>
 -->

 </xsl:template>


	 <!-- vid tutti / tags: 700,701,702,710,711,712,900,910 -->

 <xsl:template name="vid_tutti" >
 <xsl:for-each select="df[@t=700]|df[@t=701]|df[@t=702]|df[@t=710]|df[@t=711]|df[@t=712]|df[@t=900]|df[@t=910]">
    <field name="vid"><xsl:value-of select="sf[@c='3']"/></field>&nl;
 </xsl:for-each>
 </xsl:template>


		<!-- cid tutti -->

 <xsl:template name="cid_tutti" >
	 <!-- tags: 600,601,602,603,605,606,607,610 -->
 <xsl:for-each select="df[@t=600]|df[@t=601]|df[@t=602]|df[@t=603]|df[@t=605]|df[@t=606]|df[@t=607]|df[@t=610]">
    <field name="cid"><xsl:value-of select="sf[@c='3']"/></field>&nl;
 </xsl:for-each>
 </xsl:template>



 <!-- END of transformations -->


<!-- ////////////////// included umcutils.xsl ////////////////////////////////// -->

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

<xsl:template name="subfieldSelect">
   <xsl:param name="codes"/>
   <xsl:param name="delimiter"><xsl:text></xsl:text></xsl:param>
   <xsl:variable name="str">
	<xsl:for-each select="sf">
	   <xsl:if test="contains($codes, @c)">
		<xsl:value-of select="text()"/><xsl:value-of select="$delimiter"/>
	   </xsl:if>
	</xsl:for-each>
   </xsl:variable>
   <xsl:call-template name="trim">
	<xsl:with-param name="s" select="substring($str,1,string-length($str)-string-length($delimiter))"/>
   </xsl:call-template>
</xsl:template>

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


<xsl:template name="extractInventario">
  <xsl:param name="inv"/>
      <xsl:value-of select="translate(substring($inv,1,4),' ','0')"/>
      <xsl:value-of select="substring($inv,8,7)"/>
</xsl:template>


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

<xsl:template name="left-trim">
  <xsl:param name="s" />
  <xsl:choose>
    <xsl:when test="substring($s, 1, 1) = ''">
      <xsl:value-of select="$s"/>
    </xsl:when>
    <xsl:when test="normalize-space(substring($s, 1, 1)) = ''">
      <xsl:call-template name="left-trim">
        <xsl:with-param name="s" select="substring($s, 2)" />
      </xsl:call-template>
    </xsl:when>
    <xsl:otherwise>
      <xsl:value-of select="$s" />
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template name="right-trim">
  <xsl:param name="s" />
  <xsl:choose>
    <xsl:when test="substring($s, 1, 1) = ''">
      <xsl:value-of select="$s"/>
    </xsl:when>
    <xsl:when test="normalize-space(substring($s, string-length($s))) = ''">
      <xsl:call-template name="right-trim">
        <xsl:with-param name="s" select="substring($s, 1, string-length($s) - 1)" />
      </xsl:call-template>
    </xsl:when>
    <xsl:otherwise>
      <xsl:value-of select="$s" />
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template name="trim">
  <xsl:param name="s" />
  <xsl:call-template name="right-trim">
    <xsl:with-param name="s">
      <xsl:call-template name="left-trim">
        <xsl:with-param name="s" select="$s" />
      </xsl:call-template>
    </xsl:with-param>
  </xsl:call-template>
</xsl:template>

<xsl:template name="fixedlen">
  <xsl:param name="s" />
  <xsl:param name="len" />
  <xsl:variable name="space100"><xsl:text>                                                                                                    </xsl:text></xsl:variable>
  <xsl:value-of select="$s"/><xsl:value-of select="substring($space100, 1, $len - string-length($s))"/>
</xsl:template>

<xsl:template name="cutBR">
  <xsl:param name="s"/>
  <xsl:choose>
    <xsl:when test="contains($s,'[') and contains($s,']')">
      <xsl:call-template name="cutBR">
          <xsl:with-param name="s" select="concat(substring-before($s,'['), substring-after($s,']'))"/>
      </xsl:call-template>
    </xsl:when>
    <xsl:otherwise>
      <xsl:value-of select="$s"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>


<!-- ================================== -->
<!--    cutSort(string)            -->
<!-- ================================== -->

<xsl:template name="cutSort">
    <xsl:param name="string"/>
    <xsl:param name="within" select="20"/>
    <xsl:choose>
       <xsl:when test="contains(substring($string,1,$within),'&#x9C;')">
	   <xsl:value-of select="normalize-space(substring-after($string,'&#x9C;'))"/>
       </xsl:when>
       <xsl:otherwise><xsl:value-of select="$string"/></xsl:otherwise>
    </xsl:choose>
</xsl:template>



</xsl:stylesheet>

