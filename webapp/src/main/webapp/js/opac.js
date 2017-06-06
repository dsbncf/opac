
// carica arsbni dalla visualizzaizione della notizia //

function loadArsbni( id )
{
  //var url = "http://opac.bncf.firenze.sbn.it/mdigit/jsp/mdigit.jsp?idr=" + id;
  var url = "http://192.168.7.34/ImageViewer/servlet/ImageViewer?idr=" + id;

  var w = window.open(url,"_ARSBNI","location=no,menubar=no,resizable,scrollbars,status=no,toolbar=no");
  w.focus();
}

