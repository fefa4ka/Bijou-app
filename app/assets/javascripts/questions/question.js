$(function(){                      
	function render_questions(questions) {                                            
		// Устанавливаем тему первого вопроса                        
		$('.b-form__questionnaire').text(questions[0].questionnaire);
		$.tmpl('tmpl-question', questions).appendTo('.b-form__questions');
	    $('input').customInput();                                       
	
		$('.b-form__questions_container').removeClass('l-hidden');
		$('.b-form__questions div:first').addClass('selected ui-corner-all');
		                                                   
		prepare_question(questions[0]);            
		
		$('.b-form__question__action_button').live('click', function(){ 
			log('set submit action', $(this).attr('action'));
			submit_action = $(this).attr('action');
		});
	}                   
	
	function prepare_question(question){   
		log('prepare');
		switch(question.answer_type) {
			case 4:                    
			log('mao');
				generate_map();        
				break;
			case 6:      
				generate_datepicker();
				break;
		}
	}             
	function generate_datepicker(){
		$(".b-form__question.selected .b-form__question_date").datepicker({
			onSelect: function(dateText, inst){
				$('.b-form__question_date_input').val($(this).datepicker('getDate').toUTCString());
			}
		});
	}   
	
	function generate_map() {
		// Создание обработчика для события window.onLoad
        // Создание экземпляра карты и его привязка к созданному контейнеру               
		log('generate map', $(".b-form__question.selected .b-form__question_yandex_map"));

        var map = new YMaps.Map($(".b-form__question.selected .b-form__question_yandex_map")),
        	zoomControl = new YMaps.SmallZoom(),
			zoom = 10,
			center,
			last_placemark,
			saved_placemarks = [];
		function geocode(value, callback){
			// Запуск процесса геокодирования
            var geocoder = new YMaps.Geocoder(value, {results: 1, boundedBy: map.getBounds()}),
            	result;
    
            
            // Создание обработчика для успешного завершения геокодирования
            YMaps.Events.observe(geocoder, geocoder.Events.Load, function () {
                // Если объект был найден, то добавляем его на карту
                // и центрируем карту по области обзора найденного объекта
                if (this.length()) {
                    result = this.get(0);
                    callback(result);
                }else {
                    alert("Ничего не найдено")
                }
            });

            // Процесс геокодирования завершен неудачно
            YMaps.Events.observe(geocoder, geocoder.Events.Fault, function (geocoder, error) {
                alert("Произошла ошибка: " + error);
            });
            
            
		}
		
		function add_placemark(request) { 
			function create_placemark(geoPoint){ 

				var overlay = new YMaps.Placemark(geoPoint, {
			        	draggable: true,
			        	style: "default#buildingsIcon" 
			        });
				map.addOverlay(overlay);   
				return overlay;
			}        
		    
			function add_events(){
				// Установка слушателей событий для метки            
				                            
				// Обработчик для контролов в балуне
		        YMaps.Events.observe(placemark, placemark.Events.BalloonOpen, function (obj) {  
					function save_placemark(){
						var list = '.b-form__question_map_list';
						last_placemark = "";

						$('<li class="b-form__question_map_item"/>').append( $('<p/>').text(address) )
																   .append( $('<input class="address" type="hidden" name="question[answer][places][address][]"/>').val(address) )
																   .append( $('<input class="geopoint" type="hidden" name="question[answer][places][geopoint][]"/>').val(placemark.getGeoPoint().toString()) )
																   .attr('item_id', placemark_id)
																   .appendTo(list)
																   .click(function(){
																	    placemark.openBalloon();
																   });    

                        placemark.closeBalloon();

						$(this).removeClass('blue_action')
							   .addClass('red_action')
							   .val('Удалить место')
							   .click(remove_placemark);
					}                                   
					
					function remove_placemark(){
						$('.b-form__question_map_item[item_id=' + placemark_id + ']').remove();
				   		map.removeOverlay(placemark);
					}       
					
					if(!attached_events) {  
				        $(".b-question__map_balloon_button_" + placemark_id).click(saved ? remove_placemark : save_placemark).customInput();              
						log(placemark_id, attached_events, saved);
						attached_events = true;          
						saved = true;
					}
		        });

		        YMaps.Events.observe(placemark, placemark.Events.DragStart, function (obj) {
		            prev = obj.getGeoPoint().copy();
		        });

		        YMaps.Events.observe(placemark, placemark.Events.Drag, function (obj) {
		            var current = obj.getGeoPoint().copy();

		            // // Увеличиваем пройденное расстояние
		            // distance += current.distance(prev);
		            // prev = current;
		            // 
		            // obj.setIconContent("Пробег: " + YMaps.humanDistance(distance));      
		        });

		        YMaps.Events.observe(placemark, placemark.Events.DragEnd, function (obj) {
		            obj.update();   
		
					geocode(obj.getGeoPoint(), function(geoResult){      
						var content = { id: placemark_id, address: geoResult.text, saved: saved };
						
						address = content.text;
						set_balloon_content(content);
						
						$('.b-form__question_map_item[item_id=' + placemark_id + ']').find('p').text(geoResult.text);
						$('.b-form__question_map_item[item_id=' + placemark_id + ']').find('input.address').val(geoResult.text);
						$('.b-form__question_map_item[item_id=' + placemark_id + ']').find('input.geopoint'). val(geoResult.getGeoPoint().toString()); 
						
						attached_events = 0;   
					});     
					
		        });
			} 
			
			function set_balloon_content(content){
				var template = $('<div/>');
				$.tmpl('tmpl-question__map_balloon', content).appendTo(template); 
				
				placemark.setBalloonContent(template.html());
			}                              
			
			
			// Если метка из координат, создаем ее сразу
	        var placemark = typeof request != "string" ? create_placemark(request) : "",
        		address,
        		placemark_id = (new Date()).getTime(),
				saved = false,
        		attached_events;
            
			// Если метка текстовый запрос, создаем по мере получения ответа
       		geocode(request, function(geoResult) {
        		var content = { id: placemark_id, address: geoResult.text };
  
                address = geoResult.text;
				               	
				if(typeof request == "string") {
					placemark = create_placemark(geoResult.getGeoPoint());
				}
				
				add_events();  
				  
				set_balloon_content(content);
				placemark.openBalloon();       
				
				map.setBounds(geoResult.getBounds());
				
				$(".b-form__question.selected .b-form__question_map_search").val("");
			});  
			  
			       
			map.removeOverlay(last_placemark);
			last_placemark = placemark;
			
			
	        // // Общее расстояние и предыдущая точка
	        // var distance = 0, prev;      
	
	        
		}
		
		function add_place_from_address(address) {
			// Удаляем прошлый результат
            add_placemark(address);
             
		}
		
		$.template('tmpl-question__map_balloon', '<div class="b-question__map_balloon t-strong">${address}</div> \
											      <input type="button" class="b-question__map_balloon_button b-question__map_balloon_button_${id} {{if saved}}red_action{{else}}blue_action{{/if}}" value="{{if saved}}Удалить место{{else}}Добавить место{{/if}}">');
		
        // Установка для карты ее центра и масштаба
		if (YMaps.location) {
		    center = new YMaps.GeoPoint(YMaps.location.longitude, YMaps.location.latitude);
       	} else {
			center = new YMaps.GeoPoint(37.64, 55.76);
		}
		
		map.enableDblClickZoom();
		map.addControl(zoomControl);
		map.setCenter(center, zoom)
		 
		// Добавляем метку по клику на карте
		// var onClickListener = YMaps.Events.observe(map, map.Events.Click, function (map, mEvent) { 
		// 		add_placemark(mEvent.getGeoPoint());   	        
		// });   
		      
        
                     

		if( $(".b-form__question.selected .b-form__question_map_search").length != 0 ) 
		{                           
			$(".b-form__question_search_button").click(function(){
				var request = $(".b-form__question.selected .b-form__question_map_search").val();
				add_place_from_address( request );
			});
			
			$(".b-form__question.selected .b-form__question_map_search").autocomplete({
				minLength: 2,
				source: function( request, response ) {
					var ll = map.getCenter().toString(),
						spn = map.getBounds().getSpan().toString();

					$.ajax({
						url: "/add_missing/address_suggest.json",
						dataType: "jsonp",
						data: {
							part: request.term,
							ll: ll,
							spn: spn
						},
						success: function( data ) {

							response( $.map( data[1], function( item ) {
								var suggest = item[1],
									value = item[2]
									label = "";
								for(i in suggest) {
									var item = suggest[i];

									if( typeof(item) == "object" && (item instanceof Array))
									{
										label += '<b>' + item[1] + '</b>';
									} else {
										label += item;
									}
								}

								return {
									label: label,
									value: value
								}
							}));
						}
					});

				},
				select: function(event, ui) {
					$(".b-form__question.selected .b-form__question_map_search").val( ui.item.value );
				}
			})
			.keydown( function( event ) {
				// Если нажать на Enter в поле поиска, то откроется оверлей добавления места
				if( event.keyCode == 13) {
					$(".b-form__question_search_button").click();

					return false;
				}
			})
			.data( "autocomplete" )
			._renderItem = function( ul, item ) {
					return $( "<li></li>" )
						.data( "item.autocomplete", item )
						.append('<a>' + item.label + '</a>')
						.appendTo( ul );
				}
		}             
		
		$('.b-form__question.selected .b-form__question__action_button').click(function() {
			map.destructor();
		})
        
	}
	
	var submit_action;
	
	$.template( 'tmpl-question',
				'<div class="b-form__question l-left {{if answer_type == 4}}map{{/if}}"> \
					<form accept-charset="UTF-8" action="/add_missing/answer_the_question.json" data-remote="true" class="b-form__question_form answer_the_question" method="post"> \
					<input type="hidden" name="question[id]" value="${id}"> \
				 	<div class="b-form__label">${text}</div> \
					<div class="b-form__question_answer"> \
					 	{{if answer_type == 0}} \
						 	{{tmpl "tmpl-question__yes-no-dontknow"}} \
						 {{else answer_type == 1 || answer_type == 2}} \
						 	{{tmpl "tmpl-question__one_any"}} \
						 {{else answer_type == 3}} \
						 	{{tmpl "tmpl-question__free"}} \
						 {{else answer_type == 4}} \
							{{tmpl "tmpl-question__map"}} \
						{{else answer_type == 6}} \
							{{tmpl "tmpl-question__date"}} \
						 {{/if}} \
						 {{if answer_type != 0}} \
							<div class="clear"></div> \
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
					 	<input id="question_answer_id_other_${id}" name="question[answer][id]" type="radio" value="other" /> <label for="question_answer_id_other_${id}">другое</label><br> \
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
				 <input type="submit" value="Отложить вопрос" class="b-form__question__action_button next_question silver_action l-right"  action="skip"> \
				 </div>' );         
				
	$.template( 'tmpl-question__yes-no-dontknow', 
				'<input type="submit" value="Да" class="b-form__question__action_button" action="yes"> \
				 <input type="submit" value="Нет" class="b-form__question__action_button" action="no"> \
				 <input type="submit" value="Отложить вопрос" class="b-form__question__action_button next_question silver_action l-right" action="skip">' );
				
	$.template( 'tmpl-question__map', 
				'<table class="b-form__question_map"> \
				 <tr> \
				 <td class="b-form__question_map_container"> \
				 	<div class="b-form__question_search_container"> \
						<input type="text" class="b-form__question_map_search" placeholder="Адрес места"><input type="button" class="b-form__question_search_button" value="Найти"> \
					</div> \
				 	<div class="b-form__question_yandex_map"></div> \
					<p class="b-form__field_description">Чтобы уточнить место, можно перетащить метку.</p> \
				 </td> \
				 <td> \
					<p>Вы можете добавить несколько мест</p> \
					<ul class="b-form__question_map_list"> \
					</ul> \
				 </td></tr> \
				 </table>');
				
	$.template( 'tmpl-question__date', 
				'<div class="b-form__question_date"></div> \
				 <input class="b-form__question_date_input" type="hidden" name="question[answer][date]">');
				 
				 
	// Отправка ответа
	$(".answer_the_question")
		.live("ajax:beforeSend", function(e, xhr, settings){      
			// TODO: Отображать процесс отправки запроса. 
			settings.data += "&question[action_type]=" + submit_action;
		})
		.live("ajax:success", function(evt, data, status, xhr){
			function callback_destroy(){ 
				$(this).remove();                 
			}         
			
			function callback_construct(){
				// TODO: fade in ответов плавный                        
				log('construct');                      
                $(this).addClass('selected').removeAttr('style'); 
				prepare_question(respond_question);
			}      
		   
					
			var question = $(this).parents('div.b-form__question'),
			 	next_question = question.next(),
			 	next_question_id = next_question.find('input[name="question[id]"]').val(),
			 	respond_question = data.question,
			 	respond_question_el = 0,
				width = question.outerWidth() * -1 - 50,
				questionTop = 0;
			
			// Если осталось меньше 3х вопросов, пытаемся подгрузить еше
			// Если вопросов больше нет, показываем заглушку, что вопросы еще есть, но наних нужно будет ответить после размещения объявления
			        

			// Если следующий вопрос, такой же как ожидали
			if(respond_question == null){     
				$('.b-form__questions_infinity').remove();
				$('.b-form__questions_finish').removeClass('l-hidden'); 
				question.effect('drop', { queue: false }, 500, callback_destroy);  
				
				return;  
			} else if (respond_question.id == next_question_id){
				question.effect('drop', { queue: false }, 500, callback_destroy);  
				next_question.find('.b-form__question_answer').show('slide', { direction: 'up', queue: false }, 500);
				next_question.animate({ marginLeft: width }, 500, 'linear',  callback_construct);     
				
			} else if (respond_question.id > 0) {
				// Если пришел новый вопрос, рендерим его
				respond_question_el = $.tmpl('tmpl-question', respond_question)
											.addClass('selected')
											.hide()
											.prependTo('.b-form__questions')
											.show('slide', { direction: 'up' }, 500, callback_construct);
										   
				
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
