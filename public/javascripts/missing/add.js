$(function(){
	var submit_action,
		selected_step,
		redirect_disallow;
		
	$(".b-form__next_button").click(function(){
		submit_action = "next_step";
	});
		
	$(".b-form__back_button").click(function(){
		submit_action = "previous_step";
	});
	
	$(".b-form__save_button").click(function(){
		$("#save").val(1);
		submit_action = "save_step";
	});
	
	$("#new_missing")
		.bind("ajax:success", function(evt, data, status, xhr){
			/*
				TODO Переделать кривой непереход
			*/
			if ( redirect_disallow ) {
				redirect_disallow = false;
				return false;
			}
			
			if ( submit_action == "save_step" ){
				document.location = data.missing_url;
			} else if ( submit_action ) {
				document.location = $(this).attr(submit_action);
			} else if ( selected_step ) {
				document.location = selected_step;
			}
	}).keydown(function( event ) {
		if( event.keyCode == 13 ) {
			$('.b-form__next_button').click();
			
			return false;
		} 
	});
	
	$('.missing_step').click( function() {
		$("#new_missing").submit();
		selected_step = $(this).attr("href");
		
		return false;
	})
});