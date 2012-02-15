$(function(){        
	var last_image = 0,
        animate_missing_block;            
	
    function show_missing(image) {
		var img = image, 
			popup =	$('.p-main-suggest-popup'),      
            popupImage = $('.p-main-suggest-popup .photo'),
            popupLink = $('.p-main-suggest-popup .link'),
			popupName = $('.p-main-suggest-popup .name'),  
			popupDate = $('.p-main-suggest-popup p'),
			src = img.attr('src'),
			name = img.attr('data-name'), 
			url = img.attr('data-url'),
			date = img.attr('data-date'),     
            random = img.attr('data-random'),
			box = img.parent(), 
			boxTop = box.offset().top, 
			boxLeft = box.offset().left, 
			top = img.offset().top - boxTop + img.height() - 5, 
			left = img.offset().left - boxLeft - 5; 

		if(last_image == random) return;
			                              
		popup.css('top', top).css('left', left);    
	    popupImage.attr('src', src);
        popupLink.each(function() {
            $(this).attr('href', url);
        });
		popupName.text(name);
		popupDate.text('' + date);       
		popup.show();

		last_image = random;
    }   

    function show_random_missing() {
        var random = Math.floor( Math.random() * (45-1+1) + 1 ),
            image = $('.p-main-suggest-images img:nth-child(' + random + ')');
        
        show_missing( image );
    }

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
		
		
		pointer.animate({'left': left}, 500); 
		$('.p-main-suggest-info[type!=' + type + ']').fadeOut(300);          
		suggest.fadeIn(500);                     
		
        if( $(this).attr('animate_missing') && !animate_missing_block ) {
            show_random_missing();
            animate_missing_block = setInterval( show_random_missing, 2500 );

        } else {
            clearInterval( animate_missing_block );
            animate_missing_block = false;
        }

	});
	
	$('.p-main-suggest-images img').mouseover(function(){
        clearInterval( animate_missing_block );
        show_missing($(this));
	});               
	
	
	
});
