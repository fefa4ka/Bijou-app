$(function (){
	if( $(".p-missing").length == 0 && $(".p-report").length == 0 ) return;
    
    var validate = {
            errorClass: 'b-tooltip-error',
            rules: {
                "message[text]": { required: true, minlenght: 10 },
                "message[name]": { required: true, minlenght: 3 },
                "message[email]": { required: true, email: true }
            }
        };

   	$('.new_message')
		.live('ajax:beforeSend', function(e){
			
		})
		.live('ajax:success', function(evt, data, status, xhr){    
			// Если все ок, добавляем комментарий и очищаем заполненные поля
			
			var message = data.message,
			  	message_el;
		    
			if( message.message_id > 0 )
			{                   
				message_el = $('<div class="b-missing__comment sub"/>')
							.append( $('<div class="b-missing__comment_header message l-left">') 
									 	.append( $('<a class="b-missing__comment_author"/>')
									 			 	.attr('href', '/user/' + message.user.id)      
													.text(message.user.username)
								   		)
										.append( $('<span class="b-missing__comment_date t-small l-right"/>')
										 			.text(message.date)
										)
						    )
						 	.append( 
								$('<div class="b-missing__comment_text"/>').text(message.text)
							).appendTo('.b-missing__comment[message_id=' + message.message_id + ']');          
				 
			   	$(this).hide();
							
			 
			}          
		})
        .validate(validate);                            
		
	$('.b-report__message_answer').live('click', function(){
		var message = $(this).parent().parent(),
			message_id = message.attr('message_id');
		
		$('#new_message').clone().attr('id', "").append( 
			$('<input type="hidden" name="message[to_message]"/>').val( message_id )
		).appendTo( message ).show();      
		
		$(this).hide();
		
	});
});
