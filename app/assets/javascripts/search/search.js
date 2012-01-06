$(function(){
	if( $('.p-search').length == 0 ) return;


	$('input[name=ages]').change(function(){
		var el = $('input[name=ages]:checked'),
			minimum_age = el.attr('minimum_age') || "",
			maximum_age = el.attr('maximum_age') || "";
		

		$('#search_minimum_age').val(minimum_age);
		$('#search_maximum_age').val(maximum_age);
	});

});