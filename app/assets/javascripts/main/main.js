$(function(){        
	var last_image = 0;
	
	$('.p-main-suggest-images img').mouseover(function(){ 
		var img = $(this), 
			popup =	$('.p-main-suggest-popup'),      
			popupImage = $('.p-main-suggest-popup img'),
			popupName = $('.p-main-suggest-popup a'),  
			popupDate = $('.p-main-suggest-popup p'),
			src = img.attr('src'),
			name = img.attr('data-name'),
			date = img.attr('data-date'),       
			box = img.parent(), 
			boxTop = box.offset().top, 
			boxLeft = box.offset().left, 
			top = img.offset().top - boxTop + img.height() * 1.2, 
			left = img.offset().left - boxLeft; 
		if(last_image == src) return;
			                              
		popup.css('top', top).css('left', left);    
	    popupImage.attr('src', src);
		popupName.text(name);
		popupDate.text('' + date);       
		
		last_image = src;
	});       
	
	$('.p-main-register').click(function() { 
		var role = $(this).attr('for');
		$(this).parent().hide();
		log('.p-main-register-box.' + role);
		$('.p-main-register-box.' + role).show() 
	});
	
  	$(".b-button_social").each(function(){   
		var button = $(this),
			icon = "ui-icon-" + button.attr('provider');
			
		$(this).button({
	        icons: {
	            primary: icon
	        }
	    });    
	});
});