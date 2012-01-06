$(function(){        
	var last_image = 0;            
	
	if( $(".p-main").length == 0 ) return;

	$('.p-main-suggest-info[type=volunteer]').hide();
	
	$('.p-main-info div').mouseenter(function(){ 
		var div = $(this),                        
			type = div.attr('type'),
			suggest = $('.p-main-suggest-info[type=' + type + ']'),
		   	pointer = $('.p-main-img-pointer'), 
			left = div.offset().left + div.width()/2 - pointer.width()*1.5; 
		                                                      
		if(type == undefined) {
			return;
		}          
		
		log('enter', '.p-main-suggest-info[type=' + type + ']', suggest); 
		
		pointer.animate({'left': left}, 500); 
		$('.p-main-suggest-info[type!=' + type + ']').fadeOut(300);          
		suggest.fadeIn(500);                     
		
	});
	
	$('.p-main-suggest-images img').mouseover(function(){ 
		var img = $(this), 
			popup =	$('.p-main-suggest-popup'),      
			popupImage = $('.p-main-suggest-popup img'),
			popupName = $('.p-main-suggest-popup a'),  
			popupDate = $('.p-main-suggest-popup p'),
			src = img.attr('src'),
			name = img.attr('data-name'), 
			url = img.attr('data-url'),
			date = img.attr('data-date'),       
			box = img.parent(), 
			boxTop = box.offset().top, 
			boxLeft = box.offset().left, 
			top = img.offset().top - boxTop + img.height() * 1.2, 
			left = img.offset().left - boxLeft; 
		if(last_image == url) return;
			                              
		popup.css('top', top).css('left', left);    
	    popupImage.attr('src', src);
		popupName.html('<a href="' + url + '">' + name + '</a>');
		popupDate.text('' + date);       
		
		last_image = url;
	});               
	
	
	$('.p-main-register').click(function() { 
		var role = $(this).attr('for');
		$(this).parent().hide();
		$('.p-main-register-box.' + role).show() 
	});

  	$(".b-button_social").each(function(){   
		var button = $(this),
			icon = "ui-icon-" + button.attr('provider');
			
		$(this).button({
	        icons: {
	            primary: icon
	        }
	    }).click(function(){
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
	});
});
