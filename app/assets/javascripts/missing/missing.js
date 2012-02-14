$(function(){    
   if( $(".p-missing").length == 0 ) return; 


   function animate_i_can_help_window(height) {
		var window = $('.b-missing__i_can_help_window');
		
		window.parent().animate({
			top: window.offset().top - height/2
		});                    
		
	   
   }
   
	function generate_map() {
       // Создание экземпляра карты и его привязка к созданному контейнеру               
       var map = new YMaps.Map($(".b-missing__map")),
       		zoomControl = new YMaps.SmallZoom(),
			zoom = 10,
			center,
            placemarkCollection = new YMaps.GeoObjectCollection();
	 
	    function add_placemarks() {
            var placemark;

			function set_balloon_content(content){
				var template = $('<div/>');
				$.tmpl('tmpl-missing__map_balloon', content).appendTo(template); 
				
				placemark.setBalloonContent(template.html());
			}                              
			
            $.template('tmpl-missing__map_balloon', '<div class="t-strong">${name}</div><p>${address}</p>');
	
            if( places.length > 0) {
                for(i in places) {
                    var entity = places[i],
                        place = entity.answers[0],
                        point = new YMaps.GeoPoint(place.longitude, place.latitude),
                        content = { name: entity.label, address: place.address },
                        style = "default#buildingsIcon",
                        element = $('<li class="b-missing__place"/>');

                        element.append( $('<div class="t-medium"/>').text( entity.label ) )
                               .append( $('<div class="b-missing__place_address"/>').text( place.address ).click(function() {
                                   placemark.openBalloon();
                                   })
                               )
                               .appendTo('.b-missing__places');

                    placemark = new YMaps.Placemark(point, { style: style });
                    set_balloon_content(content);
                    placemarkCollection.add(placemark);
                }
                map.addOverlay(placemarkCollection);
            }
	    }

		
        // Установка для карты ее центра и масштаба
		if (YMaps.location) {
		    center = new YMaps.GeoPoint(YMaps.location.longitude, YMaps.location.latitude);
      	} else {
			center = new YMaps.GeoPoint(37.64, 55.76);
		}

	    map.enableDblClickZoom();
		map.addControl(zoomControl);
		map.setCenter(center, zoom);

        add_placemarks();
   }                                           	
   
   if( $(".b-missing__map").length > 0){
    	generate_map();
   }
	
   // Фотографии загружаем в оверлеи 
   $(".b-missing__photo_link").fancybox();
    
   // Реакция на кнопку «Я видел этого человека»
   $('.b-missing__i_saw').click(function(){
   	   $(this).hide();
       $(".b-missing__i_saw_in").show();
    });                                             
	        
    $(".b-missing__i_saw_in_change").live('click', function() {
        $(".b-missing__i_saw_in").hide();
        $(".b-missing__i_saw_in_change_container").show();
        log('change');

    });

     $(".b-missing__i_saw_in_save").live('click', function() {
        $(".b-missing__i_saw_in").show();
        $(".b-missing__i_saw_in_change_container").hide();
        $(".b-missing__i_saw_in_place").text( $(".b-missing__i_saw_in_change_field").val() );

        log('save');
    });


	// Реакции на отправку личного сообщения

	$('.b-missing__sent_message_auth').live('click', function(){
		var email = $('#new_message [name="message[email]"]').val();
		
		show_auth_dialog(function() {
			$('.b-missing__send_message_user').hide();
		}, email);	
	});
                     
log('new_message');
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
		})
		.validate({
			errorClass: 'b-tooltip-error-block', 
			messages: {
				"message[email]": {
					remote: "Такой адрес зарегистрирован, <a href='#' class='b-missing__sent_message_auth'>войдите с паролем</a>."
				}
			},
			rules: {
				"message[name]": {
					required: true
				},
				"message[email]": {
					required: true,
					email: true,
					remote: {
						type: "post",
						url: "/users/check_email.json",
						data: {
							email: function() {
								return $('#new_message [name="message[email]"]').val()
							}
						}
					}
				}
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

    $(".b-missing__select_version").combobox({ combobox_class: "fat", input_disabled: true });
});
