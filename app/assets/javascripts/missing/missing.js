$(function(){     
   function animate_i_can_help_window(height) {
		var window = $('.b-missing__i_can_help_window');
		
		window.parent().animate({
			top: window.offset().top - height/2
		});                    
		
	   
   }
   
   // Фотографии загружаем в оверлеи 
   $(".b-missing__photo_link").fancybox();
    
   // Реакция на кнопку «Я видел этого человека»
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
	        
	// Реакции на отправку личного сообщения
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
	
	// При нажатии на кнопку отправить сообщение раскрывается форма и убирается кнопка	                                  
	$('.b-missing__toggle_send_message').live('click', function(){ 
		$(this).hide();     
		$('.b-missing__send_message').show();    
		$('.b-missing__send_message_status').hide();
		
	});
	                     
	
	// Оверлей «Я могу помочь»
	$('.b-missing__i_can_help').click(function(){
		var dialog = $('.b-missing__i_can_help_window').dialog({
				width: 740,

				modal: true,
				resizable: false,
				draggable: false,
				closeOnOverlayClick: true,
				buttons: {
					'save': {
						text: 'Сохранить',
						click: function(){
							$(".new_can_help, .edit_can_help").submit();
						}
					},
					'close': {
						text: 'Закрыть',
						click: function(){
							$(this).dialog('close');
						}
					}
				}
			})
			.parent().addClass('b-missing__i_can_help_dialog'),
			buttons = dialog.find('.ui-dialog-buttonset button'),
			button_save = buttons[0],
			button_cancel = buttons[1];
			
		$(button_save).addClass('t-medium');
		$(button_cancel).addClass('silver_action');         
		
		// TODO: Плавающие чекбоксы
		// 		$(window).scroll(function () {                 
		// 			var dialog = $('.b-missing__i_can_help_dialog'),
		// 				dialogTop = dialog.offset().top,
		// 				dialogHeight = dialog.height() - dialog.find('.ui-dialog-buttonpane').height(),
		// 				top = $(this).scrollTop();
		// 			log(top, dialogTop+dialogHeight);	               	               
		// 			if(top + 20 < dialogTop + dialogHeight ) {  
		// 				log('change ul top to ', top - dialogTop);
		// 				$('.b-missing__i_can_help_variants').css('top', top - dialogTop);
		// 			}	
		// 		});                     
		
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