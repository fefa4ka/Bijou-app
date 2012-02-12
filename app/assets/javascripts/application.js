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
	$('.b-head__registration_dialog').dialog('close');
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
           
function show_registration_dialog(callback) {    
	
    $('.b-head__login_form').dialog('close');
	$('.b-head__registration_dialog').dialog({
        width: 880,
        height: 140,
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
	
	$(".b-auth__action").click(function(){
        var popup,
            url = $(this).attr('url'),
            width = $(this).attr('data-width'),
            height = $(this).attr('data-height');

        function open_popup(url, width, height) {
            var screenX = typeof window.screenX != 'undefined' ? window.screenX : window.sceenLeft,
                screenY = typeof window.screenY != 'undefined' ? window.screenY : window.screenTop,
                outerWidth   = typeof window.outerWidth != 'undefined' ? window.outerWidth : document.body.clientWidth,
                outerHeight  = typeof window.outerHeight != 'undefined' ? window.outerHeight : (document.body.clientHeight - 22),
                left    = parseInt(screenX + ((outerWidth - width) / 2), 10),
                top     = parseInt(screenY + ((outerHeight - height) / 2.5), 10),
                params  = ('width=' + width + ',height=' + height + ',left=' + left + ',top=' + top);

            popup = window.open(url, 'Login', params);

            if(window.focus) {
                popup.focus();
            }

            return false
        }
        
        open_popup(url, width, height);
    });                    

	$(".new_user").each(function(){
		$(this).validate({ 
			rules: { 
				"user[email]": { required: true, email: true } 
			} 
		}); 
	});   
	        
	$(".new_user input[type=text]").keyup(function () {                     
		var parent = $(this).parent().parent().parent(),
			submit = parent.find('input[type=submit]');                
			
		submit.val() == "Войти" && $('.error.allready').hide() && submit.val('Продолжить').unbind('click')
	});     
	
	$(".new_user")
		.bind("ajax:error", function(e){ 
			var email = $(this).find('input[type=text]').val(),
				error = $(this).find('.error.allready');
				                                        
			error.text('Такой адрес зарегистрирован.').show();
			
			$(this).find('input[type=submit]').val('Войти').click(function (e) {   
				e.preventDefault();        
				$("#login_form [name='user[email]']").val(email);
				show_auth_dialog();
			})
		})
		.bind("ajax:success", function(evt, data, status, xhr){
		   document.location = "/missings/"
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
