$(function (){
	if( $(".p-missing").length == 0 ) return;

   var validate = {
            errorClass: 'b-tooltip-error',
            rules: {
                "discussion[comment]": { required: true }
            }
        };
   	$('.new_discussion')
		.live('ajax:beforeSend', function(e){
		    if(!logged_in) {
             show_auth_dialog( function (){ $('.new_discussion').submit(); log('submit comment'); } );
             e.preventDefault();
             return false;
            }
		})
		.live('ajax:success', function(evt, data, status, xhr){    
			// Если все ок, добавляем комментарий и очищаем заполненные поля
			
			var comment = data.comment,
			  	comment_el;
		    
			if( comment.discussion_id > 0 )
			{                   
				comment_el = $('<div class="b-missing__comment sub"/>')
							.append( $('<div class="b-missing__comment_header l-left">') 
									 	.append( $('<a class="b-missing__comment_author"/>')
									 			 	.attr('href', '/user/' + comment.user.id)      
													.text(comment.user.username)
								   		)
										.append( $('<span class="b-missing__comment_date t-small l-right"/>')
										 			.text(comment.date)
										)
						    )
						 	.append( 
								$('<div class="b-missing__comment_text"/>').text(comment.comment)
							).appendTo('.b-missing__comment[discussion_id=' + comment.discussion_id + ']');          
				 
			   	$(this).hide();
							
			 } else {          
				comment_el = $('<div class="b-missing__comment"/>')
							.append( $('<div class="b-missing__comment_header">') 
									 	.append( $('<a class="t-medium b-missing__comment_author"/>')
									 			 	.attr('href', '/user/' + comment.user.id)      
													.text(comment.user.username)
								   		)
										.append( $('<span class="b-missing__comment_date t-small"/>')
										 			.text(comment.date)
										)
						    )
						 	.append( $('<div class="b-missing__comment_text comment b-tooltip top silver"/>')
										.append( $('<i class="b-tooltip__tail_border"><b class="b-tooltip__tail"></b></i>') )
										.append( $('<div class="b-tooltip__content"/>')
										 			.text(comment.comment)
										)
							).appendTo('.b-missing__comments');   
				
				$(this).children('textarea').val("");
			}          
		})
        .validate(validate);                            
		
	$('.b-missing__comment_answer').live('click', function(){
		var comment = $(this).parent().parent(),
			discussion_id = comment.attr('discussion_id');
		
		$('#new_discussion').clone().attr('id', "").append( 
			$('<input type="hidden" name="discussion[discussion_id]"/>').val( discussion_id )
		).appendTo( comment );      
		
		$(this).hide();
		
	});
});
