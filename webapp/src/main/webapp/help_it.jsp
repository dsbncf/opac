<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="inc/no-cache-headers.jsp" %>
<%@ include file="inc/setup.jsp" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" lang="en" xml:lang="en">
<head>
  <meta http-equiv="content-type" content="text/html; charset=UTF-8">
  <title>SBN OPAC - <%=lang.translate("guida") %></title>
  <link rel="stylesheet" href="css/base.css"    type="text/css" media="screen"/>
  <script src="<%=contextPath %>/js/library.js" type="text/javascript" ></script>
  <style type="text/css">

li {
  margin-bottom: 5px;
}

div.titolo {
  display:block;
  height: 20px;
  margin-top: 30px;
  padding-right:4px;
  padding-top:4px;
  padding-left:4px;
  font-size: 10pt;
  font-weight: bold;
  color: #000000;
  background:#EEEEEE;
  border:1px solid #BBBBBB;
}

div.capitolo {
  border:1px solid #BBBBBB;
  border-top:none;
  padding: 10px;
}

span.esempio {
    display: inline;
    color: #FF0000;
    margin: 0px 0px 0px 0px;
}

span.pulsante {
    display: inline;
    color: #006600;
    font-variant: small-caps;
    font-weight: bold;
}


a.torna {
  display:block;
  text-align:right;
  margin-top:10px;
}


dt {
    text-decoration: underline;
    margin-top: 10px;
    margin-bottom: 2px;
}

div.negozionline { margin-top: 0.8em; }
div.risdigit { margin-top: 0.5em; }
div.coins { margin-top: 0.8em; }

a img { border: none; text-decoration: none; }

  </style>
</head>
<body>

  <%@ include file="inc/testa.jsp" %>
  <%@ include file="inc/topmenu.jsp" %>

  <div id="main" style="padding-top: 30px;">

<div style="margin-left: 40px; margin-right: 40px;">

<h3>Attenzione: versione provvisoria in corso di revisione - 23/5/2011</h3>

  <a name="inizio" class="name"></a>
 <table width="100%" align="center" cellpadding="2" cellspacing="1" bgcolor="#B8CDD8">
   <tr>
      <td style="font-weight:bold;padding-left:5px;" height="20"> Guida alla ricerca nella banca dati della Biblioteca Nazionale Centrale di Firenze. </td>

    </tr>
    <tr>
      <td bgcolor="#FFFFFF" style="padding:20px;">

  <span>La guida &egrave; composta dai seguenti capitoli:</span>

  <ol>
    <li><a href="#cennipreliminari" title="Vai al capitolo 'Cenni preliminari'">Cenni preliminari</a></li>
    <li><a href="#introduzione" title="Vai al capitolo 'Introduzione alle ricerche'">Introduzione alle ricerche</a></li>
    <li><a href="#ricercabase" title="Vai al capitolo 'Ricerca base'">Ricerca base</a></li>
    <li><a href="#ricercaavanzata" title="Vai al capitolo 'Ricerca avanzata'">Ricerca avanzata</a></li>
    <li><a href="#sintassi" title="Vai al capitolo 'Sintassi speciale per la ricerca'">Sintassi speciale per la ricerca</a></li>
    <li><a href="#liste" title="Vai al capitolo 'Liste'">Liste</a></li>
    <li><a href="#navigatoredewey" title="Vai al capitolo 'Navigatore Dewey'">Navigatore Dewey</a></li>
    <li><a href="#presentazione" title="Vai al capitolo 'Presentazione dei risultati delle ricerche'">Presentazione dei risultati delle ricerche (per lista o per elencazione)</a></li>
    <li><a href="#dettagliodocumento" title="Vai al capitolo 'Dettaglio documento'">Dettaglio documento</a></li>
    <li><a href="#carrello" title="Vai al capitolo 'Carrello'">Carrello</a></li>
    <li><a href="#accessibilita" title="Vai al capitolo 'Accessibilit&agrave;'">Accessibilit&agrave; e AccessKey</a></li>
    <li><a href="#crediti" title="Vai al capitolo 'Crediti'">Crediti</a></li>
    <li><a href="#glossario" title="Vai al 'Glossario'">Glossario</a></li>
  </ol>

      </td>
    </tr>
  </table>



  <a name="cennipreliminari"></a>

  <div class="titolo" onclick="OpenClose('cap1');" title="Apri / chiudi il capitolo" style="cursor: pointer;"><div style="float:left;">1. Cenni preliminari</div> <div style="float:right;"><img id="cap1_img" src="<%=contextPath %>/img/collapse.gif" alt="Apri / chiudi il capitolo"></div></div>
  <div id="cap1" class="capitolo">
    Il catalogo on-line della BNCF, chiamato anche <i>OPAC</i> (On-line Public Access Catalogue) della BNCF consente le ricerche nella base dati del Polo BNCF.<br/>
    <br/>
    <b>Elenco biblioteche Polo BNCF:</b><br/>

    <br/>
    <ul>
      <li>Biblioteca Nazionale Centrale di Firenze</li>
      <li>Biblioteca Marucelliana</li>
      <li>Biblioteca Medicea Laurenziana </li>
      <li>Biblioteca Riccardiana</li>
      <li>Biblioteca dell'Archivio di Stato</li>
      <li>Biblioteca del Conservatorio Luigi Cherubini</li>
      <li>Biblioteca della Fondazione di studi storici Filippo Turati</li>
      <li>Biblioteca Attilio Mori dell'Istituto geografico militare</li>
    </ul>

    <b>ATTENZIONE</b>: il Catalogo non copre l'intero posseduto delle singole biblioteche. Controllare la copertura del catalogo.<br/>
    <br/>

    Nella barra di navigazione in alto sono presentate tutte
    le opzioni di ricerca (ricerca base, ricerca avanzata, liste, ecc.).<br/>
    <br/>
    &Egrave; possibile ricercare un <i>documento</i> attraverso pi&ugrave; <i>termini</i>, filtrando successivamente i risultati per biblioteca, anno, categoria,
    lingua, tipologia, soggetto, eccetera. I risultati possono essere
    ordinati in base alla rilevanza, all'anno, all'autore o al titolo. Inizialmente tutti i risultati sono ordinati per rilevanza. Essa &egrave; l'importanza che,
    secondo parametri algebrici prestabiliti, il motore di ricerca assegna ai record bibliografici
    presenti nel Catalogo, relativamente al termine o ai termini cercati. Il risultato &egrave; la somma di fattori diversi, quali la frequenza con cui
    un determinato termine si ripete all'interno del record, il grado di rarit&agrave; del termine stesso nella base dati. <!--Per un resoconto completo
    degli algoritmi usati <a href="" target="_blank" onclick="alert('link in costruzione'); return false;">seguire il link</a>).--><br/>

    <br/>
    I <i>canali di ricerca</i> sono: <br/>
    <ul>
      <li><a href="#ricercabase" title="Vai al capitolo 'Ricerca base'">Ricerca base</a></li>
      <li><a href="#ricercaavanzata" title="Vai al capitolo 'Ricerca avanzata'">Ricerca avanzata</a></li>
      <li><a href="#liste" title="Vai al capitolo 'Liste'">Liste</a> (<i>ricerca per titoli, soggetti, autori ordinati alfabeticamente dal punto pi&ugrave; vicino a quello inserito</i>)</li>
      <li><a href="#navigatoredewey" title="Vai al capitolo 'Navigatore Dewey'">Navigatore Dewey</a> (<i>ricerca per classe di appartenenza</i>)</li>
    </ul>

    <a href="#inizio" title="Torna all'inizio della pagina" class="torna"><img src="<%=contextPath %>/img/folderopen_up.gif" alt="Torna all'inizio della pagina">Torna all'inizio</a>
  </div>

  <a name="introduzione"></a>
  <div class="titolo" onclick="OpenClose('cap2');" title="Apri / chiudi il capitolo" style="cursor: pointer;"><div style="float:left;">2. Introduzione alle ricerche</div> <div style="float:right;"><img id="cap2_img" src="<%=contextPath %>/img/collapse.gif" alt="Apri / chiudi il capitolo"></div></div>
  <div id="cap2" class="capitolo">

    Per il buon esito di una ricerca <b>si raccomanda di digitare pochi termini</b>, i pi&ugrave; rilevanti per l'identificazione del documento.
    Si restringe cos&igrave; la possibilit&agrave; di errori di digitazione e di risposte non pertinenti.<br/>

    <br/>
    Nell'effettuare le ricerche tener presente le seguenti regole di base:<br /><br />

    &bull; Le ricerche <b>non sono sensibili</b> ai caratteri maiuscoli. Ricercando casa , Casa o CASA si otterr&agrave; lo stesso risultato.<br/><br />

    &bull; Le ricerche <b>non sono sensibili</b> ai caratteri accentati o altri caratteri speciali. Ricercando citta o citt&agrave; si otterr&agrave; lo stesso risultato.
    Ugualmente cercando Muller o Müller.<br/><br />

    &bull; Nella ricerca base e avanzata, digitando pi&ugrave; parole come termini di ricerca, si otterranno per risultato tutti i documenti che contengono tutte le parole
    digitate (<b>operatore implicito and</b>).<br/><br />

    &bull; E' possibile utilizzare una sintassi speciale nelle maschere di ricerca (sia base che avanzata). Questa sintassi include i seguenti operatori:<br />
    - Operatore <b>not</b> (esclusione di una o pi&ugrave; parole)<br />
    - Operatore <b>fuzzy</b> (ricerca per termini simili)<br />
    - <b>Rilevanza</b> (possibilit&agrave; di indicare la rilevanza di una parola rispetto ad un'altra).<br />
    - Caratteri <b>jolly</b> (sostituzione di uno o pi&ugrave; caratteri all'interno di una parola)<br />
    Per una spiegazione esaustiva sull'uso di questa sintassi speciale e su come effettuarla in pratica, vedere il capitolo
    <a href="#sintassi" title="Vai al capitolo 'Sintassi speciale per la ricerca'">Sintassi speciale per la ricerca</a>.<br /><br />

    &bull; Se il risultato di una ricerca &egrave; un documento singolo, non verr&agrave; mostrata la lista con il documento, bens&igrave; il documento stesso.<br /><br />

    &bull; I <i>caratteri non di testo</i> (apostrofi, caporali ecc.) non sono considerati termini di ricerca valida.
    Possono essere digitati o meno.<br/><br />

    &bull; Per cercare una <i>frase intera, o pi&ugrave; parole secondo l'ordine esatto</i> in cui vogliamo si presentino, bisogna racchiudere la frase
    o i termini tra virgolette. <i>Esempio</i>: se digito "storia di Firenze" fra virgolette, trovo 377 documenti; se
    digito storia di Firenze senza virgolette, trovo 10736 documenti<br/><br />

    &bull; <i>Quando si attiva una ricerca per lista titolo</i>, omettere gli articoli (il, la, un, una ecc.) . Nella ricerca libera,
    base o avanzata, gli articoli, ove presenti, possono essere digitati.<br /><br />

    &bull; Si consiglia di <b>evitare di effettuare pi&ugrave; ricerche in una stessa sessione</b>, ad esempio aprendo pi&ugrave; schede del browser. Questo potrebbe invalidare alcune funzionalit&agrave;
    delle pagine web.<br /><br />

    &bull; Nel caso si sia digitata una parola errata, non esistente o che ha pochi o nessun risultato, il motore potr&agrave; dare un <b>suggerimento</b> fornendo un breve elenco di parole simili.
    Cliccare sulla parola desiderata per far partire la ricerca.

    <a href="#inizio" title="Torna all'inizio della pagina" class="torna"><img src="<%=contextPath %>/img/folderopen_up.gif" alt="Torna all'inizio della pagina">Torna all'inizio</a>

  </div>

  <a name="ricercabase"></a>
  <div class="titolo" onclick="OpenClose('cap3');" title="Apri / chiudi il capitolo" style="cursor: pointer;"><div style="float:left;">3. Ricerca base</div> <div style="float:right;"><img id="cap3_img" src="<%=contextPath %>/img/collapse.gif" alt="Apri / chiudi il capitolo"></div></div>

  <div id="cap3" class="capitolo">

    La pagina di <b>ricerca base</b> consente di interrogare il catalogo attraverso <i>una o pi&ugrave; parole</i> e vari filtri.<br/> I filtri sono presentati
    sottoforma di un elenco di voci a sinistra nella pagina della ricerca.<br />Questi filtri sono subito disponibili anche senza aver digitato alcun termine di ricerca;
    tale presentazione pu&ograve; essere utile per coloro che non sanno esattamente quali termini ricercare, per avere un'idea di base sulla disponibilit&agrave; del motore di ricerca.<br /><br />
    Per iniziare una ricerca digitare la parola o le parole desiderate e cliccare su "Cerca" o dare invio.<br />
    A questo punto il motore mostrer&agrave; i record trovati e sar&agrave; possibile raffinare la ricerca utilizzando i filtri.<br />
    Questi filtri o "<b>faccette</b>" saranno presentati solo se disponibili per la ricerca testuale appena richiesta, e potranno riguardare la
    <b>biblioteca</b>, la <b>tipologia</b>, la <b>lingua</b>, il <b>soggetto</b>, l'<b>anno di pubblicazione</b>, l'<b>autore</b>, l'<b>opera</b> o l'<b>editore</b>.<br />
    E' sufficiente cliccare su una delle voci mostrate per filtrare ulteriormente la ricerca. Per eliminare uno dei filtri scelti, cliccare sulla "<b>x</b>"
    presente accanto al filtro stesso nel box con titolo "La tua ricerca".<br />Per ordinare la ricerca, scegliere l'ordinamento desiderato dal men&ugrave; a tendina "Ordina per".<br />

    Come gi&agrave; accennato, &egrave; possibile non digitare alcuna parola e cliccare subito su uno dei filtri.<br /><br />

    Se le voci a disposizione sono molte per uno stesso filtro, verranno presentati solo quelli con il maggior numero di risultati possibili. Tale numero &egrave; indicato
    accanto alla voce, tra parentesi.<br />
    Se si desidera vedere tutte le voci a disposizione per un dato filtro, cliccare su "mostra tutti" per espandere il box. Considerare comunque che anche in
    questo caso non verranno visualizzate pi&ugrave; di una trentina di voci.<br /><br />

    <b>Esempio</b>: si vuole trovare un'edizione dei Promessi Sposi di Alessandro Manzoni, in particolare quella di F. Le Monnier del 1945.<br />
    Per fare ci&ograve;, digitare "promessi sposi manzoni" nella maschera di ricerca della ricerca base. Lanciando la ricerca, verranno presentate diverse centinaia di risultati.<br />
    Per restringere la ricerca, prima si sceglie "1941 - 1960" come anno di pubblicazione e poi "Le Monnier" come editore.<br />
    Al primo posto nella lista dei risultati, ecco apparire il record desiderato.
    <br />
    <br />
      Argomenti correlati:
          <ul>
              <li><a href="#introduzione" title="Vai al capitolo 'Introduzione alle ricerche'">Introduzione alle ricerche</a></li>
              <li><a href="#navigatoredewey" title="Vai al capitolo 'Navigatore Dewey'">Navigatore Dewey</a></li>
              <li><a href="#presentazione" title="Vai al capitolo 'Presentazione dei risultati delle ricerche'">Presentazione dei risultati delle ricerche (per lista o per elencazione)</a></li>
              <li><a href="#dettagliodocumento" title="Vai al capitolo 'Dettaglio documento'">Dettaglio documento</a></li>
          </ul>
      <a href="#inizio" title="Torna all'inizio della pagina" class="torna"><img src="<%=contextPath %>/img/folderopen_up.gif" alt="Torna all'inizio della pagina">Torna all'inizio</a>
  </div>


  <a name="ricercaavanzata"></a>
  <div class="titolo" onclick="OpenClose('cap4');" title="Apri / chiudi il capitolo" style="cursor: pointer;"><div style="float:left;">4. Ricerca avanzata</div> <div style="float:right;"><img id="cap4_img" src="<%=contextPath %>/img/collapse.gif" alt="Apri / chiudi il capitolo"></div></div>

  <div id="cap4" class="capitolo">

    La ricerca avanzata presenta molte opzioni in pi&ugrave; rispetto alla ricerca base. <br />
    Innanzitutto &egrave; possibile digitare un termine di ricerca in un <b>canale specifico</b>. I canali a disposizione sono presentati con un men&ugrave; a tendina e
    sono i seguenti:<br />

          <ul>
              <li>Autore</li>
              <li>Titolo</li>
              <li>Soggetto</li>
              <li>Collana</li>

              <li>Classe (numero CDD) (vedi "<a href="#navigatoredewey" title="Vai al capitolo 'Navigatore Dewey'">Navigatore Dewey</a>")</li>
              <li>Classe (parola chiave CDD) (vedi "<a href="#navigatoredewey" title="Vai al capitolo 'Navigatore Dewey'">Navigatore Dewey</a>")</li>
              <li>Luogo</li>
              <li>Editore</li>
              <li>Identificatori standard (numero ISBN, BNI, CUBI, impronta ecc.)</li>

              <li>Marca</li>
              <li>Collocazione</li>
              <li>Parole chiave</li>
              <li>Identificativo titolo</li>
              <li>Identificativo autore</li>
              <li>Identificativo soggetto</li>

              <li>Inventario</li>
          </ul>

    Occorre prestare una certa attenzione nel lanciare la ricerca, per esempio scrivendo "promessi sposi" e scegliendo il canale "autore", non si otterr&agrave; alcun risultato, al contrario
    scegliendo il canale "titolo" si potranno trovare migliaia di record bibliografici.<br />
    Oltre alla ricerca testuale per canale, &egrave; possibile inserire <b>ulteriori opzioni di ricerca</b>: il paese di pubblicazione, la lingua, la tipologia, l'edizione Dewey, l'anno di pubblicazione
    (da anno - a anno), l'anno di inserimento (da anno - a anno), la biblioteca e il soggettario.<br />
    Assieme alle opzioni di ricerca, sono ripresentati i filtri della ricerca base per raffinare ulteriormente la lista dei risultati.<br />
    La lista dei risultati pu&ograve; essere ordinata scegliendo una voce dal men&ugrave; a tendina "Ordina per".<br /><br />

      <a href="#inizio" title="Torna all'inizio della pagina" class="torna"><img src="<%=contextPath %>/img/folderopen_up.gif" alt="Torna all'inizio della pagina">Torna all'inizio</a>
  </div>


  <a name="sintassi"></a>
  <div class="titolo" onclick="OpenClose('cap5');" title="Apri / chiudi il capitolo" style="cursor: pointer;"><div style="float:left;">5. Sintassi speciale per la ricerca</div> <div style="float:right;"><img id="cap5_img" src="<%=contextPath %>/img/collapse.gif" alt="Apri / chiudi il capitolo"></div></div>

  <div id="cap5" class="capitolo">
    E' possibile utilizzare alcuni operatori speciali ed altre opzioni particolari per effettuare delle ricerche anche molto avanzate. Questi operatori possono essere utilizzati ad libitum in
    ogni campo di tipo "testo", sia nella ricerca base che nella ricerca avanzata.<br />Segue un elenco di questi operatori con una breve spiegazione di utilizzo.<br /><br />

    <b>Ricerca per frase esatta</b><br />
    Se si desidera cercare i record bibliografici che contengono una frase esatta, sar&agrave; sufficiente scrivere la frase esatta racchiusa tra virgolette.<br />
    Ad esempio se si vogliono trovare tutti i record disponibili che contengono la frase "sposi promessi", baster&agrave; racchiuderla tra virgolette. E' ovvio che c'&egrave; una sostanziale differenza
    tra il cercare "promessi sposi" e "sposi promessi", se si utilizza con questa opzione: non utilizzando le virgolette i risultati saranno identici, utilizzandole saranno
    invece molto diversi.<br /><br />

    <b>Esclusione di parole - Operatore "not"</b><br />
    L'operatore di esclusione "not" &egrave; utile in tutti quei casi in cui si desidera escludere una parola dalla ricerca.<br />
    Per utilizzarlo, occorre far precedere il simbolo - (meno) alla parola che si desidera escludere.<br />
    Ad esempio se si desidera trovare tutti i record bibliografici che hanno nel titolo le parole "sposi" ma che non hanno la parola "promessi", si potrebbe
    digitare "sposi -promessi" nel campo di ricerca della ricerca base.<br />
    Un esempio pi&ugrave; particolare da utilizzare nella ricerca avanzata: volendo trovare tutti i record bibliografici che hanno nel titolo le parole "promessi sposi",
    ma che non hanno per autore Alessandro Manzoni, si potrebbe digitare "promessi sposi" nel canale di ricerca "titolo", e "-manzoni" nel canale di ricerca "autore".<br /><br />

    <b>Ricerca per termini simili - Operatore "fuzzy"</b><br />
    L'operatore "fuzzy" &egrave; utilizzato in tutti quei casi in cui si desidera effettuare una ricerca per termini simili.<br />
    Per utilizzarlo occorre scrivere la parola da ricercare seguita dal simbolo "tilde" ~ che si ottiene tenendo premuto Alt mentre si digita
    126 sul tastierino numerico.<br />L'operatore Fuzzy amplia notevolmente le possibilit&agrave; che una ricerca abbia buon esito, abbattendo difficolt&agrave; di trascrizione e
    memorizzazione.<br />
    <i>Esempio</i>: nella ricerca avanzata selezionare dal men&ugrave; a tendina il campo Autore, digitare "chiaijkoskj~", e lanciare la ricerca.
    Si apre una lista di 206 record, tutti legati all'autore Čajkovskij, Petr Il'ič. Questo nonostante non si fosse digitato correttamente il nome oggetto della
    ricerca.<br/>
    Altro esempio: si cerca un libro di cui si ricorda il titolo in modo poco preciso: I porcospini (o il porcospino) di Schopenhauer (o Schopenauer, o Schopenauar ecc. ec.).
    Nella ricerca base scrivere "porcospino~ schopenauar~". Lanciando la ricerca si otterr&agrave; la risposta: Documenti trovati: 2.<br/><br />

    <b>Ricerca con parole parziali - Carattere Jolly *</b><br />
    Il carattere jolly * sostituisce <i>uno o pi&ugrave; caratteri</i> all'interno di un termine di ricerca.<br/>
    <i>Esempio</i>: cercando cas*, verranno visualizzati tutti i risultati che contengono parole come casa, casualit&agrave;, casolare,
    eccetera. <i>Attenzione</i>: Le interrogazioni con asterisco a destra possono non essere eseguite in quando sviluppano una serie di
    interrogazioni in or di oltre 1000 termini. Se digito come termine di ricerca par*, si sviluppano una serie di ricerche su termini come pari, parti, parte,
    particolare ecc.<br/><br />

    <b>Ricerca con parole parziali - Carattere Jolly ?</b><br />
    Il carattere jolly ? sostituisce <i>un solo carattere</i> all'interno di un termine di ricerca.<br/>
    <i>Esempio</i>: cercando cas?, verranno visualizzati tutti i risultati che contengono le parole come casa, case, caso, eccetera.<br/><br />

    <b>Ricerca per rilevanza - Carattere ^</b><br />

    Quando si desidera dare pi&ugrave; rilevanza ad una parola piuttosto che ad un'altra, &egrave; possibile ricercare per rilevanza utilizzando il carattere "accento circonflesso" ^,
    subito dopo la parola da ricercare e seguito da un numero per indicarne la rilevanza.
    <i>Esempio di ricerca con accento circonflesso^</i>: si vogliono cercare tutti i documenti di un autore che ha per cognome "Manzoni".
    Si vuole per&ograve; che quelli legati al nome "Carlo" siano presentati per primi, e quelli legati al nome "Alessandro" per ultimi. La ricerca potrebbe essere impostata
    nel modo seguente: "manzoni carlo^10" che tradotto vuol dire "trova tutti i libri che hanno per autore un Manzoni, ma dai pi&ugrave; importanza a Carlo e quindi
    presentali per primi".

      <a href="#inizio" title="Torna all'inizio della pagina" class="torna"><img src="<%=contextPath %>/img/folderopen_up.gif" alt="Torna all'inizio della pagina">Torna all'inizio</a>

  </div>


  <a name="liste"></a>
  <div class="titolo" onclick="OpenClose('cap6');" title="Apri / chiudi il capitolo" style="cursor: pointer;"><div style="float:left;">6. Liste</div> <div style="float:right;"><img id="cap6_img" src="<%=contextPath %>/img/collapse.gif" alt="Apri / chiudi il capitolo"></div></div>

  <div id="cap6" class="capitolo">
    La pagina di <i>ricerca per liste</i>, consente di effettuare ricerche <i>alfabetiche</i> nei descrittori, titoli, autori o soggetti dei documenti.<br/>
    Scrivendo un termine, anche incompleto, nel campo testuale, e scegliendo il canale di ricerca, verr&agrave; presentata la lista dei titoli, descrittori, autori o soggetti alfabeticamente pi&ugrave; vicini al termine
    digitato. Cliccando su Precedenti o Successivi sar&agrave; possibile scorrere la lista.<br/>
    <br/>
    <i>Esempio</i>: digitando promessi verr&agrave; presentato come risultato<br/>

    <ul>
      <li>I promessi del cielo</li>
      <li>Promessi in USA</li>
      <li>I promessi paperi</li>
      <li>I promessi paperi e altri capolavori della letteratura universale</li>
    </ul>
    <br/>

    Se il termine digitato non dovesse esistere nella banca dati, verr&agrave; presentato il <i>termine ad esso pi&ugrave; vicino</i>.
    Si avr&agrave; cos&igrave; l'<i>assoluta certezza</i> che quel termine non esiste.<br/>
    <br/>
    <i>Esempio</i>: digitando promiz il risultato sar&agrave;<br/>
    <ul>
      <li>Promo racing news</li>

      <li>Promocamera news</li>
      <li>Promocrazia</li>
      <li>Promocronaca</li>
      <li>Promomedia</li>
      <li>Le promontoire</li>
    </ul>

    <br/>
    <i>Attenzione: in questa opzione di ricerca ricordarsi di non digitare l'articolo iniziale</i><br/><br />

    Se si spunta l'opzione <b>cerca per parole contenute</b>, il termine digitato verr&agrave; cercato nel canale scelto (descrittori, titoli, autori o soggetti) ma non si trover&agrave;
    necessariamente all'inizio. Ad esempio, digitando "promessi" nel canale "titolo", si troveranno tutti i record con titolo che inizia per <i>promessi</i>, ordinati alfabeticamente.
    La stessa ricerca con l'opzione spuntata, dar&agrave; un altro risultato cercando tutti i record che hanno la parola "promessi" nel titolo, ma che non si trova necessariamente
    all'inizio del titolo stesso.
    <br/>
    <br/>
      Argomenti correlati:
        <ul>
            <li><a href="#introduzione" title="Vai al capitolo 'Introduzione alle ricerche'">Introduzione alle ricerche</a></li>
            <li><a href="#presentazione" title="Vai al capitolo 'Presentazione dei risultati delle ricerche'">Presentazione dei risultati delle ricerche (per lista o per elencazione)</a></li>
            <li><a href="#dettagliodocumento" title="Vai al capitolo 'Dettaglio documento'">Dettaglio documento</a></li>

        </ul>
    <a href="#inizio" title="Torna all'inizio della pagina" class="torna"><img src="<%=contextPath %>/img/folderopen_up.gif" alt="Torna all'inizio della pagina">Torna all'inizio</a>
  </div>

  <a name="navigatoredewey"></a>
  <div class="titolo" onclick="OpenClose('cap7');" title="Apri / chiudi il capitolo" style="cursor: pointer;"><div style="float:left;">7. Navigatore Dewey</div> <div style="float:right;"><img id="cap7_img" src="<%=contextPath %>/img/collapse.gif" alt="Apri / chiudi il capitolo"></div></div>

  <div id="cap7" class="capitolo">
    Il navigatore Dewey della banca dati della BNCF &egrave; ispirato all'
    <a href="http://www.oclc.org/nextspace/001/research.htm" title="Informazioni su OCLC DeweyBrowser (si apre in altra finestra)" target="_BLANK">
      <acronym title="Online Computer Library Center">
        OCLC
      </acronym>
      DeweyBrowser
    </a>
    e si basa sulle edizioni italiane della Classificazione Decimale Dewey (CDD, DCC in inglese).<br/>
    La <i>Classificazione Decimale Dewey</i> (CDD) &egrave; un sistema di classificazione di documenti su base disciplinare costruito secondo il
    sistema decimale. E' articolata in dieci classi principali, cento divisioni, mille sezioni. La classificazione, contraddistinta da una notazione numerica,
    definisce 10 classi principali. In ogni <i>classe primaria</i> sono presenti delle suddivisioni, ovvero <i>classi secondarie</i>, il cui codice
    inizia con il numero della classe principale. Il secondo numero &egrave; invece riservato alla classe secondaria.<br/>

    <br/>
    <i>Esempio</i>: ogni documento appartenente alla classe primaria SCIENZE SOCIALI avr&agrave; un codice che inizia con 3. Ogni classe secondaria
    della classe SCIENZE SOCIALI avr&agrave; un codice che inizia sempre per 3, mentre il secondo numero &egrave; caratteristico della classe secondaria. Quindi: 300 Scienze
    sociali,<br/>
    310 Statistica <br/>
    320 Scienza politica<br/>
    330 Economia<br/>
    ecc.<br/>

    <br/>
    Si tratta quindi di un <i>albero gerarchico per argomenti all'interno di ambiti disciplinari</i><br/>
    <br/>
    Le 10 classi principali (cio&egrave; i 10 ambiti secondo cui Dewey ha organizzato le diverse discipline) sono :
    <ol start="0">
      <li>GENERALIT&Agrave; (enciclopedie, bibliografie, ecc.)</li>
      <li>FILOSOFIA E PSICOLOGIA</li>

      <li>RELIGIONE</li>
      <li>SCIENZE SOCIALI, POLITICHE, ECONOMICHE DIRITTO EDUCAZIONE COMUNICAZIONE USI E COSTUMI</li>
      <li>LINGUAGGIO</li>
      <li>SCIENZE NATURALI E MATEMATICA</li>
      <li>SCIENZE APPLICATE</li>
      <li>LE ARTI. BELLE ARTI E ARTI DECORATIVE</li>

      <li>LETTERATURA (BELLE LETTERE) E RETORICA</li>
      <li>GEOGRAFIA, STORIA E DISCIPLINE AUSILIARIE</li>
    </ol>
    <br/>
    Melvil Dewey pubblic&ograve; la prima edizione del sistema decimale di classificazione Dewey (DDC) nel 1876, quando era assistente nella Biblioteca dell'Universit&agrave; di
    Amherst.<br/>
    Essa &egrave; stata nel tempo periodicamente aggiornata ed &egrave; tuttora la principale forma di classificazione dei documenti in una biblioteca. Attualmente &egrave; in uso la 21esima
    edizione e in corso di traduzione la 22esima.<br/>
    Il <i>navigatore Dewey</i> &egrave; particolarmente utile quando non si cerca un documento specifico, bens&igrave; un insieme di documenti per studio o
    ricerca su un argomento particolare. Per chiarire, &egrave; come se in una biblioteca o in una libreria si scorresse uno scaffale.<br/>

    <br/>
    <i>Come utilizzare il navigarore Dewey della presente banca dati</i><br/>
    Inizialmente viene presentato l'elenco delle classi principali. Cliccando su una di esse, si aprir&agrave; l'albero sottostante e verranno elencate le classi secondarie.
    Si pu&ograve; procedere cliccando sulle classi secondarie, sulle divisioni e sulle sezioni fino a raggiungere l'argomento desiderato.<br/>
    La tabella mostra il <i>codice numerico</i> corrispondente all'argomento (classi primarie, secondarie, divisioni e sezioni),
    il nome dell'argomento e il numero di notizie presenti in Catalogo legate a quel codice. Ciccando sulla descrizione o sul numero delle notizie,
    verr&agrave; visualizzato l'elenco breve dei documenti. Cliccando su uno di essi, si potranno visionare i dati desiderati.<br/>
    <br/>
    <i>Esempio</i>: volendo cercare tutti i documenti presenti in Catalogo sulla fotosintesi, si pu&ograve; procedere cos&igrave;:<br/>

    Cliccare su 5. <i>SCIENZE NATURALI E MATEMATICA</i><br/>
    Cliccare su 58. <i>PIANTE</i><br/>
    Cliccare su 581 <i>MORFOLOGIA E FISIOLOGIA VEGETALE</i><br/>
    Ciccare su 581.13342 <i>FISIOLOGIA VEGETALE. FOTOSINTESI</i> e scegliere dalla lista il documento desiderato.<br/>

      <br/>
      Argomenti correlati:
          <ul>
              <li><a href="#presentazione" title="Vai al capitolo 'Presentazione dei risultati delle ricerche'">Presentazione dei risultati delle ricerche (per lista o per elencazione)</a></li>
              <li><a href="#dettagliodocumento" title="Vai al capitolo 'Dettaglio documento'">Dettaglio documento</a></li>
          </ul>
      <a href="#inizio" title="Torna all'inizio della pagina" class="torna"><img src="<%=contextPath %>/img/folderopen_up.gif" alt="Torna all'inizio della pagina">Torna all'inizio</a>
  </div>




  <a name="presentazione"></a>
  <div class="titolo" onclick="OpenClose('cap8');" title="Apri / chiudi il capitolo" style="cursor: pointer;"><div style="float:left;">8. Presentazione dei risultati delle ricerche (per lista o per elencazione)</div> <div style="float:right;"><img id="cap8_img" src="<%=contextPath %>/img/collapse.gif" alt="Apri / chiudi il capitolo"></div></div>
  <div id="cap8" class="capitolo">
    I risultati delle ricerche possono essere di due tipi:<br/>
    Un <i>elenco di documenti</i> (risultato di una ricerca libera, base o avanzata e della ricerca con navigatore Dewey)<br/>
    Una <i>lista</i> di titoli, autori o soggetti (risultato di una ricerca su lista titoli, autori o soggetti)<br/>

    <br/>
    <i>Elenco di documenti</i><br/>
    Di ogni documento viene riportato il titolo, l'autore, l'anno e il tipo (ovvero la categoria).<br/>
    L'elenco di documenti che viene mostrato dopo aver lanciato una ricerca, pu&ograve; essere ulteriormente filtrato e ordinato.</br>
    Per filtrare i risultati &egrave; possibile cliccare sul filtro desiderato nella colonna grigia a sinistra.<br />
    Per scegliere come ordinare i documenti, dopo aver lanciato la ricerca, cliccare sul men&ugrave; a tendina Ordinati per, che compare sopra l'elenco dei risultati.
    Quindi cliccare sul bottone a forma di freccia posizionato accanto. I documenti verranno ordinati nel modo desiderato. E' possibile ordinare un documento
    per rilevanza, anno (decrescente), autore, titolo.<br />
    Inizialmente l'ordine &egrave; per rilevanza.<br/>
    Cliccando sul titolo del documento desiderato, verr&agrave; presentata la scheda del dettaglio documento con tutte le informazioni a disposizione in Catalogo.<br/>
    <br/>
    Sotto la tabella dei risultati, quando questi ultimi sono in numero superiore a 20, apparir&agrave; una semplice <i>sezione di navigazione</i>
    per scorrere la lista.<br/>
    <br/>
    <i>Lista di titoli, autori o soggetti</i><br/>
    Si tratta di una <i>lista in ordine alfabetico</i> di titoli, autori o soggetti (attenzione: l'ordine alfabetico non considera gli articoli)
    nel quale viene presentato il nome, il titolo o il soggetto e il numero di notizie cos&igrave; classificate.<br/>

    Cliccando su Avanti o su Indietro &egrave; possibile scorrere la lista.<br/>
    Cliccando sul nome, sul titolo o sul soggetto cercato, verr&agrave; presentato l'elenco di documenti collegati.<br/>
      <br>
      Argomenti correlati:
          <ul>
              <li><a href="#ricercabase" title="Vai al capitolo 'Ricerca base'">Ricerca base</a></li>

              <li><a href="#ricercaavanzata" title="Vai al capitolo 'Ricerca avanzata'">Ricerca avanzata</a></li>
              <li><a href="#listatitoli" title="Vai al capitolo 'Lista titoli'">Lista titoli</a></li>
              <li><a href="#liste" title="Vai al capitolo 'Liste'">Liste</a></li>
              <li><a href="#navigatoredewey" title="Vai al capitolo 'Navigatore Dewey'">Navigatore Dewey</a></li>
              <li><a href="#dettagliodocumento" title="Vai al capitolo 'Dettaglio documento'">Dettaglio documento</a></li>

          </ul>
      <a href="#inizio" title="Torna all'inizio della pagina" class="torna"><img src="<%=contextPath %>/img/folderopen_up.gif" alt="Torna all'inizio della pagina">Torna all'inizio</a>
  </div>

  <a name="dettagliodocumento"></a>
  <div class="titolo" onclick="OpenClose('cap9');" title="Apri / chiudi il capitolo" style="cursor: pointer;"><div style="float:left;">9. Dettaglio documento</div> <div style="float:right;"><img id="cap9_img" src="<%=contextPath %>/img/collapse.gif" alt="Apri / chiudi il capitolo"></div></div>
  <div id="cap9" class="capitolo">
    Il <i>dettaglio documento</i> presenta la scheda completa di un documento (notizia) cos&igrave; come &egrave; stato inserito in Catalogo.<br/>

    In alto sopra alla scheda &egrave; presente una <i>barra di navigazione</i>. Se si proviene da una lista di risultati, i tasti, posizionati nella
    barra in alto a destra, sono attivati e, senza tornare alla pagina della lista, si potranno scorrere tutti i documenti risultanti dalla ricerca. Basta cliccare sulle
    frecce (sinistra per il documento precedente, destra per il documento successivo).<br/>
    Cliccando sul link "torna alla lista dei risultati" sar&agrave; invece possibile tornare alla lista originaria.<br/>
    <br/>
    All'interno del dettaglio documento sono presenti collegamenti che permettono di effettuare <i>ulteriori ricerche</i>.<br/>

    <br/>
    <i>Esempio</i>: cliccando sul nome dell'autore si potranno visualizzare tutti i documenti legati a quell'autore.<br/>
    <br/>
    L'utente autorizzato potr&agrave; richiedere il documento in lettura o in prestito. A tale scopo bisogner&agrave; cliccare sul numero d'inventario, che compare in basso sotto la collocazione.
    L'utente verr&agrave; cos&igrave; indirizzato alla pagina di identificazione utente e guidato nel percorso di richiesta. Se il documento da richiedere &egrave; un periodico, anzich&eacute;
    cliccare sull'inventario, bisogner&agrave; cliccare su Annate possedute.<br/>
    Per l'autorizzazione bisogna recarsi presso la sede della Biblioteca e richiedere la tessera. Esistono varie forme di autorizzazione.
    Si consiglia di consultare il
    <a href="http://www.bncf.firenze.sbn.it/pagina.php?id=69&amp;rigamenu=Regolamento%20interno" title="Regolamento interno"  target="_blank">
      regolamento interno BNCF
    </a>.
    <br/>

    Nel dettaglio documento, in basso, &egrave; possibile scegliere alcune opzioni aggiuntive:<br />

    <ul>
      <li>salvataggio della scheda in formato .txt;</li>
      <li>visualizzazione della scheda nel formato <i>UnimarcXml</i> (si tratta di un formato in uso tra i bibliotecari);</li>
      <li>possibilit&agrave; di inserire un commento. I commenti non saranno pubblicati e possono essere usati per segnalare un errore nella scheda o richiedere informazioni;</li>
      <li>icona "carrello", che salva temporaneamente il documento in una lista personale, modificabile e stampabile. Vedere il <a href="#carrello" title="Vedi il capitolo 'carrello'">capitolo relativo</a> al carrello
        per maggiori informazioni;</li>
      <li>possibilit&agrave; di salvare l'indirizzo della scheda nei maggiori social network presenti in rete.</li>
    </ul>
      <br>
      Argomenti correlati:
          <ul>
              <li><a href="#introduzione" title="Vai al capitolo 'Introduzione alle ricerche'">Introduzione alle ricerche</a></li>
              <li><a href="#presentazione" title="Vai al capitolo 'Presentazione dei risultati delle ricerche'">Presentazione dei risultati delle ricerche (per lista o per elencazione)</a></li>
              <li><a href="#carrello" title="Vai al capitolo 'Carrello'">Carrello</a></li>
          </ul>

      <a href="#inizio" title="Torna all'inizio della pagina" class="torna"><img src="<%=contextPath %>/img/folderopen_up.gif" alt="Torna all'inizio della pagina">Torna all'inizio</a>
  </div>


  <a name="carrello"></a>
  <div class="titolo" onclick="OpenClose('cap10');" title="Apri / chiudi il capitolo" style="cursor: pointer;"><div style="float:left;">10. Carrello</div> <div style="float:right;"><img id="cap10_img" src="<%=contextPath %>/img/collapse.gif" alt="Apri / chiudi il capitolo"></div></div>
  <div id="cap10" class="capitolo">
    Il carrello &egrave; una nuova funzionalit&agrave; messa a disposizione per rendere pi&ugrave; agevoli le ricerche e le richieste di documenti.<br />
    Nella scheda del documento &egrave; presente un'icona che, se cliccata, salver&agrave; il riferimento al documento in una lista raggiungibile dal men&ugrave;
    principale. E' così possibile avere una lista di documenti preferiti da salvare, esportare o visualizzare a piacere.<br />
    Il salvataggio &egrave; <b>temporaneo</b>, ovvero scade alla scadenza della sessione. Questo significa che se il browser viene chiuso o se si lascia passare molto tempo
    lasciando inattivo il sito, il carrello verr&agrave; svuotato.<br /><br />
    Per esportare il carrello scegliere il formato nella pagina stessa del carrello, in alto, e cliccare su "esporta". 
    Il documento verr&agrave; salvato sul supporto scelto.<br /><br />
    Per eliminare un singolo riferimento ad un documento, cliccare sull'icona cestino nella lista visibile nel carrello. La linea verr&agrave; immediatamente eliminata.
    <br/>
    <br/>
    <a href="#inizio" title="Torna all'inizio della pagina" class="torna"><img src="<%=contextPath %>/img/folderopen_up.gif" alt="Torna all'inizio della pagina">Torna all'inizio</a>
  </div>


  <a name="accessibilita"></a>
  <div class="titolo" onclick="OpenClose('cap11');" title="Apri / chiudi il capitolo" style="cursor: pointer;"><div style="float:left;">11. Accessibilit&agrave; e AccessKey</div> <div style="float:right;"><img id="cap11_img" src="<%=contextPath %>/img/collapse.gif" alt="Apri / chiudi il capitolo"></div></div>
  <div id="cap11" class="capitolo">
    Per rendere pi&ugrave; agevole la navigazione del sito sono state attivate alcune scorciatoie da tastiera (tasti di scelta rapida o <i>AccessKey</i>)
    per il men&ugrave; principale. Le <i>AccessKey</i> permettono di muoversi nel sito senza utilizzare il mouse, con il solo ausilio della tastiera.<br/>

    <br/>
    <i>Per utilizzare le AccessKey</i>:<br/>
    per chi usa <i>Internet Explorer</i> premere ALT pi&ugrave; la lettera della tabella sottostante pi&ugrave; INVIO.<br/>
    per chi usa Netscape 6/7 - Mozilla 1.0/1.1 premere <i>ALT</i> pi&ugrave; la lettera della tabella sottostante<br/>

    per chi usa Mozilla Firefox 0.8 - 2.0 premere <i>ALT</i> pi&ugrave; la lettera della tabella sottostante<br/>
    per chi usa Mozilla Firefox 2.0.0.1/... premere <i>ALT</i> pi&ugrave; <i>SHIFT</i> pi&ugrave; la lettera della tabella sottostante<br/>
    per chi usa iCab (Mac) premere <i>ALT</i> pi&ugrave; la lettera della tabella sottostante. Per gli utenti Apple, usare il tasto CMD
    (tasto mela) al posto dell'ALT.<br/>

    Per chi usa Amaya premere <i>CTRL</i> o <i>ALT</i> (a seconda delle preferenze settate), pi&ugrave; la lettera della tabella
    sottostante.<br/>
    <ul style="list-style-type: circle;">

      <li><span class="pulsante">ALT</span> + <span class="pulsante">b</span> &#160;&#160;&#160; Ricerca <b><u>b</u></b>ase</li>
      <li><span class="pulsante">ALT</span> + <span class="pulsante">a</span> &#160;&#160;&#160; Ricerca <b><u>a</u></b>vanzata</li>

      <li><span class="pulsante">ALT</span> + <span class="pulsante">l</span> &#160;&#160;&#160; <b><u>L</u></b>iste</li>
      <li><span class="pulsante">ALT</span> + <span class="pulsante">t</span> &#160;&#160;&#160; <b><u>T</u></b>hesaurus</li>

      <li><span class="pulsante">ALT</span> + <span class="pulsante">d</span> &#160;&#160;&#160; Navigatore <b><u>D</u></b>ewey</li>

      <li><span class="pulsante">ALT</span> + <span class="pulsante">h</span> &#160;&#160;&#160; Aiuto (<b><u>h</u></b>elp)</li>
      <li><span class="pulsante">ALT</span> + <span class="pulsante">r</span> &#160;&#160;&#160; C<b><u>r</u></b>editi</li>
      <li><span class="pulsante">ALT</span> + <span class="pulsante">c</span> &#160;&#160;&#160; <b><u>C</u></b>arrello</li>

    </ul>
    Altre <i>AccessKey</i> per la navigazione di liste e documenti:
    <ul style="list-style-type: circle;">
      <li><span class="pulsante">ALT</span> + <span class="pulsante">+</span> &#160;&#160;&#160; Avanti di una pagina (nelle liste) o di un documento (in dettaglio documento)</li>

      <li><span class="pulsante">ALT</span> + <span class="pulsante">-</span> &#160;&#160;&#160; Indietro di una pagina (nelle liste) o di un documento (in dettaglio documento)</li>
      <li><span class="pulsante">ALT</span> + <span class="pulsante">i</span> &#160;&#160;&#160; <b><u>I</u></b>nizio della lista (nelle liste) o torna alla ricerca (in dettaglio documento)</li>

      <li><span class="pulsante">ALT</span> + <span class="pulsante">f</span> &#160;&#160;&#160; <b><u>F</u></b>ine della lista</li>

    </ul>
    Si ricorda che &egrave; comunque possibile utilizzare il tasto TAB per scorrere tutti i collegamenti di ogni pagina. Dando INVIO si verr&agrave; diretti verso il
    collegamento selezionato (vale per tutti i browser).<br/>
    <br/>
    <!-- @todo le etichette sono tutte da controllare
    Il sito &egrave; arricchito di <i>etichette</i>. Posizionando il mouse su qualunque oggetto presentato (collegamenti, campi, bottoni, ecc) sar&agrave;
    possibile visualizzare una <i>breve descrizione</i> dell'oggetto stesso. I collegamenti che aprono una <i>nuova finestra
    del browser</i> sono segnalati attraverso apposita etichetta ("si apre in altra finestra").<br/>
    Alcune versioni di <i>Internet Explorer</i> potrebbero non avere supportata questa funzionalit&agrave;.<br/>
    -->
    <br/>
    Si ricorda inoltre che nelle maschere di ricerca, una volta inserito il termine da ricercare, sar&agrave; sufficiente premere INVIO sulla tastiera per ottenere la
    visualizzazione dei risultati.
    <br/>
    <br/>
      <a href="#inizio" title="Torna all'inizio della pagina" class="torna"><img src="<%=contextPath %>/img/folderopen_up.gif" alt="Torna all'inizio della pagina">Torna all'inizio</a>
  </div>

  <a name="crediti"></a>
  <div class="titolo" onclick="OpenClose('cap11');" title="Apri / chiudi il capitolo" style="cursor: pointer;"><div style="float:left;">11. Crediti</div> <div style="float:right;"><img id="cap11_img" src="<%=contextPath %>/img/collapse.gif" alt="Apri / chiudi il capitolo"></div></div>
  <div id="cap11" class="capitolo">
      La pagina dei <i>crediti</i> illustra i software utilizzati per la struttura del sito.<br>
      Cliccare sui loghi per visualizzare le pagine dei software o delle softwarehouse (si
      aprono tutti in una finestra esterna).
      <br><br>
      <a href="#inizio" title="Torna all'inizio della pagina" class="torna"><img src="<%=contextPath %>/img/folderopen_up.gif" alt="Torna all'inizio della pagina">Torna all'inizio</a>

  </div>

  <a name="glossario"></a>
  <div class="titolo" onclick="OpenClose('cap12');" title="Apri / chiudi il capitolo" style="cursor: pointer;"><div style="float:left;">12. Glossario</div> <div style="float:right;"><img id="cap12_img" src="<%=contextPath %>/img/collapse.gif" alt="Apri / chiudi il capitolo"></div></div>
  <div id="cap12" class="capitolo">
          <dl>
          <dt>AccessKey</dt>
              <dd>Tasti di scelta rapida, direttamente da tastiera, per la navigazione del sito senza l'uso del mouse.
              Vedi il <a href="#accessibilita" title="Vedi il capitolo 'Accessibilt&agrave; e AccessKey'">capitolo relativo</a>.</dd>

          <dt>Campo (di ricerca, di testo, ecc)</dt>
              <dd>Qualunque campo bianco dove &egrave; possibile inserire del testo per le ricerche.</dd>
          <dt>Classe Dewey</dt>
              <dd>La singola disciplina, identificata da un numero, all'interno della quale si fanno confluire documenti affini, secondo l'ordinamento del Sistema di
              classificazione Dewey.
              Vedi il <a href="#navigatoredewey" title="Vai al capitolo 'Navigatore Dewey'">capitolo relativo</a>.</dd>
          <dt>Dewey</dt>

              <dd>La <i>Classificazione Decimale Dewey</i> (CDD) &egrave; un sistema di classificazione su base disciplinare costruito secondo
              il sistema decimale. &egrave; articolata in dieci classi principali, cento divisioni, mille sezioni.
              Vedi la voce "Classe Dewey".</dd>
          <dt>Documento (o notizia)</dt>
              <dd>
              Scheda dove sono contenuti gli elementi identificativi di un materiale inserito nel catalogo (un libro, un periodico, musica a stampa,
              carte geografiche, ecc.).
              </dd>
          <dt>Filtro</dt>

              <dd>
              Elemento che, una volta impostato, limita la ricerca nel data-base all'interno di un ambito predefinito (lingua, anno di pubblicazione, paese ecc).
          <dt>Notizia (o documento)</dt>
          <dt>Numero CDD</dt>
              <dd>
              Codice numerico che indica la classe Dewey (vedi la voce "Classe Dewey").
              Vedi il <a href="#navigatoredewey" title="Vai al capitolo 'Navigatore Dewey'">capitolo relativo</a>.</dd>

          <dt>Parola chiave CDD</dt>
              <dd>Termine o termini di decodifica del numero CDD (classe Dewey - vedi la voce "Classe Dewey").
              Vedi il <a href="#navigatoredewey" title="Vai al capitolo 'Navigatore Dewey'">capitolo relativo</a>.</dd>
          </dl>

      <br>
      <a href="#inizio" title="Torna all'inizio della pagina" class="torna"><img src="<%=contextPath %>/img/folderopen_up.gif" alt="Torna all'inizio della pagina">Torna all'inizio</a>
  </div>


  <br /><br /><br /><br /><br />

  </div><!--#main-->

</body>
</html>
