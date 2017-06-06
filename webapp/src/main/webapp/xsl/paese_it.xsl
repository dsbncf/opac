<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<!-- traduzione dei paesi -->

<xsl:template name="paese">
 <xsl:param name="sigla"/>
	<xsl:choose>
		<xsl:when test=".='za'">Africa del sud</xsl:when>
		<xsl:when test=".='al'">Albania</xsl:when>
		<xsl:when test=".='sa'">Arabia saudita</xsl:when>
		<xsl:when test=".='ar'">Argentina</xsl:when>
		<xsl:when test=".='at'">Austria</xsl:when>
		<xsl:when test=".='be'">Belgio</xsl:when>
		<xsl:when test=".='bo'">Bolivia</xsl:when>
		<xsl:when test=".='br'">Brasile</xsl:when>
		<xsl:when test=".='bg'">Bulgaria</xsl:when>
		<xsl:when test=".='ca'">Canada</xsl:when>
		<xsl:when test=".='cz'">Cecoslovacchia</xsl:when>
		<xsl:when test=".='cn'">Cina</xsl:when>
		<xsl:when test=".='co'">Colombia</xsl:when>
		<xsl:when test=".='cr'">Costa rica</xsl:when>
		<xsl:when test=".='cu'">Cuba</xsl:when>
		<xsl:when test=".='dk'">Danimarca</xsl:when>
		<xsl:when test=".='et'">Etiopia</xsl:when>
		<xsl:when test=".='fi'">Finlandia</xsl:when>
		<xsl:when test=".='fr'">Francia</xsl:when>
		<xsl:when test=".='de'">Germania</xsl:when>
		<xsl:when test=".='jp'">Giappone</xsl:when>
		<xsl:when test=".='gr'">Grecia</xsl:when>
		<xsl:when test=".='in'">India</xsl:when>
		<xsl:when test=".='ir'">Iran</xsl:when>
		<xsl:when test=".='ie'">Irlanda</xsl:when>
		<xsl:when test=".='il'">Israele</xsl:when>
		<xsl:when test=".='it'">Italia</xsl:when>
		<xsl:when test=".='yu'">Iugoslavia</xsl:when>
		<xsl:when test=".='li'">Liechtenstein</xsl:when>
		<xsl:when test=".='lu'">Lussemburgo</xsl:when>
		<xsl:when test=".='mg'">Madagascar</xsl:when>
		<xsl:when test=".='my'">Malesia</xsl:when>
		<xsl:when test=".='mt'">Malta</xsl:when>
		<xsl:when test=".='ma'">Marocco</xsl:when>
		<xsl:when test=".='mx'">Messico</xsl:when>
		<xsl:when test=".='mc'">Monaco</xsl:when>
		<xsl:when test=".='ne'">Niger</xsl:when>
		<xsl:when test=".='ng'">Nigeria</xsl:when>
		<xsl:when test=".='no'">Norvegia</xsl:when>
		<xsl:when test=".='pe'">Peru</xsl:when>
		<xsl:when test=".='pl'">Polonia</xsl:when>
		<xsl:when test=".='pt'">Portogallo</xsl:when>
		<xsl:when test=".='gb'">Regno Unito</xsl:when>
		<xsl:when test=".='ro'">Romania</xsl:when>
		<xsl:when test=".='sm'">San Marino</xsl:when>
		<xsl:when test=".='so'">Somalia</xsl:when>
		<xsl:when test=".='es'">Spagna</xsl:when>
		<xsl:when test=".='us'">Stati Uniti</xsl:when>
		<xsl:when test=".='se'">Svezia</xsl:when>
		<xsl:when test=".='ch'">Svizzera</xsl:when>
		<xsl:when test=".='tr'">Turchia</xsl:when>
		<xsl:when test=".='ua'">Ucrania</xsl:when>
		<xsl:when test=".='ru'">Federazione Russa</xsl:when>
		<xsl:when test=".='uy'">Uruguay</xsl:when>
		<xsl:when test=".='ve'">Venezuela</xsl:when>
		<xsl:when test=".='un'">Paese indeterminato</xsl:when>
		<xsl:otherwise><xsl:value-of select="$sigla"/></xsl:otherwise>
	</xsl:choose>
</xsl:template>

</xsl:stylesheet>
