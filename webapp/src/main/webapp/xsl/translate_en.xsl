<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<!-- traduzione delle sigle -->

<xsl:template name="translate">
 <xsl:param name="section"/>
 <xsl:param name="sigla"/>
 <xsl:choose>
  <xsl:when test="$section='lingua_fc'">
	<xsl:choose>
		<xsl:when test="$sigla='ita'">italiano</xsl:when>
		<xsl:when test="$sigla='eng'">inglese</xsl:when>
		<xsl:when test="$sigla='fre'">francese</xsl:when>
		<xsl:when test="$sigla='spa'">spagnolo</xsl:when>
		<xsl:when test="$sigla='ger'">tedesco</xsl:when>
		<xsl:when test="$sigla='gre'">greco</xsl:when>
		<xsl:when test="$sigla='grc'">greco antico</xsl:when>
		<xsl:when test="$sigla='dut'">danese</xsl:when>
		<xsl:when test="$sigla='cze'">ceca</xsl:when>
		<xsl:when test="$sigla='roh'">romanica</xsl:when>
		<xsl:when test="$sigla='lat'">latino</xsl:when>
		<xsl:when test="$sigla='por'">portoghese</xsl:when>
		<xsl:when test="$sigla='mul'">multi-lingua</xsl:when>
		<xsl:when test="$sigla='slv'">slavo</xsl:when>
		<xsl:when test="$sigla='heb'">ebraico</xsl:when>
		<xsl:when test="$sigla='hun'">ungherese</xsl:when>
		<xsl:when test="$sigla='jpn'">giapponese</xsl:when>
		<xsl:when test="$sigla='nor'">norvegese</xsl:when>
		<xsl:when test="$sigla='pol'">polacco</xsl:when>
		<xsl:otherwise><xsl:value-of select="$sigla"/></xsl:otherwise>
	</xsl:choose>
  </xsl:when>
<!--
  <xsl:when test="$section='natura_fc'">
	<xsl:choose>
		<xsl:when test="$sigla='CB'">Contributo</xsl:when>
		<xsl:when test="$sigla='CO'">Collana</xsl:when>
		<xsl:when test="$sigla='MO'">Monografia</xsl:when>
		<xsl:when test="$sigla='PE'">Periodico</xsl:when>
		<xsl:when test="$sigla='MS'">Manoscritto</xsl:when>
		<xsl:otherwise><xsl:value-of select="$sigla"/></xsl:otherwise>
	</xsl:choose>
  </xsl:when>
-->
  <xsl:when test="$section='biblioteca_fc'">
     <xsl:choose>
	<xsl:when test="$sigla='CF'">B.N.C.F.</xsl:when>
	<xsl:when test="$sigla='MF'">Marucelliana, Firenze</xsl:when>
	<xsl:when test="$sigla='RF'">Riccardiana, Firenze</xsl:when>
	<xsl:when test="$sigla='FT'">Biblioteca Fondazione Turati e Associazione Pertini</xsl:when>
	<xsl:when test="$sigla='ML'">Medicea Laurenziana</xsl:when>
	<xsl:when test="$sigla='AS'">Biblioteca dell'Archivio di Stato</xsl:when>
	<xsl:when test="$sigla='FC'">Biblioteca del Conservatorio Luigi Cherubuini</xsl:when>
	<xsl:when test="$sigla='IG'">Biblioteca Attilio Mori dell'istituto geografico militare</xsl:when>
	<xsl:otherwise><xsl:value-of select="$sigla"/></xsl:otherwise>
     </xsl:choose>
  </xsl:when>
  <xsl:when test="$section='faccette'">
	<xsl:choose>
		<xsl:when test="$sigla='lingua_fc'">Lingua</xsl:when>
		<xsl:when test="$sigla='paese_fc'">Paese</xsl:when>
<!--
		<xsl:when test="$sigla='natura_fc'">Natura</xsl:when>
-->
		<xsl:when test="$sigla='categoria_fc'">Tipologia</xsl:when>
		<xsl:when test="$sigla='biblioteca_fc'">Biblioteca</xsl:when>
		<xsl:when test="$sigla='autore_fc'">Autore</xsl:when>
		<xsl:when test="$sigla='autore_kw'">Autore</xsl:when>
		<xsl:when test="$sigla='descrittore_fc'">Soggetto (descrittore)</xsl:when>
		<xsl:when test="$sigla='descrittore_kw'">Soggetto (descrittore)</xsl:when>
		<xsl:when test="$sigla='soggetto_fc'">Soggetto</xsl:when>
		<xsl:when test="$sigla='opera_fc'">Opera</xsl:when>
		<xsl:when test="$sigla='titolo_fc'">Titolo</xsl:when>
		<xsl:when test="$sigla='titolo_kw'">Titolo</xsl:when>
		<xsl:when test="$sigla='dewey_fc'">Classe Dewey</xsl:when>
		<xsl:when test="$sigla='deweycod_fc'">Classe Dewey</xsl:when>
		<xsl:when test="$sigla='deweyediz_fc'">Edizione Dewey</xsl:when>
		<xsl:when test="$sigla='keywords'">Parole chiave</xsl:when>
		<xsl:when test="$sigla='autore'">Autore</xsl:when>
		<xsl:when test="$sigla='idn'">BID</xsl:when>
		<xsl:when test="$sigla='annopub_fc'">Anno di pubblicazione</xsl:when>
		<xsl:when test="$sigla='editore_fc'">Editore</xsl:when>
		<xsl:when test="$sigla='anno1'">Anno di pubblicazione</xsl:when>
  	<xsl:otherwise><xsl:value-of select="$sigla"/></xsl:otherwise>
	</xsl:choose>
  </xsl:when>
  <xsl:when test="$section='showAll'">
	<xsl:choose>
		<xsl:when test="$sigla='lingua_fc'">lin</xsl:when>
		<xsl:when test="$sigla='biblioteca_fc'">bib</xsl:when>
		<xsl:when test="$sigla='categoria_fc'">cat</xsl:when>
		<xsl:when test="$sigla='autore_fc'">aut</xsl:when>
		<xsl:when test="$sigla='descrittore_fc'">sog</xsl:when>
		<xsl:when test="$sigla='opera_fc'">ope</xsl:when>
		<xsl:when test="$sigla='annopub_fc'">pub</xsl:when>
		<xsl:when test="$sigla='editore_fc'">edt</xsl:when>
  	<xsl:otherwise><xsl:value-of select="$sigla"/></xsl:otherwise>
	</xsl:choose>
  </xsl:when>
  <xsl:when test="$section='showAllRev'">
	<xsl:choose>
		<xsl:when test="$sigla='lin'">lingua_fc</xsl:when>
		<xsl:when test="$sigla='bib'">biblioteca_fc</xsl:when>
		<xsl:when test="$sigla='cat'">categoria_fc</xsl:when>
		<xsl:when test="$sigla='aut'">autore_fc</xsl:when>
		<xsl:when test="$sigla='sog'">descrittore_fc</xsl:when>
		<xsl:when test="$sigla='ope'">opera_fc</xsl:when>
		<xsl:when test="$sigla='pub'">annopub_fc</xsl:when>
		<xsl:when test="$sigla='edt'">editore_fc</xsl:when>
  	<xsl:otherwise><xsl:value-of select="$sigla"/></xsl:otherwise>
	</xsl:choose>
  </xsl:when>
  <xsl:when test="$section='categoria_fc'">
	<xsl:choose>
		<xsl:when test="$sigla='ED'">risorse in rete</xsl:when>
		<xsl:when test="$sigla='LI'">libri</xsl:when>
		<xsl:when test="$sigla='TD'">tesi di dottorato</xsl:when>
		<xsl:when test="$sigla='SS'">musica a stampa</xsl:when>
		<xsl:when test="$sigla='SM'">musica manoscritta</xsl:when>
		<xsl:when test="$sigla='CS'">carte geografiche a stampa</xsl:when>
		<xsl:when test="$sigla='CM'">carte geografiche manoscritte</xsl:when>
		<xsl:when test="$sigla='AV'">video</xsl:when>
		<xsl:when test="$sigla='SO'">audio</xsl:when>
		<xsl:when test="$sigla='RM'">musica</xsl:when>
		<xsl:when test="$sigla='GR'">grafica</xsl:when>
		<xsl:when test="$sigla='EL'">risorse digitali</xsl:when>
		<xsl:when test="$sigla='MM'">risorse multimediali</xsl:when>
		<xsl:when test="$sigla='AT'">oggetti a tre dimensioni</xsl:when>
		<xsl:when test="$sigla='CO'">raccolte di documenti</xsl:when>
		<xsl:when test="$sigla='PE'">periodici</xsl:when>
		<xsl:when test="$sigla='MS'">manoscritti</xsl:when>
		<xsl:when test="$sigla='DI'">digitalizzazioni complete</xsl:when>
		<xsl:when test="$sigla='DC'">digitalizzazioni parziali</xsl:when>
		<xsl:when test="$sigla='CB'">articoli e contributi</xsl:when>
		<xsl:when test="$sigla='CL'">collane</xsl:when>
		<xsl:when test="$sigla='AL'">altro</xsl:when>
		<xsl:otherwise><xsl:value-of select="$sigla"/></xsl:otherwise>
	</xsl:choose>
  </xsl:when>
  <xsl:when test="$section='paese_fc'">
	<xsl:choose>
		<xsl:when test="$sigla='it'">Italia</xsl:when>
		<xsl:when test="$sigla='en'">Gran Bretagna</xsl:when>
		<xsl:when test="$sigla='fr'">Francia</xsl:when>
		<xsl:when test="$sigla='spa'">spagnolo</xsl:when>
		<xsl:when test="$sigla='ger'">tedesco</xsl:when>
		<xsl:when test="$sigla='gre'">greco</xsl:when>
		<xsl:when test="$sigla='grc'">greco antico</xsl:when>
		<xsl:when test="$sigla='dut'">danese</xsl:when>
		<xsl:when test="$sigla='cze'">ceca</xsl:when>
		<xsl:when test="$sigla='roh'">romanica</xsl:when>
		<xsl:when test="$sigla='lat'">latino</xsl:when>
		<xsl:when test="$sigla='por'">portoghese</xsl:when>
		<xsl:when test="$sigla='mul'">multi-lingua</xsl:when>
		<xsl:when test="$sigla='slv'">slavo</xsl:when>
		<xsl:when test="$sigla='heb'">ebraico</xsl:when>
		<xsl:when test="$sigla='hun'">ungherese</xsl:when>
		<xsl:when test="$sigla='jpn'">giapponese</xsl:when>
		<xsl:when test="$sigla='nor'">norvegese</xsl:when>
		<xsl:when test="$sigla='pol'">polacco</xsl:when>
		<xsl:otherwise><xsl:value-of select="$sigla"/></xsl:otherwise>
	</xsl:choose>
  </xsl:when>
  <xsl:when test="$section='traduzioni'">
	<xsl:choose>
		<xsl:when test="$sigla='la_tua_ricerca'">Your search</xsl:when>
		<xsl:when test="$sigla='filtra_ricerca_per'">Filter your search by</xsl:when>
		<xsl:when test="$sigla='elimina_il_filtro'">remove filter</xsl:when>
		<xsl:when test="$sigla='nessun_documento_trovato'">No document found for the given parameters</xsl:when>
		<xsl:when test="$sigla='titolo'">Title</xsl:when>
		<xsl:when test="$sigla='autore'">Author</xsl:when>
		<xsl:when test="$sigla='anno'">Year</xsl:when>
		<xsl:when test="$sigla='tipologia'">Type</xsl:when>
		<xsl:when test="$sigla='forse_cercavi'">Maybe you are looking for</xsl:when>
		<xsl:when test="$sigla='documenti_trovati'">Documents found</xsl:when>
		<xsl:when test="$sigla='mostra_tutti'">show all</xsl:when>
		<xsl:when test="$sigla='vai_alla_prima_pagina'">go to the first page</xsl:when>
		<xsl:when test="$sigla='icona_vai_alla_prima_pagina'">icon: go to the first page</xsl:when>
		<xsl:when test="$sigla='vai_alla_pagina_precedente'">go to the previous page</xsl:when>
		<xsl:when test="$sigla='icona_vai_alla_pagina_precedente'">icon: go to the previous page</xsl:when>
		<xsl:when test="$sigla='vai_alla_pagina_successiva'">go to the next page</xsl:when>
		<xsl:when test="$sigla='icona_vai_alla_pagina_successiva'">icon: go to the next page</xsl:when>
		<xsl:when test="$sigla='vai_all_ultima_pagina'">go to the last page</xsl:when>
		<xsl:when test="$sigla='icona_vai_all_ultima_pagina'">icon: go to the last page</xsl:when>
		<xsl:when test="$sigla='ordina_per'">Order by</xsl:when>
		<xsl:when test="$sigla='ord_rilevanza'">relevance</xsl:when>
		<xsl:when test="$sigla='ord_anno_decrescente'">year (descending)</xsl:when>
		<xsl:when test="$sigla='ord_titolo'">title</xsl:when>
		<xsl:when test="$sigla='ord_autore'">author</xsl:when>
		<xsl:when test="$sigla='vai_doc'">vai al documento</xsl:when>
		<xsl:when test="$sigla='scegli_ordinamento'">scegli l'ordinamento</xsl:when>
		<xsl:when test="$sigla='pagina'">pagina</xsl:when>
		<xsl:otherwise><xsl:value-of select="$sigla"/></xsl:otherwise>
	</xsl:choose>
  </xsl:when>
  <xsl:otherwise>
	<xsl:call-template name="substDelim">
		<xsl:with-param name="string" select="$sigla"/>
	</xsl:call-template>
  </xsl:otherwise>
 </xsl:choose>
</xsl:template>

</xsl:stylesheet>
