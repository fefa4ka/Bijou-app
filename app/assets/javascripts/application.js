//= require jquery
//= require jquery_ujs             
//= require_self
//= require_tree .
//= require gmaps4rails/bing.js
//= require gmaps4rails/googlemaps.js
//= require gmaps4rails/mapquest.js
//= require gmaps4rails/openlayers.js
//= require gmaps4rails/all_apis.js

$(function()
{
	$('input').customInput();
	$('.b-head__login').click(function()
	{
		$('.b-head__login_form').dialog({
			width: 350,
			height: 246,
			modal: true,
			resizable: false,
			draggable: false,
			closeOnOverlayClick: true
		})
	})
})

function pluralForm(n, form1, form2, form5)
{
    n = Math.abs(n) % 100;
    n1 = n % 10;
    if (n > 10 && n < 20) return form5;
    else if (n1 > 1 && n1 < 5) return form2;
    else if (n1 == 1) return form1;

	return form5;
}