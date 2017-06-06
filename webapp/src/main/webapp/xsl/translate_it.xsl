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
		<xsl:when test="$sigla='la_tua_ricerca'">La tua ricerca</xsl:when>
		<xsl:when test="$sigla='filtra_ricerca_per'">Filtra la tua ricerca per</xsl:when>
		<xsl:when test="$sigla='elimina_il_filtro'">elimina il filtro</xsl:when>
		<xsl:when test="$sigla='nessun_documento_trovato'">Nessun documento trovato con la ricerca corrente</xsl:when>
		<xsl:when test="$sigla='titolo'">Titolo</xsl:when>
		<xsl:when test="$sigla='autore'">Autore</xsl:when>
		<xsl:when test="$sigla='anno'">Anno</xsl:when>
		<xsl:when test="$sigla='tipologia'">Tipologia</xsl:when>
		<xsl:when test="$sigla='forse_cercavi'">Forse cercavi</xsl:when>
		<xsl:when test="$sigla='documenti_trovati'">Documenti trovati</xsl:when>
		<xsl:when test="$sigla='mostra_tutti'">mostra tutti</xsl:when>
		<xsl:when test="$sigla='vai_alla_prima_pagina'">vai alla prima pagina</xsl:when>
		<xsl:when test="$sigla='icona_vai_alla_prima_pagina'">icona: vai alla prima pagina</xsl:when>
		<xsl:when test="$sigla='vai_alla_pagina_precedente'">vai alla pagina precedente</xsl:when>
		<xsl:when test="$sigla='icona_vai_alla_pagina_precedente'">icona: vai alla pagina precedente</xsl:when>
		<xsl:when test="$sigla='vai_alla_pagina_successiva'">vai alla pagina successiva</xsl:when>
		<xsl:when test="$sigla='icona_vai_alla_pagina_successiva'">icona: vai alla pagina successiva</xsl:when>
		<xsl:when test="$sigla='vai_all_ultima_pagina'">vai all'ultima pagina</xsl:when>
		<xsl:when test="$sigla='icona_vai_all_ultima_pagina'">icona: vai all'ultima pagina</xsl:when>
		<xsl:when test="$sigla='ordina_per'">Ordina per</xsl:when>
		<xsl:when test="$sigla='ord_rilevanza'">rilevanza</xsl:when>
		<xsl:when test="$sigla='ord_anno_decrescente'">anno (decrescente)</xsl:when>
		<xsl:when test="$sigla='ord_titolo'">titolo</xsl:when>
		<xsl:when test="$sigla='ord_autore'">autore</xsl:when>
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
