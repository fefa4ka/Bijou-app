$(function(){
	var cache = {},
				lastXhr;
				
	$(".b-form__place_search_text_field").autocomplete({
		minLength: 2,
		source: function( request, response ) {
			var term = request.term,
				bounds = Gmaps4Rails.map.getBounds().getNorthEast().toUrlValue() + "|" + Gmaps4Rails.map.getBounds().getSouthWest().toUrlValue();
				
			request.bounds = bounds;

			
			lastXhr = $.getJSON( "/add_missing/address_suggest.json", request, function( data, status, xhr ) {
				if ( xhr === lastXhr ) {
					response( data );
				}
			});
		}
	});
})