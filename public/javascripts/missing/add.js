$(function(){
	submit_action = "next_step";
	
	$(".b-form__back_button").click(function(){
		submit_action = "previous_step";
	});
	
	$(".b-form__save_button").click(function(){
		$("[name='missing[save]']").val(1);
		submit_action = "save_step";
	});
	
	$("#new_missing")
		.bind("ajax:success", function(evt, data, status, xhr){
			if (submit_action == "save_step"){
				document.location = data.missing_url;
			} else {
				document.location = $(this).attr(submit_action);
			}
			
			
		});
});