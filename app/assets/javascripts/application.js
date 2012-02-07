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
//= require_tree ./search

var auth_callback;

function show_auth_dialog(callback) {
    $('.b-head__login_form').dialog({
        width: 500,
        height: 325,
        modal: true,
        resizable: false,
        draggable: false,
        closeOnOverlayClick: true
    });

    auth_callback = callback;
}

$(function()
{
	$('input[class!=b-form-custom-false],button[class!=b-form-custom-false]').customInput();
	$(".toolbar").buttonset();   
	$('.b-head__login').click(function() {
        show_auth_dialog();
	});     

	
	// auth
	$("#login_form")
		.bind("ajax:error", function(e){      
			$('.b-head__login_form').parent().effect('bounce', { direction: 'left', times: 3}, 200 );
		})
		.bind("ajax:success", function(evt, data, status, xhr){
			if(auth_callback) {
                //change_header_to_auth();
                log('auth_callback');
                logged_in = true;
                auth_callback();
                $('.b-head__login_form').dialog('close');
            } else {
                document.location = data.redirect;
            }
			
	});

	$(".b-auth__button").each(function(){   
		var button = $(this),     
			provider = button.attr('provider'),
			icon = provider != "" ? "ui-icon-" + provider : ""; 
		
		$(this).button({
	        icons: {
	            primary: icon
	        }
	    }).click(function(){
	    	var list = $('.b-auth__list'),
	    		button = $(this),
	    		top = button.position().top + button.outerHeight() - 1,
	    		left = button.position().left + 1,
	    		width = button.outerWidth() - 2;

	    	list.css('top', top).css('left', left).css('width', width).toggle();
	    }); 
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
