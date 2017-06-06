<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<!-- ========================================== -->
<!--	substDelim98(string)			-->
<!-- ========================================== -->
<xsl:template name="substDelim98">
	<xsl:param name="string"/>
	<xsl:choose>
	<xsl:when test="contains($string, '&#x98;')">
		<xsl:value-of select="substring-before($string, '&#x98;')" />
		<xsl:value-of select="substring-after($string, '&#x98;')" />
	</xsl:when>
	<!-- supporta temporaneamente la codifica vecchia -->
	<xsl:when test="contains($string, '&#x88;')">
		<xsl:value-of select="substring-before($string, '&#x88;')" />
		<xsl:value-of select="substring-after($string, '&#x88;')" />
	</xsl:when>
	<xsl:otherwise>
	   <xsl:value-of select="$string" />
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
		<xsl:value-of select="substring-before($string, '&#x9C;')" />
		<xsl:value-of select="substring-after($string, '&#x9C;')" />
	</xsl:when>
	<!-- supporta temporaneamente la codifica vecchia -->
	<xsl:when test="contains($string, '&#x89;')">
		<xsl:value-of select="substring-before($string, '&#x89;')" />
		<xsl:value-of select="substring-after($string, '&#x89;')" />
	</xsl:when>

	<xsl:otherwise>
	   <xsl:value-of select="$string" />
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
				<xsl:with-param name="string" select="$string" />
			</xsl:call-template>
		</xsl:with-param>
		</xsl:call-template>
	</xsl:when>
	<!-- supporta temporaneamente la codifica vecchia -->
	<xsl:when test="contains($string, '&#x88;')">
		<xsl:call-template name="substDelim9C">
		<xsl:with-param name="string">
			<xsl:call-template name="substDelim98">
				<xsl:with-param name="string" select="$string" />
			</xsl:call-template>
		</xsl:with-param>
		</xsl:call-template>
	</xsl:when>
	<xsl:otherwise>
	   <xsl:value-of select="$string" />
	</xsl:otherwise>
	</xsl:choose>
</xsl:template>

<!-- ================================== -->
<!--	escapeURLspace(string)		-->
<!-- ================================== -->
<xsl:template name="escapeURLspace">
	<xsl:param name="string"/>
	<xsl:variable name="space"><xsl:text> </xsl:text></xsl:variable>
  <xsl:choose>
    <xsl:when test="contains($string, $space)">
	<xsl:value-of select="substring-before($string, $space)" />
	<xsl:text>%20</xsl:text>
	<xsl:call-template name="escapeURLspace">
	  <xsl:with-param name="string">
		<xsl:value-of select="substring-after($string, $space)" />
	  </xsl:with-param>
	</xsl:call-template>
    </xsl:when>
    <xsl:otherwise><xsl:value-of select="$string" /></xsl:otherwise>
  </xsl:choose>
</xsl:template>

<!-- ================================== -->
<!--	escapeApostropheJs(string)	-->
<!-- ================================== -->
<xsl:template name="escapeApostropheJs">
	<xsl:param name="string"/>
	<xsl:variable name="apostrophe"><xsl:text>'</xsl:text></xsl:variable>
  <xsl:choose>
    <xsl:when test="contains($string, $apostrophe)">
	<xsl:value-of select="substring-before($string, $apostrophe)" />
	<xsl:text>\'</xsl:text>
	<xsl:call-template name="escapeApostropheJs">
	  <xsl:with-param name="string">
		<xsl:value-of select="substring-after($string, $apostrophe)" />
	  </xsl:with-param>
	</xsl:call-template>
    </xsl:when>
    <xsl:otherwise><xsl:value-of select="$string" /></xsl:otherwise>
  </xsl:choose>
</xsl:template>

</xsl:stylesheet>    
