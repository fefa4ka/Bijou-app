var QuestionGivers = (function() {
    var initialized = false,	// Состояние модуля
        questionModels = {}, 	// Список моделей вопросов
        questions = {
        	answered: [],		// Вопросы, на которые дали ответ
        	list: []			// Список оставшихся вопросов
        },
        missing_id,
        missing_path = '/missings';
   

    /**
	 * Модель вопроса.
	 */
    function Question(question_data) {
        this.model = getQuestionModel(question_data['answer_type']);	// Модель вопроса
        this.id = question_data['id'];									// Id вопроса в базе
        this.question = question_data['text'];							// Текст вопроса
        this.questionnaire = question_data['quiestionnaire'];			// Текст типа вопроса

        this.answers = question_data['answers'];	// Массив ответов
        											// { 'id': integer, 'text': string }
        											// id — номер ответа в базе

        this.hasOtherAnswer = question_data['other'];


        this.render = function () {
			var view = $.tmpl('<div class="b-form__question l-left ui-lightbox {{if model.type_id == 4}}map{{/if}}"> \
						<form accept-charset="UTF-8" action="' + missing_path + '/answer_the_question.json" data-remote="true" class="b-form__question_form answer_the_question" method="post"> \
							<input type="hidden" name="question[id]" value="${id}"> \
				 			<div class="b-form__label">${question}</div> \
							<div class="b-form__question_answer"> \
								{{tmpl "' + this.model.templatePrefix() + '_container"}} \
							</div> \
                            {{if model.customActions}} \
                                <div class="clear"></div> \
                                {{tmpl "' + this.model.templatePrefix() + '_actions"}} \
                            {{else}} \
                                <div class="clear"></div> \
                                <div class="b-form__question__actions"> \
                                 <input type="submit" value="Ответить" class="b-form__question__action_button" action="answer"> \
                                 <input type="submit" value="Отложить вопрос" class="b-form__question__action_button next_question silver_action l-right" action="skip"> \
                                </div> \
                            {{/if}} \
						</form> \
				 	</div>', this);
			return view;
        }
    }

    /**
	 * Возвращает модель вопроса по названию или айди
	 * @param {Integer} or {String} model_id_or_name	Название модели или её id
	 * @return {QuestionModel}
	 */
    function getQuestionModel(model_id_or_name) {
        for (model in questionModels) {
            var current_model = questionModels[model];

            if (typeof model_id_or_name == "string" && model == model_id_or_name) {
                return current_model;
            } else if (typeof model_id_or_name == "number" && current_model.typeId == model_id_or_name) {
                return current_model;
            }
        }
    }
    
    function loadQuestions() {

    	$.get( missing_path + '/questions', function(data) {
 			for (i in data) {
	            var question_data = data[i],
                    question = new Question(question_data);
                log(question.render().html());
	            questions.list.push(question);
	        }
 		}, "json");
        
    }

    return {
        init: function(missing_id) {
            if (initialized == false) {
            	missing_id = missing_id;
            	missing_path += '/' + missing_id;

                loadQuestions();

                initialized = true;
            }
        },
        addQuestionModel: function(model) {
            questionModels[model.name] = model;
            // Подготавливаем шаблоны
            model.prepareTemplates();

        },
        updateQuestions: function() {
            questions.list = [];
            loadQuestions();
        }
    }
}());

// Запускаем после загрузки джиквери, будем использовать его функции.

$(function () {
    var QuestionModel = {
        templatePrefix: function () {
            return 'tmpl-question__' + this.name;
        },
        prepareTemplates: function () {
            for (name in this.templates) {
                var template = this.templates[name].replace(/#templatePrefix/g, this.templatePrefix()),
                    template_name = this.templatePrefix() + '_' + name;
                $.template(template_name, template);
            }    
        }
    }

    // Yes - No
    QuestionGivers.addQuestionModel($.extend({
        typeId: 0,
        name: 'yes-no',
        customActions: true,
        templates: {
            actions: '<input type="submit" value="Да" class="b-form__question__action_button" action="yes"> \
                      <input type="submit" value="Нет" class="b-form__question__action_button" action="no"> \
                      <input type="submit" value="Отложить вопрос" class="b-form__question__action_button next_question silver_action l-right" action="skip">'
        }
    }, QuestionModel));

    // One or other answer
    QuestionGivers.addQuestionModel($.extend({
        typeId: 1,		// id типа ответа
        name: 'one',    
        templates: {	// Используемые в мобели шаблоны
        	// Контейнер для вариантов ответа
        	container: '<ul class="b-question_answers_list"> \
        					{{tmpl "#templatePrefix_answers"}} \
        					{{if other}} \
        						{{tmpl "#templatePrefix_other_answer"}} \
    						{{/if}} \
        				  </ul>',
        	// Варианты ответов
        	answers: '{{each answers}} \
        				<li class="b-question_answers_list__item {{if $item.parent.data.answers.length > 4}}half{{/if}}"> \
           					<input id="question_answer_id_${$value.id}" name="question[answer][id]" type="radio" value="${$value.id}" /> <label for="question_answer_id_${$value.id}">${$value.text}</label> \
        			 	</li> \
    				 	{{/each}}',
    		// Другой ответ
    		other_answer: '<li class="b-question_answers_list__item {{if answers.length > 4}}half{{/if}}"> \
    					 		<input id="question_answer_id_other_${id}" name="question[answer][id]" type="radio" value="other" /> <label for="question_answer_id_other_${id}">другое</label><br> \
    					 		<input class="b-question__other_answer" data-checkbox="question_answer_id_other_${id}" type="text" name="question[answer][text]"> \
    					 	 </li>',

        }
    }, QuestionModel));

   // Any answers
   QuestionGivers.addQuestionModel($.extend({
        typeId: 2,     // id типа ответа
        name: 'any',    
        templates: {    // Используемые в мобели шаблоны
            // Контейнер для вариантов ответа
            container: '<ul class="b-question_answers_list"> \
                            {{tmpl "#templatePrefix_answers"}} \
                            {{if other}} \
                                {{tmpl "#templatePrefix_other_answer"}} \
                            {{/if}} \
                          </ul>',
            // Варианты ответов
            answers: '{{each answers}} \
                        <li class="b-question_answers_list__item {{if $item.parent.data.answers.length > 4}}half{{/if}}"> \
                            <input type="checkbox" id="question_answers_ids_${$value.id}" name="question[answer][answers_ids][${$value.id}]"><label for="question_answers_ids_${$value.id}">${$value.text}</label> \
                        </li> \
                      {{/each}}',
            // Другой ответ
            other_answer: '<li class="b-question_answers_list__item {{if answers.length > 4}}half{{/if}}"> \
                            другое<br>\
                            <input type="text" name="question[answer][text]">\
                           </li>',

        }
    }, QuestionModel));

    // Free Answer
    QuestionGivers.addQuestionModel($.extend({
        typeId: 3,
        name: 'free',
        templates: {
            container: '<textarea name="question[answer][text]" class="b-form__question_answer_free"></textarea>'
        }
    }, QuestionModel));

    // Map Answer
    QuestionGivers.addQuestionModel($.extend({
        typeId: 4,
        name: 'map_points',
        templates: {
            container: '<div class="b-form__question_search_container l-left"> \
                            <input type="text" class="b-form__question_map_search" placeholder="Адрес места"><input type="button" class="b-form__question_search_button" value="Найти"> \
                            <p class="b-form__field_description">Вы можете добавить несколько мест</p> \
                        </div> \
                        <div class="b-form__question_map_description l-left"> \
                            Чтобы уточнить месторасположение, добавьте место и перетащите метку. \
                        </div> \
                        <div class="b-form__question_yandex_map"></div> \
                        <ul class="b-form__question_map_list"> \
                        </ul>'
        }
    }, QuestionModel));

    // Date 
    QuestionGivers.addQuestionModel($.extend({
        typeId: 6,
        name: 'date',
        templates: {
            container: '<div class="b-form__question_date"></div> \
                        <input class="b-form__question_date_input" type="text" name="question[answer][date]"> дд/мм/гггг'
        }
    }, QuestionModel))

   // Registration answers
   QuestionGivers.addQuestionModel($.extend({
        typeId: 7,     // id типа ответа
        name: 'registration',    
        customActions: true,
        templates: {    // Используемые в мобели шаблоны
            // Контейнер для вариантов ответа
            container: '<label for="question_answer_name" class="b-form__label">Ваше имя</label> \
                        <input type="text" name="question[answer][name]" id="question_answer_name"/> \
                        <label for="question_answer_email" class="b-form__label">Электронная почта</label> \
                        <input type="email" name="question[answer][email]" id="question_answer_email"/> \
                        <label for="question_answer_phone" class="b-form__label">Телефон</label> \
                        <input type="text" name="question[answer][phone]" id="question_answer_phone" class="b-form__phone"/>',
            // Варианты ответов
            actions: '<div class="b-question__actions"> \
                             <input type="submit" value="Ответить" class="b-form__question__action_button" action="answer"> \
                            </div>'
        },
        afterShow: function () {
            $(".b-question.selected .b-form__phone").mask('+7 999 999-99-99'); 
            $(".b-question_login").live('click', function() {
                var email = $('.b-form__question.selected [name="question[answer][email]"]').val();

                show_auth_dialog(function() {
                    load_questions();
                }, email);

                return false;
            });
            
            $(".question.selected .b-form__question_form").
                bind('ajax:success', function(evt, data, status, xhr){
                    if(data.logged_in) {
                        after_auth();
                    }
            })
            .validate({
                errorClass: 'b-tooltip-error-block', 
                messages: {
                    "question[answer][email]": {
                        remote: "Такой адрес зарегистрирован, <a href='#' class='b-form__question_login'>войдите с паролем</a>."
                    }
                },
                rules: {    
                    "question[answer][name]": {
                        required: true
                    },
                    "question[answer][email]": {
                        required: true,
                        email: true,
                        remote: {
                            type: "post",
                            url: "/service/check_email_exist.json",
                            data: {
                                email: function() {
                                    return $('.b-question.selected [name="question[answer][email]"]').val()
                                }
                            }
                        }
                    }
                }
            });
        }
    }, QuestionModel));
                
});