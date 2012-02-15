$(function(){
	if( $(".p-edit-user").length == 0 ) return;
    var validate = {
            errorClass: 'b-tooltip-error',
            debug: true,
            rules: {
                "user[name]": { required: true, minlength: 3 },
                "user[email]": { required: true, email: true },
                "user[old_password]": { required: true },
                "user[password]": { required: true },
                "user[password_confirmation]": { equalTo: ".edit_user input[name='user[password]']" }
            }
        };

   	$('.edit_user')
		.live('ajax:beforeSend', function(e){
			
		})
		.live('ajax:success', function(evt, data, status, xhr){    
     		$('.b-form__save_complete_notification label').show('highlight', {}, 500);
		})
        .validate(validate);

	$('#user_phone').mask("+7 999 999-99-99");

	$('.p-user__change_password').click(function() {
		$('.p-edit-user__change_password_container').toggle();
	})
});