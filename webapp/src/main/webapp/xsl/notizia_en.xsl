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

<xsl:include href="xsl/notizia.xsl"/>
<xsl:output method="html" encoding="UTF-8" version="1.0" indent="yes"/>


<!-- ==========================================================	-->
<!--	translate()																	-->
<!-- ==========================================================	-->

<xsl:template name="translate">
 <xsl:param name="section"/>
 <xsl:param name="sigla"/>
 <xsl:choose>
  <xsl:when test="$section='traduzioni'">
  <xsl:choose>
	  <xsl:when test="$sigla='ricerca_notizie_autore'">Search all news of this author</xsl:when>
	  <xsl:when test="$sigla='ricerca_notizie_collana'">Search all news in this series</xsl:when>
	  <xsl:when test="$sigla='ricerca_notizie_titolo'">Search all news of this title</xsl:when>
	  <xsl:when test="$sigla='ufficio_informazioni'">Information Office</xsl:when>
	  <xsl:when test="$sigla='richiesta_manuale'">manual request</xsl:when>
	  <xsl:when test="$sigla='annate_possedute'">Years&nbsp;Held&nbsp;</xsl:when>
	  <xsl:when test="$sigla='apri_box_dettaglio_annate'">Open the box with years details</xsl:when>
	  <xsl:when test="$sigla='dettaglio_annate'">Years details</xsl:when>
	  <xsl:when test="$sigla='cliccare_richiedere_annate'">Click to request years</xsl:when>
	  <xsl:when test="$sigla='cliccare_richiedere_documento'">Click to request document</xsl:when>
	  <xsl:when test="$sigla='cliccare_visualizzare_fascicoli'">Click to view the files</xsl:when>
	  <xsl:when test="$sigla='ricerca_notizie_dewey'">Search all news in this class Dewey</xsl:when>
	  <xsl:when test="$sigla='ricerca_notizie_soggetto'">Search all the news with this subject</xsl:when>
	  <xsl:when test="$sigla='tit'">Tit.</xsl:when>
	  <xsl:when test="$sigla='tit_parallelo'">Parallel tit.</xsl:when>
	  <xsl:when test="$sigla='titolo'">Title</xsl:when>
	  <xsl:when test="$sigla='titolo_originale'">Original title</xsl:when>
	  <xsl:when test="$sigla='e_forma_preferita_per'">is the preferred form for</xsl:when>
	  <xsl:when test="$sigla='forma_preferita_per'">preferred form for</xsl:when>
	  <xsl:when test="$sigla='forma_preferita_per_nuovo_soggettario'">preferred form with the New Soggettario (2007 -) for</xsl:when>
	  <xsl:when test="$sigla='altra_forma_per'">other form for</xsl:when>
	  <xsl:when test="$sigla='accesso_risorsa_digitalizzata_parzialmente'">Access to the partially digitized resource</xsl:when>
	  <xsl:when test="$sigla='digitalizzazione_parziale'">Partial Digitization</xsl:when>
	  <xsl:when test="$sigla='copia_digitale'">Digital copy</xsl:when>
	  <xsl:when test="$sigla='accesso_copia_depositata_bncf'">Access to the copy filed in BNCF</xsl:when>
	  <xsl:when test="$sigla='copia_depositata_bncf'">Copy filed in BNCF</xsl:when>
	  <xsl:when test="$sigla='inventario'">Inventory</xsl:when>
	  <xsl:when test="$sigla='supplemento_a'">Supplemento a</xsl:when>
	  <xsl:when test="$sigla='ha_per_supplemento'">Ha per supplemento</xsl:when>
	  <xsl:when test="$sigla='continuazione_parziale'">Continuazione parziale</xsl:when>
	  <xsl:when test="$sigla='continuato_parzialmente_da'">Continuato parzialmente da</xsl:when>
	  <xsl:when test="$sigla='assorbe'">Assorbe</xsl:when>
	  <xsl:when test="$sigla='assorbito_da'">Assorbito da</xsl:when>
	  <xsl:when test="$sigla='altra_edizione_di'">Altra edizione di</xsl:when>
	  <xsl:when test="$sigla='fa_parte_di'">Fa parte di</xsl:when>
	  <xsl:when test="$sigla='contiene'">Contiene</xsl:when>
	  <xsl:when test="$sigla='disponibilita_limitata'">Disponibilit&agrave; limitata</xsl:when>
	  <xsl:when test="$sigla='mancante'">Mancante</xsl:when>
	  <xsl:when test="$sigla='richiedi_il_documento'">Richiedi il documento</xsl:when>
	  <xsl:when test="$sigla='abb'">Abb</xsl:when>
	  <xsl:when test="$sigla='cod_materia'">Cod. materia</xsl:when>
	  <xsl:when test="$sigla='possessore'">possessore</xsl:when>
	  <xsl:when test="$sigla='provenienza'">provenienza</xsl:when>
	  <xsl:when test="$sigla='editore'">editore</xsl:when>
	  <xsl:when test="$sigla='accesso_copia_digitale'">Accesso alla copia digitale</xsl:when>
	  <xsl:otherwise><xsl:value-of select="$sigla"/></xsl:otherwise>
   </xsl:choose>
  </xsl:when>
  <xsl:otherwise></xsl:otherwise>
 </xsl:choose>
</xsl:template>


<!-- ==========================================================	-->
<!--	decodifMateriale()					-->
<!--	! decodifica tesi secondo vecchia convenzione !		-->
<!-- ==========================================================	-->
 <xsl:template name="decodifMateriale">
	<xsl:variable name="leader6" select="substring(/rec/lab,7,1)"/>
	<xsl:variable name="leader7" select="substring(/rec/lab,8,1)"/>
	<xsl:variable name="tesi"    select="substring(/rec/df[@t='105']/sf[@c='a'],5,1)"/>
 <tipo>
 <xsl:choose>
	<xsl:when test="$tesi='m'">Tesi di dottorato</xsl:when>
	<xsl:when test="/rec/df[@t=856] != ''">Editoria digitale</xsl:when>
	<xsl:when test="(/rec/df[@t=956 and (@i2=0 or @i2=1)] != '') or (/rec/df[@t=899] != '')">Digitalizzazioni</xsl:when>
	<xsl:otherwise>
	    <xsl:choose>
<!--
		<xsl:when test="$leader6='a' and $leader7='m'">Materiale a stampa</xsl:when>
-->
		<xsl:when test="$leader6='a'">Materiale a stampa</xsl:when>
		<xsl:when test="$leader6='b' and $leader7='m'">Tesi di dottorato</xsl:when>
		<xsl:when test="$leader6='c'">Spartiti musicali a stampa</xsl:when>
		<xsl:when test="$leader6='d'">Spartiti musicali manoscritti</xsl:when>
		<xsl:when test="$leader6='e'">Materiale cartografico</xsl:when>
		<xsl:when test="$leader6='f'">Materiale cartografico manoscritto</xsl:when>
		<xsl:when test="$leader6='g'">Materiale audio-visivo</xsl:when>
		<xsl:when test="$leader6='i'">Materiale sonoro</xsl:when>
		<xsl:when test="$leader6='j'">Registrazione musicale</xsl:when>
		<xsl:when test="$leader6='k'">Materiale grafico</xsl:when>
		<xsl:when test="$leader6='l'">Materiale elettronico</xsl:when>
		<xsl:when test="$leader6='m'">Materiale multimediale</xsl:when>
		<xsl:when test="$leader6='r'">Artefatti tridimensionale e realia</xsl:when>
		<xsl:when test="$leader7='c'">Documenti</xsl:when>
		<xsl:when test="$leader7='s'">Periodico</xsl:when>
		<xsl:when test="$leader7='z'">Manoscritto</xsl:when>
	    </xsl:choose>
	</xsl:otherwise>
 </xsl:choose>
 </tipo>
 </xsl:template>


<!-- ==================================	-->
<!--	natura				-->
<!-- ==================================	-->
 <xsl:template name="natura">
	<xsl:variable name="leader7" select="substring(/rec/lab,8,1)"/>
 <natura>
 <xsl:choose>
	<xsl:when test="$leader7='a'">Componente/Parte</xsl:when>
	<xsl:when test="$leader7='c'">Collezione</xsl:when>
	<xsl:when test="$leader7='m'">Monografia</xsl:when>
	<xsl:when test="$leader7='s'">Periodico</xsl:when>
	<xsl:when test="$leader7='z'">Manoscritto</xsl:when>
 </xsl:choose>
 </natura>
 </xsl:template>



<!-- ================================================================== -->
<!--    960$e : output dell'inventario (Dettaglio annate, periodico)	-->
<!-- ================================================================== -->

<xsl:template match="df[@t=960]/sf[@c='e']" mode="periodico">
	<xsl:variable name="disp" select="substring(.,45,2)"/> 
	<xsl:variable name="codbib" select="substring(.,1,2)"/> 
  <xsl:variable name="display" select="substring(.,54)"/>
 <xsl:choose>
  <xsl:when test="$codbib='CF'">
      <xsl:choose>
<!--
	<xsl:when test="$disp='  '"> <a><xsl:attribute
			name="href">http://servizi.bncf.firenze.sbn.it/richiestaPeriodico</xsl:attribute>
		<xsl:value-of select="."/></a>
-->
	<xsl:when test="$disp='  '"><xsl:value-of select="$display"/></xsl:when>
	<xsl:when test="$disp='A '"><xsl:value-of select="$display"/> (disponibilit&agrave; limitata)</xsl:when>
	<xsl:when test="$disp='B '"><xsl:value-of select="$display"/> (mancante)</xsl:when>
	<xsl:when test="$disp='C '"><xsl:value-of select="$display"/> (danneggiato)</xsl:when>
	<xsl:when test="$disp='D '"><xsl:value-of select="$display"/> (presso ufficio interno)</xsl:when>
	<xsl:when test="$disp='E '"><xsl:value-of select="$display"/> (escluso dalla circolazione)</xsl:when>
	<xsl:when test="$disp='F '"><xsl:value-of select="$display"/> (materiale delle sale)</xsl:when>
      </xsl:choose>
  </xsl:when>
  <xsl:otherwise><xsl:value-of select="$display"/></xsl:otherwise>
 </xsl:choose>
<br/>
</xsl:template>


<!-- ==========================	-->
<!--	102 : paese		-->
<!-- ========================== -->
<xsl:template match="df[@t=102]/sf[@c='a']">
 <paese>
  <xsl:text>Pubbl. in: </xsl:text>
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
	<xsl:when test=".='it'">Italy</xsl:when>
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
	<xsl:otherwise><xsl:value-of select="."/></xsl:otherwise>
  </xsl:choose>
 </paese>
 </xsl:template>


<!-- ==================================================	-->
<!--	101 : lingua					-->
<!-- ==================================================	-->
<!-- ! il sottocampo $b prima non veniva trattato !	-->
<!-- ==================================================	-->
<xsl:template match="df[@t=101]">
   <xsl:text>Lingua: </xsl:text>
   <xsl:variable name="lingue">
   <xsl:for-each select="sf[@c='a']|sf[@c='b']">
    <xsl:variable name="lang" select="text()"/>
    <xsl:choose>
    <xsl:when test="$lang='aar'">afar</xsl:when>
    <xsl:when test="$lang='abk'">abcaso</xsl:when>
    <xsl:when test="$lang='abs'">assente</xsl:when>
    <xsl:when test="$lang='ace'">accinese</xsl:when>
    <xsl:when test="$lang='ach'">acioli</xsl:when>
    <xsl:when test="$lang='ada'">adangme</xsl:when>
    <xsl:when test="$lang='ady'">adyghe</xsl:when>
    <xsl:when test="$lang='afa'">afro-asiatica (altra lingua)</xsl:when>
    <xsl:when test="$lang='afh'">afrihili</xsl:when>
    <xsl:when test="$lang='afr'">afrikaans</xsl:when>
    <xsl:when test="$lang='ain'">ainu</xsl:when>
    <xsl:when test="$lang='ajm'">aljamia</xsl:when>
    <xsl:when test="$lang='aka'">akan</xsl:when>
    <xsl:when test="$lang='akk'">accado</xsl:when>
    <xsl:when test="$lang='alb'">albanese</xsl:when>
    <xsl:when test="$lang='ale'">aleuto</xsl:when>
    <xsl:when test="$lang='alg'">lingue algonchine</xsl:when>
    <xsl:when test="$lang='alt'">altai del sud</xsl:when>
    <xsl:when test="$lang='amh'">amarico</xsl:when>
    <xsl:when test="$lang='ang'">anglosassone (600-1100 ca.)</xsl:when>
    <xsl:when test="$lang='anp'">angika</xsl:when>
    <xsl:when test="$lang='apa'">apache</xsl:when>
    <xsl:when test="$lang='ara'">arabo</xsl:when>
    <xsl:when test="$lang='arc'">aramaico</xsl:when>
    <xsl:when test="$lang='arg'">aragonese</xsl:when>
    <xsl:when test="$lang='arm'">armeno</xsl:when>
    <xsl:when test="$lang='arn'">araucano</xsl:when>
    <xsl:when test="$lang='arp'">arapaho</xsl:when>
    <xsl:when test="$lang='art'">artificiale (altra lingua)</xsl:when>
    <xsl:when test="$lang='arw'">aruaco</xsl:when>
    <xsl:when test="$lang='asm'">assamese</xsl:when>
    <xsl:when test="$lang='ast'">asturiano</xsl:when>
    <xsl:when test="$lang='ath'">lingue athabaska</xsl:when>
    <xsl:when test="$lang='aus'">lingue australiane</xsl:when>
    <xsl:when test="$lang='ava'">avaro</xsl:when>
    <xsl:when test="$lang='ave'">avestico</xsl:when>
    <xsl:when test="$lang='awa'">awadhi</xsl:when>
    <xsl:when test="$lang='aym'">aymara</xsl:when>
    <xsl:when test="$lang='aze'">azerbaigiano</xsl:when>
    <xsl:when test="$lang='bad'">banda</xsl:when>
    <xsl:when test="$lang='bai'">lingue bamileke</xsl:when>
    <xsl:when test="$lang='bak'">baschiro</xsl:when>
    <xsl:when test="$lang='bal'">beluci</xsl:when>
    <xsl:when test="$lang='bam'">bambara</xsl:when>
    <xsl:when test="$lang='ban'">balinese</xsl:when>
    <xsl:when test="$lang='baq'">basco</xsl:when>
    <xsl:when test="$lang='bas'">basa</xsl:when>
    <xsl:when test="$lang='bat'">baltica (altra lingua)</xsl:when>
    <xsl:when test="$lang='bej'">begia</xsl:when>
    <xsl:when test="$lang='bel'">bielorusso</xsl:when>
    <xsl:when test="$lang='bem'">wemba</xsl:when>
    <xsl:when test="$lang='ben'">bengali</xsl:when>
    <xsl:when test="$lang='ber'">lingue berbere</xsl:when>
    <xsl:when test="$lang='bho'">bhojpuri</xsl:when>
    <xsl:when test="$lang='bih'">bihari</xsl:when>
    <xsl:when test="$lang='bik'">bicol</xsl:when>
    <xsl:when test="$lang='bin'">bini</xsl:when>
    <xsl:when test="$lang='bis'">bislama</xsl:when>
    <xsl:when test="$lang='bla'">siksika</xsl:when>
    <xsl:when test="$lang='bnt'">bantu (altra lingua)</xsl:when>
    <xsl:when test="$lang='bos'">bosniaco</xsl:when>
    <xsl:when test="$lang='bra'">braj</xsl:when>
    <xsl:when test="$lang='bre'">bretone</xsl:when>
    <xsl:when test="$lang='btk'">batak (indonesia)</xsl:when>
    <xsl:when test="$lang='bua'">buriato</xsl:when>
    <xsl:when test="$lang='bug'">bugi</xsl:when>
    <xsl:when test="$lang='bul'">bulgaro</xsl:when>
    <xsl:when test="$lang='bur'">birmano</xsl:when>
    <xsl:when test="$lang='byn'">blin</xsl:when>
    <xsl:when test="$lang='cad'">caddo</xsl:when>
    <xsl:when test="$lang='cai'">indiana dell'america centrale (a.l.)</xsl:when>
    <xsl:when test="$lang='cam'">cambogiano</xsl:when>
    <xsl:when test="$lang='car'">caribico</xsl:when>
    <xsl:when test="$lang='cat'">catalano</xsl:when>
    <xsl:when test="$lang='cau'">caucasica (altra lingua)</xsl:when>
    <xsl:when test="$lang='ceb'">cebuano</xsl:when>
    <xsl:when test="$lang='cel'">celtico (altra lingua)</xsl:when>
    <xsl:when test="$lang='cha'">chamorro</xsl:when>
    <xsl:when test="$lang='chb'">chibcha</xsl:when>
    <xsl:when test="$lang='che'">ceceno</xsl:when>
    <xsl:when test="$lang='chg'">ciagataico</xsl:when>
    <xsl:when test="$lang='chi'">cinese</xsl:when>
    <xsl:when test="$lang='chk'">chuukese</xsl:when>
    <xsl:when test="$lang='chm'">mari</xsl:when>
    <xsl:when test="$lang='chn'">chinook</xsl:when>
    <xsl:when test="$lang='cho'">choctaw</xsl:when>
    <xsl:when test="$lang='chp'">chipewyan</xsl:when>
    <xsl:when test="$lang='chr'">cherokee</xsl:when>
    <xsl:when test="$lang='chu'">slavo ecclesiastico</xsl:when>
    <xsl:when test="$lang='chv'">ciuvasce</xsl:when>
    <xsl:when test="$lang='chy'">cheyenne</xsl:when>
    <xsl:when test="$lang='cmc'">ciami (lingue)</xsl:when>
    <xsl:when test="$lang='cop'">copto</xsl:when>
    <xsl:when test="$lang='cor'">cornico</xsl:when>
    <xsl:when test="$lang='cos'">corso</xsl:when>
    <xsl:when test="$lang='cpe'">creolo-inglese (altra lingua)</xsl:when>
    <xsl:when test="$lang='cpf'">creolo-francese (altra lingua)</xsl:when>
    <xsl:when test="$lang='cpp'">creolo-portoghese (altra lingua)</xsl:when>
    <xsl:when test="$lang='cre'">cree</xsl:when>
    <xsl:when test="$lang='crh'">tataro di crimea</xsl:when>
    <xsl:when test="$lang='crp'">creola (altra lingua)</xsl:when>
    <xsl:when test="$lang='csb'">kashubian</xsl:when>
    <xsl:when test="$lang='cus'">cuscitica (altra lingua)</xsl:when>
    <xsl:when test="$lang='cze'">ceco</xsl:when>
    <xsl:when test="$lang='dak'">dakota</xsl:when>
    <xsl:when test="$lang='dan'">danese</xsl:when>
    <xsl:when test="$lang='dar'">dargwa</xsl:when>
    <xsl:when test="$lang='day'">daiaco</xsl:when>
    <xsl:when test="$lang='del'">delaware</xsl:when>
    <xsl:when test="$lang='den'">schiavo</xsl:when>
    <xsl:when test="$lang='dgr'">dogrib</xsl:when>
    <xsl:when test="$lang='din'">dinca</xsl:when>
    <xsl:when test="$lang='div'">divedi</xsl:when>
    <xsl:when test="$lang='deu'">tedesco</xsl:when>
    <xsl:when test="$lang='doi'">dogri</xsl:when>
    <xsl:when test="$lang='dra'">dravidica (altra lingua)</xsl:when>
    <xsl:when test="$lang='dsb'">lower sorbian</xsl:when>
    <xsl:when test="$lang='dua'">duala</xsl:when>
    <xsl:when test="$lang='dum'">olandese medio (1050-1350 ca.)</xsl:when>
    <xsl:when test="$lang='dut'">olandese</xsl:when>
    <xsl:when test="$lang='dyu'">diula</xsl:when>
    <xsl:when test="$lang='dzo'">dzongkha</xsl:when>
    <xsl:when test="$lang='efi'">efik</xsl:when>
    <xsl:when test="$lang='egy'">egiziano</xsl:when>
    <xsl:when test="$lang='eka'">ekajuk</xsl:when>
    <xsl:when test="$lang='elx'">elamitico</xsl:when>
    <xsl:when test="$lang='eng'">english</xsl:when>
    <xsl:when test="$lang='enm'">inglese medio (1100-1500 ca.)</xsl:when>
    <xsl:when test="$lang='epo'">esperanto</xsl:when>
    <xsl:when test="$lang='esk'">eschimese</xsl:when>
    <xsl:when test="$lang='esp'">esperanto</xsl:when>
    <xsl:when test="$lang='est'">estone</xsl:when>
    <xsl:when test="$lang='eth'">etiopico</xsl:when>
    <xsl:when test="$lang='ewe'">ewe</xsl:when>
    <xsl:when test="$lang='ewo'">ewondo</xsl:when>
    <xsl:when test="$lang='fan'">fan</xsl:when>
    <xsl:when test="$lang='fao'">faroese</xsl:when>
    <xsl:when test="$lang='far'">faeroico</xsl:when>
    <xsl:when test="$lang='fat'">fanti</xsl:when>
    <xsl:when test="$lang='fij'">figi</xsl:when>
    <xsl:when test="$lang='fil'">filippino</xsl:when>
    <xsl:when test="$lang='fin'">finlandese</xsl:when>
    <xsl:when test="$lang='fiu'">ugrofinnica</xsl:when>
    <xsl:when test="$lang='fon'">fon</xsl:when>
    <xsl:when test="$lang='fra'">french</xsl:when>
    <xsl:when test="$lang='fre'">french</xsl:when>
    <xsl:when test="$lang='fri'">frisone</xsl:when>
    <xsl:when test="$lang='frm'">francese medio (1400-1600 ca.)</xsl:when>
    <xsl:when test="$lang='fro'">francese antico (842-1400 ca.)</xsl:when>
    <xsl:when test="$lang='frr'">frisone settentrionale</xsl:when>
    <xsl:when test="$lang='frs'">frisone orientale</xsl:when>
    <xsl:when test="$lang='fry'">frisone occidentale</xsl:when>
    <xsl:when test="$lang='ful'">ful</xsl:when>
    <xsl:when test="$lang='fur'">friulano</xsl:when>
    <xsl:when test="$lang='gaa'">ga</xsl:when>
    <xsl:when test="$lang='gae'">gaelico (scozzese)</xsl:when>
    <xsl:when test="$lang='gag'">gallegan</xsl:when>
    <xsl:when test="$lang='gal'">galla</xsl:when>
    <xsl:when test="$lang='gay'">gayo</xsl:when>
    <xsl:when test="$lang='gba'">gbaya</xsl:when>
    <xsl:when test="$lang='gem'">germanica (altra lingua)</xsl:when>
    <xsl:when test="$lang='geo'">georgiano</xsl:when>
    <xsl:when test="$lang='ger'">german</xsl:when>
    <xsl:when test="$lang='gez'">ge'ez prima etiopico</xsl:when>
    <xsl:when test="$lang='gil'">gilbertese</xsl:when>
    <xsl:when test="$lang='gla'">gaelico (scozzese)</xsl:when>
    <xsl:when test="$lang='gle'">irlandese</xsl:when>
    <xsl:when test="$lang='glg'">gallegan</xsl:when>
    <xsl:when test="$lang='glv'">mannese</xsl:when>
    <xsl:when test="$lang='gmh'">tedesco medio alto (1050-1500 ca.)</xsl:when>
    <xsl:when test="$lang='goh'">tedesco alto antico (750-1050 ca.)</xsl:when>
    <xsl:when test="$lang='gon'">gondi</xsl:when>
    <xsl:when test="$lang='gor'">gorontalo</xsl:when>
    <xsl:when test="$lang='got'">gotico</xsl:when>
    <xsl:when test="$lang='grb'">grebo</xsl:when>
    <xsl:when test="$lang='grc'">greco antico (fino al 1453)</xsl:when>
    <xsl:when test="$lang='gre'">greco moderno</xsl:when>
    <xsl:when test="$lang='grn'">guarani</xsl:when>
    <xsl:when test="$lang='gsw'">tedesco svizzero</xsl:when>
    <xsl:when test="$lang='gua'">guarani</xsl:when>
    <xsl:when test="$lang='guj'">gujarati</xsl:when>
    <xsl:when test="$lang='gwi'">gwich'in</xsl:when>
    <xsl:when test="$lang='hai'">haida</xsl:when>
    <xsl:when test="$lang='hat'">haitian</xsl:when>
    <xsl:when test="$lang='hau'">haussa</xsl:when>
    <xsl:when test="$lang='haw'">hawaiano</xsl:when>
    <xsl:when test="$lang='heb'">ebraico</xsl:when>
    <xsl:when test="$lang='her'">herero</xsl:when>
    <xsl:when test="$lang='hil'">hiligayna</xsl:when>
    <xsl:when test="$lang='him'">himachali</xsl:when>
    <xsl:when test="$lang='hin'">hindi</xsl:when>
    <xsl:when test="$lang='hit'">ittito</xsl:when>
    <xsl:when test="$lang='hmn'">hmong</xsl:when>
    <xsl:when test="$lang='hmo'">hiri motu</xsl:when>
    <xsl:when test="$lang='hrv'">croato</xsl:when>
    <xsl:when test="$lang='hsb'">upper sorbian</xsl:when>
    <xsl:when test="$lang='hun'">ungherese</xsl:when>
    <xsl:when test="$lang='hup'">hupa</xsl:when>
    <xsl:when test="$lang='iba'">iban</xsl:when>
    <xsl:when test="$lang='ibo'">ibo</xsl:when>
    <xsl:when test="$lang='ice'">islandese</xsl:when>
    <xsl:when test="$lang='ido'">ido</xsl:when>
    <xsl:when test="$lang='iii'">sichuan yi</xsl:when>
    <xsl:when test="$lang='ijo'">ijo</xsl:when>
    <xsl:when test="$lang='iku'">inuktitut</xsl:when>
    <xsl:when test="$lang='ile'">interlingue</xsl:when>
    <xsl:when test="$lang='ilo'">ilocano</xsl:when>
    <xsl:when test="$lang='ina'">interlingua (lingua della international auxiliary fassociation)</xsl:when>
    <xsl:when test="$lang='inc'">indiana (altra lingua)</xsl:when>
    <xsl:when test="$lang='ind'">indonesiano</xsl:when>
    <xsl:when test="$lang='ine'">indoeuropea (altra lingua)</xsl:when>
    <xsl:when test="$lang='ing'">inglese</xsl:when>
    <xsl:when test="$lang='inh'">ingush</xsl:when>
    <xsl:when test="$lang='int'">interlingua</xsl:when>
    <xsl:when test="$lang='ipk'">inupiaq</xsl:when>
    <xsl:when test="$lang='ira'">iraniana (altra lingua)</xsl:when>
    <xsl:when test="$lang='iri'">irlandese</xsl:when>
    <xsl:when test="$lang='iro'">lingue irochesi</xsl:when>
    <xsl:when test="$lang='ita'">italian</xsl:when>
    <xsl:when test="$lang='jav'">giavanese</xsl:when>
    <xsl:when test="$lang='jbo'">lojban</xsl:when>
    <xsl:when test="$lang='jpn'">giapponese</xsl:when>
    <xsl:when test="$lang='jpr'">giudeo-persiano</xsl:when>
    <xsl:when test="$lang='jrb'">giudeo-arabo</xsl:when>
    <xsl:when test="$lang='kaa'">karakalpak</xsl:when>
    <xsl:when test="$lang='kab'">cabilo</xsl:when>
    <xsl:when test="$lang='kac'">kachin</xsl:when>
    <xsl:when test="$lang='kal'">groenlandese</xsl:when>
    <xsl:when test="$lang='kam'">kamba</xsl:when>
    <xsl:when test="$lang='kan'">canarese</xsl:when>
    <xsl:when test="$lang='kar'">karen</xsl:when>
    <xsl:when test="$lang='kas'">kasmiri</xsl:when>
    <xsl:when test="$lang='kau'">kanuri</xsl:when>
    <xsl:when test="$lang='kaw'">kawi</xsl:when>
    <xsl:when test="$lang='kaz'">cosacco</xsl:when>
    <xsl:when test="$lang='kbd'">kabardian</xsl:when>
    <xsl:when test="$lang='kha'">khasi</xsl:when>
    <xsl:when test="$lang='khi'">khoisan (altra lingua)</xsl:when>
    <xsl:when test="$lang='khm'">khmer</xsl:when>
    <xsl:when test="$lang='kho'">khotanese</xsl:when>
    <xsl:when test="$lang='kik'">kikuyu</xsl:when>
    <xsl:when test="$lang='kin'">ruanda</xsl:when>
    <xsl:when test="$lang='kir'">chirghiso</xsl:when>
    <xsl:when test="$lang='kmb'">kimbundu</xsl:when>
    <xsl:when test="$lang='kok'">konkani</xsl:when>
    <xsl:when test="$lang='kom'">komi</xsl:when>
    <xsl:when test="$lang='kon'">congolese</xsl:when>
    <xsl:when test="$lang='kor'">coreano</xsl:when>
    <xsl:when test="$lang='kos'">cosreano (cosreo)</xsl:when>
    <xsl:when test="$lang='kpe'">kpelle</xsl:when>
    <xsl:when test="$lang='krc'">karachay-balkar</xsl:when>
    <xsl:when test="$lang='krl'">karelian</xsl:when>
    <xsl:when test="$lang='kro'">kru</xsl:when>
    <xsl:when test="$lang='kru'">kurukh</xsl:when>
    <xsl:when test="$lang='kua'">kuanyama</xsl:when>
    <xsl:when test="$lang='kum'">kumyk</xsl:when>
    <xsl:when test="$lang='kur'">curdo</xsl:when>
    <xsl:when test="$lang='kus'">kusaie</xsl:when>
    <xsl:when test="$lang='kut'">kutenai</xsl:when>
    <xsl:when test="$lang='lad'">giudeo-spagnolo</xsl:when>
    <xsl:when test="$lang='lah'">lahnda</xsl:when>
    <xsl:when test="$lang='lam'">lamba</xsl:when>
    <xsl:when test="$lang='lan'">lingua d'oc (dopo il 1500)</xsl:when>
    <xsl:when test="$lang='lao'">laotiano</xsl:when>
    <xsl:when test="$lang='lap'">lappone</xsl:when>
    <xsl:when test="$lang='lat'">latin</xsl:when>
    <xsl:when test="$lang='lav'">lettone</xsl:when>
    <xsl:when test="$lang='lez'">lesgo</xsl:when>
    <xsl:when test="$lang='lim'">limburgan</xsl:when>
    <xsl:when test="$lang='lin'">lingala</xsl:when>
    <xsl:when test="$lang='lit'">lituano</xsl:when>
    <xsl:when test="$lang='lol'">lolo (bantu)</xsl:when>
    <xsl:when test="$lang='loz'">lozi</xsl:when>
    <xsl:when test="$lang='ltz'">lussemburghese</xsl:when>
    <xsl:when test="$lang='lua'">luba-lulua</xsl:when>
    <xsl:when test="$lang='lub'">luba-kalanga</xsl:when>
    <xsl:when test="$lang='lug'">luganda</xsl:when>
    <xsl:when test="$lang='lui'">luiseno</xsl:when>
    <xsl:when test="$lang='lun'">lunda</xsl:when>
    <xsl:when test="$lang='luo'">luo (kenia e tanzania)</xsl:when>
    <xsl:when test="$lang='lus'">lushei</xsl:when>
    <xsl:when test="$lang='mac'">macedone</xsl:when>
    <xsl:when test="$lang='mad'">madurese</xsl:when>
    <xsl:when test="$lang='mag'">magahi</xsl:when>
    <xsl:when test="$lang='mah'">marshall</xsl:when>
    <xsl:when test="$lang='mai'">maithili</xsl:when>
    <xsl:when test="$lang='mak'">macassar</xsl:when>
    <xsl:when test="$lang='mal'">malayalam</xsl:when>
    <xsl:when test="$lang='man'">mandingo</xsl:when>
    <xsl:when test="$lang='mao'">maori</xsl:when>
    <xsl:when test="$lang='map'">austronesiana (altra lingua)</xsl:when>
    <xsl:when test="$lang='mar'">maratto</xsl:when>
    <xsl:when test="$lang='mas'">masai</xsl:when>
    <xsl:when test="$lang='max'">mannese</xsl:when>
    <xsl:when test="$lang='may'">malese</xsl:when>
    <xsl:when test="$lang='mdf'">moksha</xsl:when>
    <xsl:when test="$lang='mdr'">mandar</xsl:when>
    <xsl:when test="$lang='men'">mende</xsl:when>
    <xsl:when test="$lang='mga'">irlandese medio (9oo-1200)</xsl:when>
    <xsl:when test="$lang='mic'">micmac</xsl:when>
    <xsl:when test="$lang='min'">menangkabau</xsl:when>
    <xsl:when test="$lang='mis'">lingue diverse</xsl:when>
    <xsl:when test="$lang='mkh'">mon-khmer (altra lingua)</xsl:when>
    <xsl:when test="$lang='mla'">malgascio</xsl:when>
    <xsl:when test="$lang='mlg'">malgascio</xsl:when>
    <xsl:when test="$lang='mlt'">maltese</xsl:when>
    <xsl:when test="$lang='mnc'">manchu</xsl:when>
    <xsl:when test="$lang='mni'">manipuri</xsl:when>
    <xsl:when test="$lang='mno'">manobo</xsl:when>
    <xsl:when test="$lang='moh'">mohawk</xsl:when>
    <xsl:when test="$lang='mol'">moldavo</xsl:when>
    <xsl:when test="$lang='mon'">mongolo</xsl:when>
    <xsl:when test="$lang='mos'">mossi</xsl:when>
    <xsl:when test="$lang='mul'">multilanguage</xsl:when>
    <xsl:when test="$lang='mun'">munda (altra lingua)</xsl:when>
    <xsl:when test="$lang='mus'">muskogee</xsl:when>
    <xsl:when test="$lang='mwl'">mirandese</xsl:when>
    <xsl:when test="$lang='mwr'">marwari</xsl:when>
    <xsl:when test="$lang='myn'">lingue maya</xsl:when>
    <xsl:when test="$lang='myv'">erzya</xsl:when>
    <xsl:when test="$lang='nah'">nahuatl</xsl:when>
    <xsl:when test="$lang='nai'">indiana dell'america del nord (a.l.)</xsl:when>
    <xsl:when test="$lang='nap'">napoletano</xsl:when>
    <xsl:when test="$lang='nau'">nauruano</xsl:when>
    <xsl:when test="$lang='nav'">navaho</xsl:when>
    <xsl:when test="$lang='nbl'">ndebele del sud</xsl:when>
    <xsl:when test="$lang='nde'">ndebele del nord</xsl:when>
    <xsl:when test="$lang='ndo'">ndonga</xsl:when>
    <xsl:when test="$lang='nds'">basso tedesco</xsl:when>
    <xsl:when test="$lang='nep'">nepalese</xsl:when>
    <xsl:when test="$lang='new'">newari</xsl:when>
    <xsl:when test="$lang='nia'">niassese</xsl:when>
    <xsl:when test="$lang='nic'">nigero-cordofaniana (altra lingua)</xsl:when>
    <xsl:when test="$lang='niu'">niue</xsl:when>
    <xsl:when test="$lang='nno'">norwegian nynorsk</xsl:when>
    <xsl:when test="$lang='nob'">norwegian bokmal</xsl:when>
    <xsl:when test="$lang='nog'">nogai</xsl:when>
    <xsl:when test="$lang='non'">nordico antico</xsl:when>
    <xsl:when test="$lang='nor'">norvegese</xsl:when>
    <xsl:when test="$lang='npi'">npi ?</xsl:when>
    <xsl:when test="$lang='nqo'">n'ko</xsl:when>
    <xsl:when test="$lang='nso'">sotho del nord</xsl:when>
    <xsl:when test="$lang='nub'">nubiano</xsl:when>
    <xsl:when test="$lang='nwc'">newari classico</xsl:when>
    <xsl:when test="$lang='nya'">nyanja</xsl:when>
    <xsl:when test="$lang='nym'">nyamwesi</xsl:when>
    <xsl:when test="$lang='nyn'">nyankole</xsl:when>
    <xsl:when test="$lang='nyo'">nyoro</xsl:when>
    <xsl:when test="$lang='nzi'">nzima</xsl:when>
    <xsl:when test="$lang='oci'">occitanico (dopo il 1500)</xsl:when>
    <xsl:when test="$lang='oji'">ojibwa</xsl:when>
    <xsl:when test="$lang='ori'">oriya</xsl:when>
    <xsl:when test="$lang='orm'">oromo</xsl:when>
    <xsl:when test="$lang='osa'">osage</xsl:when>
    <xsl:when test="$lang='oss'">ossetico</xsl:when>
    <xsl:when test="$lang='ota'">turco ottomano (1500-1928)</xsl:when>
    <xsl:when test="$lang='oto'">lingue otomi</xsl:when>
    <xsl:when test="$lang='paa'">papuano-australiana (altra lingua)</xsl:when>
    <xsl:when test="$lang='pag'">pangasinan</xsl:when>
    <xsl:when test="$lang='pal'">pahlavi</xsl:when>
    <xsl:when test="$lang='pam'">pampanga</xsl:when>
    <xsl:when test="$lang='pan'">panjabi</xsl:when>
    <xsl:when test="$lang='pap'">papiamento</xsl:when>
    <xsl:when test="$lang='pau'">palau</xsl:when>
    <xsl:when test="$lang='peo'">persiano antico (600-400 a.c. ca.)</xsl:when>
    <xsl:when test="$lang='per'">persiano moderno</xsl:when>
    <xsl:when test="$lang='phi'">filippina (altra lingua)</xsl:when>
    <xsl:when test="$lang='phn'">fenicio</xsl:when>
    <xsl:when test="$lang='pli'">pali</xsl:when>
    <xsl:when test="$lang='pol'">polacco</xsl:when>
    <xsl:when test="$lang='pon'">ponape</xsl:when>
    <xsl:when test="$lang='por'">portoguese</xsl:when>
    <xsl:when test="$lang='pra'">pracrito</xsl:when>
    <xsl:when test="$lang='pro'">provenzale (fino al 1500)</xsl:when>
    <xsl:when test="$lang='pus'">pashto</xsl:when>
    <xsl:when test="$lang='que'">quechua</xsl:when>
    <xsl:when test="$lang='raj'">rajasthani</xsl:when>
    <xsl:when test="$lang='rap'">rapanui</xsl:when>
    <xsl:when test="$lang='rar'">rarotonga</xsl:when>
    <xsl:when test="$lang='roa'">romanza (altra lingua)</xsl:when>
    <xsl:when test="$lang='roh'">retoromanzo</xsl:when>
    <xsl:when test="$lang='rom'">zingaresco</xsl:when>
    <xsl:when test="$lang='rum'">rumeno</xsl:when>
    <xsl:when test="$lang='run'">rundi</xsl:when>
    <xsl:when test="$lang='rup'">aromanian</xsl:when>
    <xsl:when test="$lang='rus'">russian</xsl:when>
    <xsl:when test="$lang='sa'">codice up/down notizie</xsl:when>
    <xsl:when test="$lang='sad'">sandawe</xsl:when>
    <xsl:when test="$lang='sag'">sango</xsl:when>
    <xsl:when test="$lang='sah'">yakut</xsl:when>
    <xsl:when test="$lang='sai'">indiana del sud america (a.l.)</xsl:when>
    <xsl:when test="$lang='sal'">lingue salish</xsl:when>
    <xsl:when test="$lang='sam'">samaritano</xsl:when>
    <xsl:when test="$lang='san'">sanscrito</xsl:when>
    <xsl:when test="$lang='sao'">samoano</xsl:when>
    <xsl:when test="$lang='sas'">sasak</xsl:when>
    <xsl:when test="$lang='sat'">santali</xsl:when>
    <xsl:when test="$lang='scc'">serbo-croato (cirillico)</xsl:when>
    <xsl:when test="$lang='scn'">siciliano</xsl:when>
    <xsl:when test="$lang='sco'">scozzese</xsl:when>
    <xsl:when test="$lang='scr'">serbo-croato (latino)</xsl:when>
    <xsl:when test="$lang='sel'">selkupico</xsl:when>
    <xsl:when test="$lang='sem'">semitica (altra lingua)</xsl:when>
    <xsl:when test="$lang='sga'">irlandese antico (fino al 900)</xsl:when>
    <xsl:when test="$lang='sgn'">lingua dei segni</xsl:when>
    <xsl:when test="$lang='shn'">shan</xsl:when>
    <xsl:when test="$lang='sho'">shona</xsl:when>
    <xsl:when test="$lang='sid'">sidama</xsl:when>
    <xsl:when test="$lang='sin'">singalese</xsl:when>
    <xsl:when test="$lang='sio'">lingue sioux</xsl:when>
    <xsl:when test="$lang='sit'">sino-tibetana (altra lingua)</xsl:when>
    <xsl:when test="$lang='sla'">slava (altra lingua)</xsl:when>
    <xsl:when test="$lang='slo'">slovacco</xsl:when>
    <xsl:when test="$lang='slv'">sloveno</xsl:when>
    <xsl:when test="$lang='sma'">sami del sud</xsl:when>
    <xsl:when test="$lang='sme'">sami del nord</xsl:when>
    <xsl:when test="$lang='smi'">lingue sami</xsl:when>
    <xsl:when test="$lang='smj'">lule sami</xsl:when>
    <xsl:when test="$lang='smn'">inari sami</xsl:when>
    <xsl:when test="$lang='smo'">samoano</xsl:when>
    <xsl:when test="$lang='sms'">skolt sami</xsl:when>
    <xsl:when test="$lang='sna'">shona</xsl:when>
    <xsl:when test="$lang='snd'">sindhi</xsl:when>
    <xsl:when test="$lang='snh'">singalese</xsl:when>
    <xsl:when test="$lang='snk'">soninke</xsl:when>
    <xsl:when test="$lang='sog'">sogdiano</xsl:when>
    <xsl:when test="$lang='som'">somalo</xsl:when>
    <xsl:when test="$lang='son'">songhai</xsl:when>
    <xsl:when test="$lang='sot'">sotho del sud</xsl:when>
    <xsl:when test="$lang='spa'">spanish</xsl:when>
    <xsl:when test="$lang='srd'">sardo</xsl:when>
    <xsl:when test="$lang='srn'">sranan tongo</xsl:when>
    <xsl:when test="$lang='srp'">serbo</xsl:when>
    <xsl:when test="$lang='srr'">serer</xsl:when>
    <xsl:when test="$lang='ssa'">nilo-sahariana (altra lingua)</xsl:when>
    <xsl:when test="$lang='sso'">sotho del sud</xsl:when>
    <xsl:when test="$lang='ssw'">swati</xsl:when>
    <xsl:when test="$lang='suk'">sukuma</xsl:when>
    <xsl:when test="$lang='sun'">sundanese</xsl:when>
    <xsl:when test="$lang='sus'">susu</xsl:when>
    <xsl:when test="$lang='sux'">sumero</xsl:when>
    <xsl:when test="$lang='swa'">suaheli</xsl:when>
    <xsl:when test="$lang='swe'">svedese</xsl:when>
    <xsl:when test="$lang='swz'">swazi</xsl:when>
    <xsl:when test="$lang='syc'">siriaco classico</xsl:when>
    <xsl:when test="$lang='syr'">siriaco</xsl:when>
    <xsl:when test="$lang='tag'">tagalog</xsl:when>
    <xsl:when test="$lang='tah'">tahitiano</xsl:when>
    <xsl:when test="$lang='tai'">tai (altra lingua)</xsl:when>
    <xsl:when test="$lang='taj'">tagicco</xsl:when>
    <xsl:when test="$lang='tam'">tamil</xsl:when>
    <xsl:when test="$lang='tar'">tataro</xsl:when>
    <xsl:when test="$lang='tat'">tataro</xsl:when>
    <xsl:when test="$lang='tel'">telugu</xsl:when>
    <xsl:when test="$lang='tem'">temne</xsl:when>
    <xsl:when test="$lang='ter'">tereno</xsl:when>
    <xsl:when test="$lang='tet'">tetum</xsl:when>
    <xsl:when test="$lang='tgk'">tagico</xsl:when>
    <xsl:when test="$lang='tgl'">tagalog</xsl:when>
    <xsl:when test="$lang='tha'">thai</xsl:when>
    <xsl:when test="$lang='tib'">tibetano</xsl:when>
    <xsl:when test="$lang='tig'">tigre</xsl:when>
    <xsl:when test="$lang='tir'">tigrino</xsl:when>
    <xsl:when test="$lang='tiv'">tiv</xsl:when>
    <xsl:when test="$lang='tkl'">tokelau</xsl:when>
    <xsl:when test="$lang='tlh'">klingon</xsl:when>
    <xsl:when test="$lang='tli'">tlingit</xsl:when>
    <xsl:when test="$lang='tmh'">tamashek</xsl:when>
    <xsl:when test="$lang='tog'">tonga (nyasa)</xsl:when>
    <xsl:when test="$lang='ton'">tonga (isole tonga)</xsl:when>
    <xsl:when test="$lang='tpi'">tok pisin</xsl:when>
    <xsl:when test="$lang='tru'">truk</xsl:when>
    <xsl:when test="$lang='tsi'">tsimshian</xsl:when>
    <xsl:when test="$lang='tsn'">tswana</xsl:when>
    <xsl:when test="$lang='tso'">tsonga</xsl:when>
    <xsl:when test="$lang='tsw'">cwana</xsl:when>
    <xsl:when test="$lang='tuk'">turcomanno</xsl:when>
    <xsl:when test="$lang='tum'">tumbuka</xsl:when>
    <xsl:when test="$lang='tup'">lingue tupi</xsl:when>
    <xsl:when test="$lang='tur'">turco</xsl:when>
    <xsl:when test="$lang='tut'">altaica (altra lingua)</xsl:when>
    <xsl:when test="$lang='tvl'">tuvalu</xsl:when>
    <xsl:when test="$lang='twi'">ci</xsl:when>
    <xsl:when test="$lang='tyv'">tuvinian</xsl:when>
    <xsl:when test="$lang='udm'">udmurt</xsl:when>
    <xsl:when test="$lang='uga'">ugaritico</xsl:when>
    <xsl:when test="$lang='uig'">uigurico</xsl:when>
    <xsl:when test="$lang='ukr'">ucraino</xsl:when>
    <xsl:when test="$lang='umb'">mbundu</xsl:when>
    <xsl:when test="$lang='und'">lingua imprecisata</xsl:when>
    <xsl:when test="$lang='urd'">urdu</xsl:when>
    <xsl:when test="$lang='uzb'">usbeco</xsl:when>
    <xsl:when test="$lang='vai'">vai</xsl:when>
    <xsl:when test="$lang='ven'">venda</xsl:when>
    <xsl:when test="$lang='vie'">vietnamita</xsl:when>
    <xsl:when test="$lang='vol'">volapuk</xsl:when>
    <xsl:when test="$lang='vot'">voto</xsl:when>
    <xsl:when test="$lang='wak'">lingue wakash</xsl:when>
    <xsl:when test="$lang='wal'">uolamo</xsl:when>
    <xsl:when test="$lang='war'">waray</xsl:when>
    <xsl:when test="$lang='was'">washo</xsl:when>
    <xsl:when test="$lang='wel'">gallese</xsl:when>
    <xsl:when test="$lang='wen'">sorabo</xsl:when>
    <xsl:when test="$lang='wln'">vallone</xsl:when>
    <xsl:when test="$lang='wol'">uolof</xsl:when>
    <xsl:when test="$lang='xal'">kalmyk</xsl:when>
    <xsl:when test="$lang='xho'">xosa</xsl:when>
    <xsl:when test="$lang='yao'">yao (bantu)</xsl:when>
    <xsl:when test="$lang='yap'">yap</xsl:when>
    <xsl:when test="$lang='yid'">yiddish</xsl:when>
    <xsl:when test="$lang='yor'">yoruba</xsl:when>
    <xsl:when test="$lang='ypk'">yupik</xsl:when>
    <xsl:when test="$lang='zap'">zapoteco</xsl:when>
    <xsl:when test="$lang='zen'">zenaga</xsl:when>
    <xsl:when test="$lang='zha'">zhuang</xsl:when>
    <xsl:when test="$lang='znd'">zande</xsl:when>
    <xsl:when test="$lang='zul'">zulu</xsl:when>
    <xsl:when test="$lang='zun'">zuni</xsl:when>
    <xsl:when test="$lang='zza'">zaza</xsl:when>
    <xsl:otherwise><xsl:value-of select="$lang"/></xsl:otherwise>
   </xsl:choose>
   <xsl:if test="position() &lt; last()">, </xsl:if>
  </xsl:for-each>
  </xsl:variable>
  <xsl:value-of select="$lingue"/>
 &br1;
</xsl:template>


<!-- ==================================================	-->
<!--	possessore	[702, 712]			-->
<!-- ==================================================	-->
<xsl:template name="possessore">
 <xsl:for-each select="df[@t=702]|df[@t=712]">
   <xsl:choose>
     <xsl:when test="sf[@c='4'] = '320'">
	Possessore:&nbsp;&nbsp;<xsl:value-of select="sf[@c='5']"/>
	<xsl:if test="position() > 1">&br1;</xsl:if>
     </xsl:when>
     <xsl:when test="sf[@c='4'] = '390'">
	Provenienza:&nbsp;&nbsp;<xsl:value-of select="sf[@c='5']"/>
	<xsl:if test="position() > 1">&br1;</xsl:if>
     </xsl:when>
   </xsl:choose>
 
 </xsl:for-each>
 </xsl:template>


<!-- ==========================================	-->
<!--	msg_960_natura()  [960]			-->
<!-- ==========================================	-->
<xsl:template name="msg_960_natura">
	<xsl:variable name="natura" select="substring(/rec/lab,8,1)"/>
<span><xsl:attribute name="class">avv</xsl:attribute>&br1;
    <xsl:choose>
	<xsl:when test="$natura = 'm'">
<span style="font-size:0.9em">
Registered users can access the library services by choosing the inventory number of the document.
<i>Controllare <a><xsl:attribute name="href"><xsl:value-of select="$contextpath"/>/modalita.jsp</xsl:attribute><xsl:attribute name="title">Controlla le modalit&agrave; per richiedere il documento</xsl:attribute>modalit&agrave;</a> e <a><xsl:attribute name="href">http://www.bncf.firenze.sbn.it/orario.php</xsl:attribute><xsl:attribute name="title">Controlla l'orario per richiedere il documento</xsl:attribute>orario</a> dei servizi</i>.
</span>
	  </xsl:when>
	  <xsl:when test="$natura = 's'">
<span style="font-size:0.9em">
Registered users can access the document by clicking on "Years owned" and choosing the desired period of years among those held by the Library.
<i>Controllare <a><xsl:attribute name="href"><xsl:value-of select="$contextpath"/>/modalita.jsp</xsl:attribute><xsl:attribute name="title">Controlla le modalit&agrave; per richiedere il documento</xsl:attribute>modalit&agrave;</a> e <a><xsl:attribute name="href">http://www.bncf.firenze.sbn.it/orario.php</xsl:attribute><xsl:attribute name="title">Controlla l'orario per richiedere il documento</xsl:attribute>orario</a> dei servizi</i>&br1;<font size="3"><i>Richiedere la copia in microfilm se presente</i></font>.
</span>
	  </xsl:when>
    </xsl:choose>
</span>
</xsl:template>


<!-- ==================================================	-->
<!--	getColloc(codbib,segn)  [960]		-->
<!-- ==================================================	-->
<xsl:template name="getColloc">
 <xsl:param name="codbib"/>
 <xsl:param name="segn"/>
 <xsl:choose>
     <xsl:when test="$codbib = 'CF'">
		<xsl:variable name="d4" select="substring($segn,1,4)"/>
		<xsl:variable name="d5" select="substring($segn,1,5)"/>
		<xsl:variable name="d6" select="substring($segn,1,6)"/>
	  <xsl:choose>
		<xsl:when test="$d4 = 'CONS'">Sale di consultazione</xsl:when>
		<xsl:when test="$d4 = 'S.M.'">Sala musica:</xsl:when>
		<!-- <xsl:when test="$d4 = 'F.ST'">Gabinetto stampe:</xsl:when> -->
		<xsl:when test="($d5 = 'RIV #') or ($d5 = 'ALF #') or ($d5 = 'PER #')">
			<xsl:text>Collocazione microfilm:</xsl:text>
		</xsl:when>
		<xsl:otherwise>Collocazione:</xsl:otherwise>
	  </xsl:choose>
     </xsl:when>
     <xsl:otherwise>Collocazione:</xsl:otherwise>
 </xsl:choose>
</xsl:template>
<!-- getColloc // -->


<!-- ==================================================	-->
<!--	getColloc1(segn) [950, obsoleto]		-->
<!-- ==================================================	-->
<xsl:template name="getColloc1">
 <xsl:param name="segn"/>

         <xsl:variable name="d4" select="substring($segn,1,4)"/>
         <xsl:variable name="d5" select="substring($segn,1,5)"/>
         <xsl:variable name="d6" select="substring($segn,1,6)"/>

    <xsl:choose>
	<xsl:when test="$d4 = 'CONS'">Sale di consultazione</xsl:when>
	<xsl:when test="$d4 = 'S.M.'">Sala musica:</xsl:when>
	<!-- <xsl:when test="$d4 = 'F.ST'">Gabinetto stampe:</xsl:when> -->
	 <xsl:when test="($d5 = 'RIV #') or ($d5 = 'ALF #') or ($d5 = 'PER #')">
	      <xsl:text>Collocazione microfilm:</xsl:text>
	 </xsl:when>
	<xsl:otherwise>Collocazione:</xsl:otherwise>
    </xsl:choose>

</xsl:template>
<!-- getColloc1 // -->


<!-- ==========================================	-->
<!--	getDistrib(tipo)  [960]			-->
<!-- ==========================================	-->
<xsl:template name="getDistrib">
 <xsl:param name="tipo"/>

   <xsl:variable name="d2" select="substring($tipo,1,2)"/>
   <xsl:variable name="d3" select="substring($tipo,1,3)"/>
   <xsl:variable name="d4" select="substring($tipo,1,4)"/>
   <xsl:variable name="d5" select="substring($tipo,1,5)"/>
   <xsl:variable name="d6" select="substring($tipo,1,6)"/>

   <xsl:variable name="distrib">
	<xsl:choose>
		<xsl:when test="($d2 = 'SP') or ($d3 ='S.P')">
			<xsl:text>Le ultime 3 annate sono disponibili in Sala periodici</xsl:text>
		</xsl:when>

		<xsl:when test="($d2  = 'G.') or ($d4 = 'GA #') or ($d5  = 'GA. #') or ($d4 = 'GE #') or ($d5  = 'GE. #') or ($d4 = 'GI #') or ($d5  = 'GI. #') or ($d5 = 'RIV #') or ($d6 = 'GIOR A') or ($d5 = 'ALF #') or ($d5 = 'PER #') or ($d2 = 'G')">
			<xsl:text>Distribuzione e consultazione in Sala periodici</xsl:text>
		</xsl:when>

		<xsl:when test="($d3 = 'MUS') or ($d4 = 'MILA') or ($d5 = 'C MUS') or ($d5 = 'N MUS')">
			<xsl:text>Distribuzione e consultazione in Sala Musica</xsl:text>
		</xsl:when>
	</xsl:choose>
   </xsl:variable>

   <xsl:if test="$distrib != ''"> (<i><xsl:value-of select="$distrib"/></i>)</xsl:if>

</xsl:template> <!-- getDistrib // -->



<!-- ==========================================	-->
<!--	inventarioDispCF	960$e		-->
<!-- ==========================================	-->
<xsl:template name="inventarioDispCF">
 <xsl:param name="disp"/>
 <xsl:param name="invm"/>
	<xsl:choose>
		<xsl:when test="$disp='A '"><xsl:value-of select="$invm"/> (<a><xsl:attribute name="href"><xsl:value-of select="$contextpath"/>/inlavorazione.jsp</xsl:attribute>disponibilit&agrave; limitata</a>)</xsl:when>
		<xsl:when test="$disp='B '"><xsl:value-of select="$invm"/> (mancante)</xsl:when>
		<xsl:when test="$disp='C '"><xsl:value-of select="$invm"/> (danneggiato)</xsl:when>
		<xsl:when test="$disp='D '"><xsl:value-of select="$invm"/> (presso ufficio interno)</xsl:when>
		<xsl:when test="$disp='E '"><xsl:value-of select="$invm"/> (escluso dalla circolazione)</xsl:when>
		<xsl:when test="$disp='F '"><xsl:value-of select="$invm"/> (materiale delle sale)</xsl:when>
	</xsl:choose>
</xsl:template> <!-- inventarioDispCF // -->



<!-- ==========================================	-->
<!--	colloc950naturam			-->
<!-- ==========================================	-->
<xsl:template name="colloc950naturam">
  <span style="font-size:0.9em">
  Registered users can access the services of the library by choosing the inventory number of the document.
  <i>Controllare <a><xsl:attribute name="href"><xsl:value-of select="$contextpath"/>/modalita.jsp</xsl:attribute><xsl:attribute name="title">Controlla le modalit&agrave; per richiedere il documento</xsl:attribute>modalit&agrave;</a> e <a><xsl:attribute name="href">http://www.bncf.firenze.sbn.it/orario.php</xsl:attribute><xsl:attribute name="title">Controlla l'orario per richiedere il documento</xsl:attribute>orario</a> dei servizi</i>.
  </span>
</xsl:template> <!-- colloc950naturam // -->



<!-- ==========================================	-->
<!--	colloc950naturas			-->
<!-- ==========================================	-->
<xsl:template name="colloc950naturas">
  <span style="font-size:0.9em">
  Registered users can access the document by clicking on "Years owned" and choosing the desired period of years among those held by the Library.
  <i>Controllare <a><xsl:attribute name="href"><xsl:value-of select="$contextpath"/>/modalita.jsp</xsl:attribute><xsl:attribute name="title">Controlla le modalit&agrave; per richiedere il documento</xsl:attribute>modalit&agrave;</a> e <a><xsl:attribute name="href">http://www.bncf.firenze.sbn.it/orario.php</xsl:attribute><xsl:attribute name="title">Controlla l'orario per richiedere il documento</xsl:attribute>orario</a> dei servizi</i>&br1;<font size="3"><i>Richiedere la copia in microfilm se presente</i></font>.
  </span>
</xsl:template> <!-- colloc950naturam // -->


</xsl:stylesheet>
