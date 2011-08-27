$(function(){
	function add_place(address)
	{
		$.getJSON( "/add_missing/address_data.json", { address: address }, function( data, status, xhr ) {
			if ( data.matched_address ) {;
				var marker = {
					lat: data.lat,
					lng: data.lng,
					title: [data.full_data.address_components[1].long_name, data.full_data.address_components[0].long_name].join(", ")
				}
				
				Gmaps4Rails.addMarkers( [marker] );
				
				$(".b-form__place").hide();
				$(".b-form__add_place").show();

				$(".b-form__add_place_address").val(data.matched_address);
				
				
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
	
	$(".b-form__place_search_text_field").autocomplete({
		minLength: 5,
		source: function( request, response ) {
			var term = request.term,
				bounds = Gmaps4Rails.map.getBounds().getNorthEast().toUrlValue() + "|" + Gmaps4Rails.map.getBounds().getSouthWest().toUrlValue();
				
			request.bounds = bounds;
			
			$.getJSON( "/add_missing/address_suggest.json", request, function( data, status, xhr ) {
				response( data );
			});
		},
		select: function(event, ui) {
			add_place( ui.item.value )
		}
	}).keydown( function( event ) {
		// Если нажать на Enter в поле поиска, то откроется оверлей добавления места
		if( event.keyCode == 13) {
			$(".b-form__place_search_button").click();
			
			return false;
		}
	});
	
	// По Enter в оверлее добавления места, место добавляется
	$('.b-form__add_place').keydown( function( event ) {
		if( event.keyCode == 13) {
			$(".b-form__add_place_button").click();
			
			return false;
		}
	});
	
	
	$(".b-form__place_search_button").click(function() {
		add_place( $(".b-form__place_search_text_field").val() );
	});
	
	
	$(".b-form__add_place_button_cancel").live("click", hide_place);
	
	$(".b-form__add_place_button").live("click", function() {
		var name_field = $(".b-form__add_place_name"),
			address_field = $(".b-form__add_place_address"),
			description_field = $(".b-form__add_place_description"),
			new_id = new Date().getTime(),
			element = $("<div></div>")
						.addClass("b-form__field b-form__place")
						.append( $("<div></div>")
							.addClass("b-form__label")
								.text( name_field.val() )
						)
						.append( $("<p></p>")
							.text( description_field.val() )
						)
						.append( $("<p></p>")
							.text( address_field.val() )
						)
						// Создаем поля
						.append( $("<input type=hidden />")
							.attr( "name", name_field.attr("name").replace(/[0-9]+/i, new_id) )
							.val( name_field.val() )
						)
						.append( $("<input type=hidden />")
							.attr( "name", address_field.attr("name").replace(/[0-9]+/i, new_id) )
							.val( address_field.val() )
						)
						.append( $("<input type=hidden />")
							.attr( "name", description_field.attr("name").replace(/[0-9]+/i, new_id) )
							.val( description_field.val() )
						);
						
		$(".b-form__places").append( element );
		
		hide_place( { clear_search_field: true } );
		
		// Сохраняем добавленное место
		redirect_disallow = true;
		$("#new_missing").submit();
	});
})