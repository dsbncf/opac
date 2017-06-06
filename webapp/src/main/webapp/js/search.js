// <!--

/* globalClosedBoxes e globalContextPath sono variabili globali passate prima di questo script */
/* dipendenze: library.js */

$(function(){
  $.each( $('.js-title-facets'), function () {
    if ( this.id != null )
    {
      var facetsName = this.id.replace('title-','');

      if ( $('#container-'+facetsName) )
      {
        var img = '';
        if ( globalClosedBoxes.indexOf('['+facetsName+']') > -1 )
        {
          img = '/img/expand.gif';
          $('#container-'+facetsName).hide();
        }
        else
        {
          img = '/img/collapse.gif';
          $('#container-'+facetsName).show();
        }

        var mHTML = '<a href="javascript://" title="' + globalApriChiudiLabel + '" class="expand-collapse" id="expand-collapse-'+facetsName+'">';
        mHTML = mHTML + '<img alt="' + globalApriChiudiLabel + '" src="'+ globalContextPath + img+'" style="padding: 3px; padding-bottom: 0px;" />';
        mHTML = mHTML + '</a>';
        $('#'+this.id).prepend(mHTML);

        $('#expand-collapse-'+facetsName).click(function(){
          var parmName = 'collapse';
          if ( $('#container-'+facetsName).is(':hidden') )
            parmName = 'expand';
          $.ajax({ type: 'GET', url: globalContextPath + '/options', data: parmName + '=' + facetsName + '&' + urlTimestamp,
          success: function(ResponseText){ if (ResponseText == 'ok') { showHideFacet('container-'+facetsName, 'expand-collapse-'+facetsName) } }
          });
          return false;
        });
      }
    }
  });

  //Elimina valori non numerici da campi indicati con la classe checknumeric
  $('.checknumeric').keyup(
     function(event) {
         $(this).val( $(this).val().replace(/[^0-9]/g, '') ); 
     });

});

function showHideFacet(containerId, mId)
{
  if ( $('#'+containerId).is(':hidden') )
  {
    $('#'+mId+' img').attr('src', globalContextPath + '/img/collapse.gif');
    $('#'+containerId).show();
  }
  else
  {
    $('#'+mId+' img').attr('src', globalContextPath + '/img/expand.gif');
    $('#'+containerId).hide();
  }
}

function openDetail( lnk, linkId )
{
  if ( lnk == null || lnk == '' || isNaN(linkId) )
    return;

  if ( lnk.indexOf('?') == -1 )
    lnk = lnk + '?';
  else
    lnk = lnk + '&';

  var numRows = 0;

  if ( $('a.viewbid') )
    numRows = $('a.viewbid').length;

  var rStart = 0;
  if ( $('span#startrow') )
    rStart = $('span#startrow').text();
  var rEnd = 0;
  if ( $('span#endrow') )
    rEnd = $('span#endrow').text();
  var rTot = 0;
  if ( $('span#maxrows') )
    rTot = $('span#maxrows').text();

  var bid = 0;
  if ( $('a#n' + linkId) )
    bid = $('a#n' + linkId).attr('name');  

  lnk = lnk + 'bid=' + bid + '&fb=true&linkid=' + linkId + '&numrows=' + numRows + '&rstart=' + rStart + '&rend=' + rEnd + '&rtot=' + rTot;

  if ($('div#facebox').is(':visible'))
    $('div#facebox div.content').load(lnk);
  else
    $.facebox({ajax: lnk});
}

function openDetailByLinkId( linkId )
{
  if ( ! $('#n' + linkId) )
    return;
  var lnk = $('#n' + linkId).attr('href');
  openDetail(lnk, linkId); 
}

function gotoPage(step, linkid)
{
  if ( ! $('#' + step + '-page') )
    return;

  var lnk = $('#' + step + '-page').attr('href');

  if ( lnk.indexOf('?') == -1 )
    lnk = lnk + '?';
  else
    lnk = lnk + '&';

  document.location = lnk + 'opendetail=' + linkid;
}

function gotoNextPage()
{
  gotoPage('next', 1);
}

function gotoPrevPage()
{
  var numRows = 0;
  if ( $('a.viewbid') )
    numRows = $('a.viewbid').length;

  gotoPage('previous', numRows);
}

function addBidToCart(bbid, btitolo, bautore, banno)
{
  if ( bbid == null )
    return;

  $.ajax({
    type: 'GET',
    url: globalContextPath + '/addbidtocart',
    data: 'bid=' + bbid + '&titolo=' + encodeURIComponent(btitolo) + '&autore=' + encodeURIComponent(bautore) + '&anno=' + encodeURIComponent(banno),
    success: function(msg) {
      if ( msg == bbid )
      {
        $('#add-' + bbid + '-to-cart').hide();
        $('#remove-' + bbid + '-to-cart').show();
        $('#msg-' + bbid + '-cart').css('color', 'green');
        $('#msg-' + bbid + '-cart').html('Documento aggiunto ai preferiti.');
      }
      else if ( msg == "error" )
      {
        $('#msg-' + bbid + '-cart').css('color', 'red');
        $('#msg-' + bbid + '-cart').html('Errore, ritenta in un secondo momento.');
      }
      else
      {
        $('#msg-' + bbid + '-cart').css('color', 'red');
        $('#msg-' + bbid + '-cart').html('Errore, ritenta in un secondo momento.');
      }
    }
  });
}

function removeBidFromCart(bbid)
{
  if ( bbid == null )
    return;

  $.ajax({
    type: 'GET',
    url: globalContextPath + '/removebidfromcart',
    data: 'bid=' + bbid,
    success: function(msg) {
      if ( msg == bbid )
      {
        $('#remove-' + bbid + '-to-cart').hide();
        $('#add-' + bbid + '-to-cart').show();
        $('#msg-' + bbid + '-cart').css('color', 'green');
        $('#msg-' + bbid + '-cart').html('Documento rimosso dai preferiti.');
      }
      else if ( msg == "error" )
      {
        $('#msg-' + bbid + '-cart').css('color', 'red');
        $('#msg-' + bbid + '-cart').html('Errore, ritenta in un secondo momento.');
      }
      else
      {
        $('#msg-' + bbid + '-cart').css('color', 'red');
        $('#msg-' + bbid + '-cart').html('Errore, ritenta in un secondo momento.');
      }
    }
  });
}

/* Funzioni obsolete per il trattamento della query string
function arrRequest(querystring)
{
  if ( querystring == null )
    querystring = location.search;

  querystring = querystring.replace ( '\?', '' );
  return querystring.split('&');
}

function removeVariable(varName,querystring)
{
  var arr1 = arrRequest(querystring);
  if ( arr1 == null )
    return '';

  var rExp = new RegExp('^' + varName + '=(.)*$');
  for ( var i = 0; i < arr1.length; i++ )
    if ( rExp.test(arr1[i]) )
      arr1.splice(i,1);

  var qs = '';

  for ( var i = 0; i < arr1.length; i++ )
  {
    if ( i != 0 )
      qs = qs + '&';
    qs = qs + arr1[i];
  }

  return qs;
}

function makeQuerystring(arrQs)
{
  if ( arrQs == null || arrQs.length == 0 )
    return '';

  var qs = '';

  for ( var i = 0; i < arrQs.length; i++ )
  {
    if ( i != 0 )
      qs = qs + '&';
    qs = qs + arrQs[i];
  }

  return qs;
}

function request(varName)
{
  var rExp = "^" + varName + "=(.)*$";
  var tmp2 = arrRequest();

  if ( tmp2 == null )
    return null;

  for ( var i = 0; i < tmp2.length; i++ )
    if ( tmp2[i].search(rExp) > -1 )
      return tmp2[i].replace(varName + "=", "");

  return null;
}
*/
// -->
