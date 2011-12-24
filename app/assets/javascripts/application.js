//= require jquery
//= require jquery_ujs             
//= require_self          
//= require_tree ./main
//= require_tree ./plugins 
//= require_tree ./fancybox    
//= require_tree ./missing
//= require_tree ./report
//= require_tree ./user              
//= require_tree ./questions


$(function()
{
	$('input[class!=b-form-custom-false],button[class!=b-form-custom-false]').customInput();
	$(".toolbar").buttonset();   
	$('.b-head__login').click(function()
	{
		$('.b-head__login_form').dialog({
			width: 500,
			height: 325,
			modal: true,
			resizable: false,
			draggable: false,
			closeOnOverlayClick: true
		});
	});     
	
	// auth
	$("#login_form")
		.bind("ajax:error", function(e){      
			$('.b-head__login_form').parent().effect('bounce', { direction: 'left', times: 3}, 200 );
		})
		.bind("ajax:success", function(evt, data, status, xhr){
			document.location = data.redirect;
			
	});

});

function pluralForm(n, form1, form2, form5)
{
    n = Math.abs(n) % 100;
    n1 = n % 10;
    if (n > 10 && n < 20) return form5;
    else if (n1 > 1 && n1 < 5) return form2;
    else if (n1 == 1) return form1;

	return form5;
}
