<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE umcslim2oi [
 <!ENTITY nl "<xsl:text>
</xsl:text>">
]>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" >
<xsl:output method="xml" encoding="utf-8" indent="yes" omit-xml-declaration="yes" />
<!--
 !  converte un documento XML con root '<rec>'
 !  conforme all'elemento "<rec>" dello schema unimarcslim
 !  della BNCF in formato "solr"  per la cancellazione della notizia in base all'IDN.
 -->
<xsl:template match="rec">
	<xsl:if test="substring(lab,6,1)='d'">
	<xsl:variable name="smallcase" select="'abcdefghijklmnopqrstuvwxyz'" />
	<xsl:variable name="uppercase" select="'ABCDEFGHIJKLMNOPQRSTUVWXYZ'" />
	<xsl:for-each select="cf[@t=001]">
	<id><xsl:value-of select="translate(text(), $uppercase, $smallcase)"/></id>
	</xsl:for-each>
	</xsl:if>
</xsl:template>

</xsl:stylesheet>

