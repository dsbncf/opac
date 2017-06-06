<%@page language="java" pageEncoding="UTF-8" contentType="text/html;charset=UTF-8"
	import="bncf.opac.util.DeweyInfo,bncf.opac.util.DeweyItem,bncf.opac.util.DeweyTree,java.util.ArrayList" %>
<%@ include file="inc/setup.jsp" %>
<%
   int maxListItems = 20;
   String deweybrowserlink = contextPath + "/deweybrowser/";
   DeweyInfo[] deweyInfo = new DeweyInfo[3];
   DeweyInfo[] deweyInfoArr = null;
   String thlabel = null;
   String codedots = "";
   String title = lang.translate("navigatore_dewey");
   String hint  = lang.translate("selezionare_una_desc_per");

   DeweyTree deweyTree = (DeweyTree) application.getAttribute("deweyTree");

   String cod = (String)request.getAttribute("cod");
   if (cod == null)
       cod = request.getParameter("cod");

   int lunghezza = (cod == null) ? 0 :  cod.length();
   switch (lunghezza)
   {
       case 0:
               deweyInfoArr = deweyTree.getDeweyInfoList();
               thlabel = lang.translate("classe");
               codedots = "..";
               break;
       case 1:
               deweyInfo[0] = deweyTree.getDeweyInfo(cod);
               if (deweyInfo[0] != null) title = deweyInfo[0].getDescr();
               deweyInfoArr = deweyTree.getDeweyInfoList(cod);
               codedots = ".";
               thlabel = lang.translate("divisione");
               break;
       case 2:
               deweyInfo[0] = deweyTree.getDeweyInfo(cod.substring(0,1));
               deweyInfo[1] = deweyTree.getDeweyInfo(cod);
               if (deweyInfo[1] != null) title = deweyInfo[1].getDescr();
               deweyInfoArr = deweyTree.getDeweyInfoList(cod);
               thlabel = lang.translate("sezione");
               break;
       case 3:
               hint = lang.translate("cliccare_sulla_desc") + " " + lang.translate("o_sul_num");
               deweyInfo[0] = deweyTree.getDeweyInfo(cod.substring(0,1));
               deweyInfo[1] = deweyTree.getDeweyInfo(cod.substring(0,2));
               deweyInfo[2] = deweyTree.getDeweyInfo(cod);
               if (deweyInfo[2] != null) title = deweyInfo[2].getDescr();
               break;
   }
%>
<html>
<head>
  <title><%=title%></title>
  <meta http-equiv="Content-Type" content="text/html;charset=UTF-8">
  <link rel="stylesheet" href="<%=contextPath%>/css/base.css" type="text/css" media="screen"/>
  <link rel="stylesheet" href="<%=contextPath%>/css/dewey.css" type="text/css" media="screen"/>
  <link rel="stylesheet" href="<%=contextPath%>/css/search.css" type="text/css" media="screen"/>
  <script language="javascript" src="<%=contextPath%>/js/library.js" type="text/javascript"></script>
</head>
<body OnLoad="placeFocus()" onUnload="hideWait();">
<%@ include file="inc/testa.jsp"%>
<%@ include file="inc/topmenu.jsp" %>
<div id="main">
<%@ include file="inc/menu.jsp" %>
<div class="boxed"/>


<div id="deweynav">
<table width="100%" align="center" cellpadding="1" cellspacing="1" bgcolor="#B8CDD8">
 <!-- titolo pagina con suggerimento -->
 <tr> 
  <td height="20" nowrap colspan="2">
    <font size="2" face="Verdana, Arial, Helvetica, sans-serif">
      <strong><%=lang.translate("Navigatore_Dewey")%></strong>: <%=hint%>
    </font>
  </td>
 </tr>

<!-- tree del percorso delle classi principali (prime 3 cifre) -->
<% if (cod != null) { %>
 <tr>
  <td bgcolor="#FFFFFF" colspan="2" style="padding:4px;">
    
      <!-- inserisce il link alla root dopo aver scelto un codice -->
      <font size="2" face="Verdana, Arial, Helvetica, sans-serif">
        <a href="<%=contextPath%>/deweybrowser/"
           title="<%=lang.translate("esplora_le_classi")%>"><%=lang.translate("classi_princ") %></a>
      <br>
<%
   String[] treelabels = { "classe", "divisione", "sezione" };
   String[] leftmargin = { "0em", "1.8em", "3.6em" };
   int max = 2;
   for (int k = 0 ; k < 3 ; k++)
   {
      if (deweyInfo[k] != null)
      {
          DeweyInfo dwy = deweyInfo[k];
          String link = deweybrowserlink +  dwy.getCod();
          boolean linkActive = ((k < max) && (deweyInfo[k+1] != null));
%>
      <span style="margin-left: <%=leftmargin[k]%>; margin-top: 0.2em; display: block;">
       <img src="../img/L.gif" hspace="2" alt="<%=lang.translate("icona")%>" style="vertical-align:middle">
	<%=lang.translate(treelabels[k])%>:&nbsp;<span style="text-transform:uppercase">

<% if(linkActive){%><a href="<%=link%>" title="<%=lang.translate("esplora_la_classe")%>"><%=dwy.getDescr()%></a>
<%}else{%><span style="font-weight:bold"><%=dwy.getDescr()%></span><%}%>

</span>&nbsp;&nbsp;
<span style="font-size: 0.8em">(<%=dwy.getCount()%>&nbsp;<%=lang.translate("notizie_coll")%>)</span></span>
<%    } %>
<% } %>
  </td>
 </tr>
<% } // tree del percorso  %>
</table>


<!-- visualizzazione delle max 10 classi per codice selezionato -->
<% if (deweyInfoArr != null)
   {
%>
<table class="list" summary="<%=lang.translate("risultati_dewey")%>">
 <tr> 
      <th><%=thlabel %></th>
      <th style="text-align:left"><%=lang.translate("descrizione") %></th>
      <th><%=lang.translate("notizie") %></th>
 </tr>

<%   for (DeweyInfo dwy: deweyInfoArr)
     {
        int    count = dwy.getCount();
        String code  = dwy.getCod();
        String link  = deweybrowserlink + code;
        String descr = dwy.getDescr();
%>
 <tr class="" onmouseover="this.className='highlited'" onmouseout="this.className=''"> 
  <td align="center"><%=code%><%=codedots%></td>
  <td align="left" width="98%">    
    <a onClick="showWait(1)" href="<%=link%>" title="<%=lang.translate("esplora_la_sez") %>"><%=descr%></a>
  </td>
  <td align="right"><%=count%></td>
 </tr>
<%--  in alternativa alla table-row precedente:
         attiva il link sul totale notizie collegate, escluso per codice di lunghezza 3
         if (deweyInfo3 != null)
         {
            String link2 = "controller?action=search_bydeweysearch&amp;query_fieldname_1=coddewey&amp;query_querystring_1=" + code + "*";
%>
    <a onClick="showWait(1)" href="<%=link2%>" title="<%=lang.translate("esplora_le_not")%>"><%=count%></a>
<%       } else { %>
           <%=count%>
<%       } --%>

<%   } //for %>
</table>
<% } //if %>



<% // lista delle classi per codici con lunghezza min = 3
  boolean hasMoreItems = false;
  ArrayList<DeweyItem> items = (ArrayList<DeweyItem>)request.getAttribute("deweyItems");
  if (items != null)
  {
     hasMoreItems = items.size() > maxListItems;
%>

<!-- testa della lista -->
<table class="list" summary="<%=lang.translate("lista_delle_classi")%>">
 <tr> 
    <th style="text-align:left">CDD</th>
    <th style="text-align:left"><%=lang.translate("descrizione")%></th>
    <th>Notizie</th>
 </tr>

<%
     int k = 0;
     for (DeweyItem dwy: items)
     {
        String code  = dwy.getCod();
        String descr = dwy.getName();
        int    count = dwy.getCount();

        String fcsearch_dewey    = contextPath + "/fcsearch?dewey_fc=&quot;" + descr + "&quot;";
        String fcsearch_deweycod = contextPath + "/fcsearch?deweycod_fc=" + code;

        if (k++ < maxListItems)
        {
%>
  <!-- iterazione della lista -->
  <tr class="" onmouseover="this.className='highlited'" onmouseout="this.className=''"> 
    <td align="left"><a href="<%=fcsearch_deweycod%>" title="<%=lang.translate("esplora_la_classe")%>"><%=code%></a></td>
    <td align="left" width="98%">
      <a onclick="showWait(1)" href="<%=fcsearch_dewey%>" title="<%=lang.translate("esplora_la_classe")%>"><%=descr%></a></td>
    <td align="right"><%=count%></td>
  </tr>
<%      }//maxListItems %>
<%   }//for %>

<!-- piede della lista -->
</table>
<br/>

<% //output dei bottoni "precedenti" "successivi"
    int start = 0;
    try{ start = Integer.parseInt(request.getParameter("start")); }catch(Exception e){}
    int next = start + maxListItems;
    int prev = start - maxListItems;
    if (prev < 0) prev = 0;
    String btnPrevStyle = (start > 1)  ? "style=\"color:#26b;\"" : "";
    String btnNextStyle = hasMoreItems ? "style=\"color:#26b;\"" : "";
    String btnPrevDisabled = (start<1) ? "disabled" : "";
    String btnNextDisabled = hasMoreItems ? "" : "disabled";
    String imgPrevStyle    = (start<1) ? "class=\"disabled\"" : "";
    String imgNextStyle    = hasMoreItems ? "" : "class=\"disabled\"";

    if ((start >= 1) || hasMoreItems)
    {
%>

<form action="<%=contextPath%>/deweybrowser/<%=cod%>"
style="margin-bottom:0px;line-height: 1.3em;" class="list-form">
&nbsp;&nbsp;
 <button type="submit" name="start" value="<%=prev%>" <%=btnPrevStyle%> <%=btnPrevDisabled%> title="<%=lang.translate("precedenti") %>">
 <img <%=imgPrevStyle%> alt="<%=lang.translate("precedenti") %>"	src="<%=contextPath %>/img/prev-blue.gif"/>&nbsp;<%=lang.translate("precedenti") %>
 </button>
 &nbsp;&nbsp;&nbsp;
 <button type="submit" name="start" value="<%=next%>" <%=btnNextStyle%> <%=btnNextDisabled%> title="<%=lang.translate("successivi") %>">
 <%=lang.translate("successivi") %>&nbsp;<img <%=imgNextStyle%> alt="<%=lang.translate("successivi") %>"	src="<%=contextPath %>/img/next-blue.gif" />
 </button>
</form>
<%   }//disabled buttons %>

<% }//items %>

</div><!--#main-->

<%@ include file="inc/footer.jsp" %>

</body>
</html>
