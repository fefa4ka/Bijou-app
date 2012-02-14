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
			  	message_el,
				id,
				type_id;
		    
			if( message.message_id > 0 || message.seen_the_missing_id > 0 )
			{                               
                type_id = message.message_id > 0 ? "message" : "seen_the_missing";
				id = message.message_id > 0 ? message.message_id : message.seen_the_missing_id;
				
				message_el = $('<div class="b-missing__comment sub"/>')
							.append( $('<div class="b-missing__comment_header message l-left">') 
									 	.append( $('<a class="b-missing__comment_author"/>')
									 			 	.attr('href', '/user/' + message.user.id)      
													.text(message.user.name)
								   		)
										.append( $('<span class="b-missing__comment_date t-small l-right"/>')
										 			.text(message.date)
										)
						    )
						 	.append( 
								$('<div class="b-missing__comment_text"/>').text(message.text)
							).appendTo('.b-missing__comment[' + type_id + '_id=' + id + ']');          
				 
			   	$(this).hide(); 
			}          
		})
        .validate(validate);                            
		
	$('.b-report__message_answer').live('click', function(){
		var message = $(this).parent().parent(),
			message_id = message.attr('message_id'),
			user_id = message.attr('user_id'),
			seen_the_missing_id = message.attr('seen_the_missing_id');
		
		$('#new_message').clone().attr('id', "").append( 
			$('<input type="hidden" name="message[to_message]"/>').val( message_id )
		).append( 
			$('<input type="hidden" name="message[to]"/>').val( user_id )
		).append( 
			$('<input type="hidden" name="message[to_seen_the_missing]"/>').val( seen_the_missing_id )
		).appendTo( message ).show();      
		
		$(this).hide();
		
	});
});
