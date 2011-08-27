$(function()
{
	$('input').customInput();
	$('.b-head__login').click(function()
	{
		$('.b-head__login_form').dialog({
			width: 350,
			height: 246,
			modal: true,
			resizable: false,
			draggable: false,
			closeOnOverlayClick: true
		})
	})
})