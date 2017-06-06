/* Crea un parametro timestamp da accodare ad una url */
/* Utilizzato per ogni richiesta ajax e/o altre url (anche src di immagini) per evitare caching da parte dei browsers */
function urlTimestamp()
{
  var d = new Date();
  return 'ts=' + encodeURIComponent(d.getTime());
}

/* Aggiunge un BID nel carrello, utilizzato nella analitica */
function addBidToCart(bbid, btitolo, bautore, banno)
{
  if ( bbid == null )
    return;

  $.ajax({
    type: 'GET',
    url: globalContextPath + '/addbidtocart',
    data: 'bid=' + bbid + '&titolo=' + encodeURIComponent(btitolo) + '&autore=' + encodeURIComponent(bautore) + '&anno=' + encodeURIComponent(banno) + '&' + urlTimestamp(),
    success: function(msg) {
      if ( msg == bbid )
      {
        $('#add-' + bbid + '-to-cart').hide();
        $('#remove-' + bbid + '-to-cart').show();
        $('#msg-' + bbid + '-cart').css('color', 'green');
        $('#msg-' + bbid + '-cart').html(cartAddSuccessMsg);
      }
      else if ( msg == "error" )
      {
        $('#msg-' + bbid + '-cart').css('color', 'red');
        $('#msg-' + bbid + '-cart').html(cartErrorMsg);
      }
      else
      {
        $('#msg-' + bbid + '-cart').css('color', 'red');
        $('#msg-' + bbid + '-cart').html(cartErrorMsg);
      }
    }
  });
}

/* Rimuove un un BID dal carrello, utilizzato nella analitica e nel carrello */
function removeBidFromCart(bbid)
{
  if ( bbid == null )
    return;

  $.ajax({
    type: 'GET',
    url: globalContextPath + '/removebidfromcart',
    data: 'bid=' + bbid + '&' + urlTimestamp(),
    success: function(msg) {
      if ( msg == bbid )
      {
        $('#remove-' + bbid + '-to-cart').hide();
        $('#add-' + bbid + '-to-cart').show();
        $('#msg-' + bbid + '-cart').css('color', 'green');
        $('#msg-' + bbid + '-cart').html(cartRemSuccessMsg);
      }
      else if ( msg == "error" )
      {
        $('#msg-' + bbid + '-cart').css('color', 'red');
        $('#msg-' + bbid + '-cart').html(cartErrorMsg);
      }
      else
      {
        $('#msg-' + bbid + '-cart').css('color', 'red');
        $('#msg-' + bbid + '-cart').html(cartErrorMsg);
      }
    }
  });
}

function OpenClose(hideThis)
{
	if(document.getElementById(hideThis).style.display == '')
  {
		document.getElementById(hideThis).style.display = 'none';
    document.getElementById(hideThis + '_img').src='img/expand.gif';
	}
  else
  {
		document.getElementById(hideThis).style.display = '';
    document.getElementById(hideThis + '_img').src='img/collapse.gif';
  }
}


