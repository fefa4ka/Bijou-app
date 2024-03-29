$(function(){
	if( $(".p-new-missing").length == 0 ) return;

	function add_place(address)
	{
		$.getJSON( "/add_missing/address_data.json", { address: address }, function( data, status, xhr ) {
			if ( data.address ) {
				var marker = {
					lat: data.lat,
					lng: data.lng,
					title: data.address
				}
				
				// Gmaps.map.addMarkers( [marker] );
				
				$(".b-form__place").hide();
				$(".b-form__add_place").show();

				$(".b-form__add_place_address").val(data.address);
				
				
				// Фокусируемся на названии
				$(window).scrollTop( $('.b-form__add_place').offset().top );
				$(".b-form__add_place_name").focus();					
			}
		});
	}
		
	function hide_place(options)
	{
		$(".b-form__add_place").hide();
		$(".b-form__place").show();

		// Очищаем поля
		$(".b-form__add_place .b-form__field input, .b-form__add_place .b-form__field textarea").val("");
		if( options.clear_search_field ) {
			$(".b-form__place_search_text_field").val("");
		}
		
		
		// Фокусируем на строчку поиска
		$(".b-form__place_search_text_field").focus();
		
		// Для ссылки
		return false;
	}		
	             
	if( $(".b-form__place_search_text_field").length != 0 ) 
	{
		$(".b-form__place_search_text_field").autocomplete({
			minLength: 2,
			source: function( request, response ) {
				var bounds = Gmaps.map.map.getBounds(), 
					center = Gmaps.map.map.getCenter(),
					ne = bounds.getNorthEast(),
					sw =  bounds.getSouthWest(),
					size = {
						lng: ne.lng() - sw.lng(),
						lat: ne.lat() - sw.lat()
					}
					ll = [center.lng(), center.lat()].join(','),
					spn = [size.lng, size.lat].join(',');
			
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
				add_place( ui.item.value )
			}
		})
		.keydown( function( event ) {
			// Если нажать на Enter в поле поиска, то откроется оверлей добавления места
			if( event.keyCode == 13) {
				$(".b-form__place_search_button").click();
			
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
	
	// По Enter в оверлее добавления места, место добавляется
	// $('.b-form__add_place').keydown( function( event ) {
	// 	if( event.keyCode == 13) {
	// 		$(".b-form__add_place_button").click();
	// 		
	// 		return false;
	// 	}
	// });
	//      
	
	$(".b-form__place_search_button").click(function() {
		add_place( $(".b-form__place_search_text_field").val() );
	});
	
	
	$(".b-form__add_place_button_cancel").live("click", hide_place);
	                                             
	log('loading add_places');
	$(".b-form__add_place_button").live("click", function() {
		log(this);
		var prefix = ".b-form__add_place_",
			fields = ['name', 'address', 'description', 'missing'],
			new_id = new Date().getTime(),
			element = $("<div></div>")
						.addClass("b-form__field b-form__place")
						.append( $("<div></div>")
							.addClass("b-form__label")
								.text( $(prefix + fields[0]).val() )
						)
						.append( $("<p></p>")
							.text( $(prefix + fields[2]).nl2br().val() )
						)
						.append( $("<p class='t-small'></p>")
							.text( $(prefix + fields[1]).val() )
						);
						
		add_hidden_fields(element, prefix, fields);
		// Сохраняем поле с датой пропажи, если оно было указано
		
		console.log(element)
		$(".b-form__places").append( element );
		
		hide_place( { clear_search_field: true } );
		
		// Сохраняем добавленное место
		redirect_disallow = true;
		$("#new_missing").submit();
	});                        
	
    // Обработчик чекбокса "Это место пропажи"
	$('.b-form__add_place_missing').live('change', function(){             
		var $div = $('.b-form__its_missing_place_date'),
			checked = $(".b-form__add_place_missing:checked").val() !== undefined ? $div.show() : $div.hide();     
	});              
	
	// Удаление мест
	$(".b-form__place .destroy").live('click', function(){
		$(this).toggle(function(){	
			$(this)
				.val('восстановить')
				.removeClass('red_action').addClass('silver_action')
			.parents('.b-form__place')
				.removeClass('active').addClass('deleted')
			.find('input[name$="[_destroy]"]')
				.val(1);
		},
		function(){
			$(this)
				.val('удалить')
				.removeClass('silver_action').addClass('red_action')
			.parents('.b-form__place')
				.removeClass('deleted').addClass('active')
			.find('input[name$="[_destroy]"]')
				.val(0);
		}).trigger('click');
	});
			
})