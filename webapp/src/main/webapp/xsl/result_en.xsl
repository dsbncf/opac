<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE solrresult [
<!ENTITY nbsp "&#xA0;">
<!ENTITY hr "<hr size='1' noshade='1'/>">
]>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<xsl:param name="requestURI"/>
<xsl:param name="param.showAll"/>
<xsl:param name="param.facetLimitMin"/>
<xsl:param name="param.facetLimitMax"/>
<xsl:param name="param.queryhash" select="0"/>
<xsl:param name="param.contextPath"/>
<xsl:param name="param.sort"/>

<xsl:include href="xsl/translate_en.xsl"/>
<xsl:include href="xsl/result.xsl"/>
<xsl:output method="html" encoding="UTF-8" version="1.0" indent="yes"/>


</xsl:stylesheet>    

