$(function(){     
   function animate_i_can_help_window(height) {
		var window = $('.b-missing__i_can_help_window');
		
		window.parent().animate({
			top: window.offset().top - height/2
		});                    
		
	   
   }
                        
   $(".b-missing__photo_link").fancybox();

   $('.b-missing__i_saw').click(function(){
   	   $(this).hide();
	   $(this).parent().append(
		$('<div class="b-missing__i_saw_in"/>').append(
			$('<label for="i_saw_in" class="l-block"/>').html('Я видел в <span class="b-missing__i_saw_in_place">Москве</span>')
	    ) .append(
		    $('<a href="#" class="b-missing__i_saw_in_change b-pseudo_link"/>').text('Уточнить')
		).append(
		    $('<input id="i_saw_in" class="b-missing__i_saw_in"/>').val('Москве').hide()
		)
	   );
	});                                             
	
	$('#new_message')
		.bind('ajax:beforeSend', function(e){
			
		})
		.bind('ajax:success', function(evt, data, status, xhr){    
			if( data.ok )
			{                 
				$('.b-missing__send_message textarea').val("");
				$('.b-missing__send_message_status').text('Ваше сообщение отправлено').show();   
				$('.b-missing__send_message').hide();
			} else {
				$('.b-missing__send_message_status').text('Не удалось отправить сообщение, это наша проблема, попробуйте позже');
			}       
		});                            
		                                  
	$('.b-missing__toggle_send_message').live('click', function(){ 
		$(this).hide();     
		$('.b-missing__send_message').show();    
		$('.b-missing__send_message_status').hide();
		
	});
	
	$('.b-missing__i_can_help').click(function(){
		$('.b-missing__i_can_help_window').dialog({
			width: 740,

			modal: true,
			resizable: false,
			draggable: false,
			closeOnOverlayClick: true,
			buttons: {
				'save': {
					text: 'Сохранить',
					click: function(){}
				},
				'close': {
					text: 'Закрыть',
					click: function(){}
				}
			}
		})
		.parent().addClass('b-missing__i_can_help_dialog');
	});     
	
	$('#i_can_help__information').live('change', function(){ 
		var checked = $('#i_can_help__information:checked').val() !== undefined,
			$div = $('.b-missing__i_can_help_window_information'),
			height = checked ? 360 : -360;   
		if(checked)	{
			$div.appendTo('.b-missing__i_can_help_window_blocks').effect('blind', { mode: 'show' });      
		} else {
			$div.effect('blind', { mode: 'hide' });                   
		}                                                             
		$('.b-missing__i_can_help_window_blocks div:visible:first .b-hr').remove();  
		
		animate_i_can_help_window(height);
		
	});                     
	
	$('#i_can_help__search').live('change', function(){             
		var checked = $("#i_can_help__search:checked").val() !== undefined,
			$div = $('.b-missing__i_can_help_window_search'),
			height = checked ? 200 : -200;   
		if(checked)	{
			$div.appendTo('.b-missing__i_can_help_window_blocks').effect('blind', { mode: 'show' }).prepend('<div class="b-hr"></div>');

		} else {
			$div.effect('blind', { mode: 'hide' });

		}
		
        $('.b-missing__i_can_help_window_blocks div:visible:first .b-hr').remove();           

animate_i_can_help_window(height);
	});
});