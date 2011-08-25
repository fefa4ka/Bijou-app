$(function(){
	function add_place(address)
	{
		$(".b-form__place").hide();
		$(".b-form__add_place").show();
		
		// Очищаем все поля
		$(".b-form__add_place .b-form__field input").val("");
		$(".b-form__add_place_address").val(address);
	}
	
	var cache = {},
				lastXhr;
				
	$(".b-form__place_search_text_field").autocomplete({
		minLength: 5,
		source: function( request, response ) {
			var term = request.term,
				bounds = Gmaps4Rails.map.getBounds().getNorthEast().toUrlValue() + "|" + Gmaps4Rails.map.getBounds().getSouthWest().toUrlValue();
				
			request.bounds = bounds;
			
			lastXhr = $.getJSON( "/add_missing/address_suggest.json", request, function( data, status, xhr ) {
				if ( xhr === lastXhr ) {
					response( data );
				}
			});
		},
		select: function(event, ui) {
			var request = {
				address: ui.item.value
			}
			
			$.getJSON( "/add_missing/address_data.json", request, function( data, status, xhr ) {
				if ( data.matched_address ) {
					var marker = {
						lat: data.lat,
						lng: data.lng,
						title: [data.full_data.address_components[1].long_name, data.full_data.address_components[0].long_name].join(", ")
					}
					
					Gmaps4Rails.addMarkers( [marker] );
					
					add_place(data.matched_address);
										
				}
			});
		}
	});
})