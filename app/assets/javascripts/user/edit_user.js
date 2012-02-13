$(function(){
	if( $(".p-edit-user").length == 0 ) return;

	$('#user_phone').mask("+7 999 999-99-99");

	$('.p-user__change_password').click(function() {
		$('.p-edit-user__change_password_container').toggle();
	})
});