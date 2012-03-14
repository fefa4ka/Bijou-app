$(function(){
	if( $('.p-search').length == 0 ) return;  
	
    $('select[class!=b-form-custom-false]').combobox({ input_disabled: true });    

	$('input[name=ages]').change(function(){
		var el = $('input[name=ages]:checked'),
			minimum_age = el.attr('minimum_age') || "",
			maximum_age = el.attr('maximum_age') || "";
		

		$('#search_minimum_age').val(minimum_age);
		$('#search_maximum_age').val(maximum_age);
	});        
	
	// Ajax
	$('#new_search input[type=submit]').click(function() {
		$('#search_page').val(1); 
	});
	
	$('#new_search').submit(function () {
	    $.get(this.action, $(this).serialize(), null, 'script');
	    return false;
    });
            
	$('.b-search-result__more_button').click(function() { 
		if(typeof page == 'undefined') { 
			page = 2 
		} else { 
			page++; 
		}
		
		$('#search_page').val(page);    
		$('#new_search').submit();
	} );
});
