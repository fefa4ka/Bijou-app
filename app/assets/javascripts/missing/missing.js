$(function(){           
   $('.b-missing__i_saw').click(function(){
   	   $(this).hide();
	   $(this).parent().append(
		$('<div class="b-missing__i_saw_in"/>').append(
			$('<label for="i_saw_in"/>').text('Я видел в')
	    ).append(
			$('<input id="i_saw_in" class="b-missing__i_saw_in"/>').val('Москве')
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
		$('.b-missing__send_message').toggle();    
		$('.b-missing__send_message_status').hide();
		
	});
});