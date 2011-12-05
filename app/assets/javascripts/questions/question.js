$(function(){
	function render_questions() {                                            
		// Устанавливаем тему первого вопроса                        
		$('.b-form__questionnaire').text(questions[0].questionnaire);
		$.tmpl('tmpl-question', questions).appendTo('.b-form__questions');
	    $('input').customInput();                                       
	
		$('.b-form__questions_container').removeClass('l-hidden');
		$('.b-form__questions div:first').addClass('selected ui-corner-all');
		
		$('.b-form__question__action_button').live('click', function(){ 
			log('set submit action', $(this).attr('action'));
			submit_action = $(this).attr('action');
		});
	}
	
	var submit_action;
	
	$.template( 'tmpl-question',
				'<div class="b-form__question l-left"> \
					<form accept-charset="UTF-8" action="/add_missing/answer_the_question.json" data-remote="true" class="answer_the_question" method="post"> \
					<input type="hidden" name="question[id]" value="${id}"> \
				 	<div class="b-form__label">${text}</div> \
					<div class="b-form__question_answer"> \
					 	{{if answer_type == 0}} \
						 	{{tmpl "tmpl-question__yes-no-dontknow"}} \
						 {{else answer_type == 1 || answer_type == 2}} \
						 	{{tmpl "tmpl-question__one_any"}} \
						 {{else answer_type == 3}} \
						 	{{tmpl "tmpl-question__free"}} \
						 {{/if}} \
						 {{if answer_type != 0}} \
						    {{tmpl "tmpl-question__actions"}} \
						 {{/if}} \
					 </div> \
					 </form> \
				 </div>' );
 
    // Any variants 
	$.template( 'tmpl-question__one_any',
				'<ul class="b-form__question_answers_list"> \
				 {{if answer_type == 1}} \
				 	 {{tmpl "tmpl-question__one_items"}} \
					 {{if other}} \
					 <li class="b-form__question_answers_list__item {{if answers.length > 4}}half{{/if}}"> \
					 	<input id="question_answer_id_other_${id}" name="missing[answer][id]" type="radio" value="other" /> <label for="question_answer_id_other_${id}">другое</label><br> \
					 	<input type="text" name="question[answer][text]"> \
					 </li> \
					 {{/if}} \
				 {{else answer_type == 2}} \
				 	 {{tmpl "tmpl-question__any_items"}} \
					 {{if other}} \
					 <li class="b-form__question_answers_list__item {{if answers.length > 4}}half{{/if}}">другое<br><input type="text" name="question[answer][text]"></li> \
					 {{/if}} \
				 {{/if}} \
				 </ul>' );                     
				
	$.template( 'tmpl-question__any_items', 
				'{{each answers}} \
				 <li class="b-form__question_answers_list__item {{if $item.parent.data.answers.length > 4}}half{{/if}}"> \
				 <input type="checkbox" id="question_answers_ids_${$value.id}" name="question[answer][answers_ids][${$value.id}]"><label for="question_answers_ids_${$value.id}">${$value.text}</label> \
				 </li> \
				 {{/each}}' );
				 
	$.template( 'tmpl-question__one_items', 
				'{{each answers}} \
				 <li class="b-form__question_answers_list__item {{if $item.parent.data.answers.length > 4}}half{{/if}}"> \
       				<input id="question_answer_id_${$value.id}" name="question[answer][id]" type="radio" value="${$value.id}" /> <label for="question_answer_id_${$value.id}">${$value.text}</label> \
    			 </li> \
				 {{/each}}' );			 
	// Textarea answer
	$.template( 'tmpl-question__free',
			    '<textarea name="question[answer][text]" class="b-form__question_answer_free"></textarea>' );         
			
	$.template( 'tmpl-question__actions', 
				'<div class="clear"></div> \
				 <div class="b-form__question__actions"> \
				 <input type="submit" value="Ответить" class="b-form__question__action_button" action="answer"> \
				 <input type="submit" value="Отложить вопрос" class="b-form__question__action_button next_question" action="skip"> \
				 </div>' );         
				
	$.template( 'tmpl-question__yes-no-dontknow', 
				'<input type="submit" value="Да" class="b-form__question__action_button" action="yes"> \
				 <input type="submit" value="Нет" class="b-form__question__action_button" action="no"> \
				 <input type="submit" value="Не знаю" class="b-form__question__action_button" action="dont_know"> \
				 <input type="submit" value="Отложить вопрос" class="b-form__question__action_button next_question" action="skip">' );
				 
				 
	// Отправка ответа
	$(".answer_the_question")
		.live("ajax:beforeSend", function(e, xhr, settings){      
			// TODO: Отображать процесс отправки запроса. 
			settings.data += "&question[action_type]=" + submit_action;
		})
		.live("ajax:success", function(evt, data, status, xhr){
			function callback(){ 
				$(this).remove();                                                       
				
				// TODO: fade in ответов плавный
				$('.b-form__questions div:first').removeAttr('style').addClass('selected ui-corner-all'); 
			} 
					
			var question = $(this).parents('div.b-form__question'),
			 	next_question = question.next(),
			 	next_question_id = next_question.find('input[name="question[id]"]').val(),
			 	respond_question = data.question,
			 	respond_question_el = 0,
				width = question.outerWidth() * -1,
				questionTop = 0;
			
			// Если осталось меньше 3х вопросов, пытаемся подгрузить еше
			// Если вопросов больше нет, показываем заглушку, что вопросы еще есть, но наних нужно будет ответить после размещения объявления
			
			// Если следующий вопрос, такой же как ожидали
			if(respond_question.id == next_question_id){
				question.effect('drop', { queue: false }, 500, callback);
				next_question.animate({ marginLeft: width }, { queue: false }, 500)
			} else {
				// Если пришел новый вопрос, рендерим его
				
				respond_question_el = $.tmpl('tmpl-question', respond_question)
											.hide()
											.prependTo('.b-form__questions')
											.show('slide', { direction: 'up' }, 500, function() {
												$(this).addClass('selected'); 
											});
										   
				
				question.remove();								
				// questionTop = respond_question_el.height() + 30;
				// 
				// question.css('position', 'absolute')
				// 		.removeClass('selected')
				// 		.animate({ top: questionTop, left: 0 }, 500);
				
				$('input').customInput();
			}
			
			// Устанавливаем тему вопроса 
			$('.b-form__questionnaire').text(respond_question.questionnaire);   
			
		});
		
		if(typeof questions != "undefined" && questions.length > 0) {
			render_questions(questions);   
	    }
});

