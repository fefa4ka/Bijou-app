$(function()
{
	$('button, input[type=submit], input[type=button]').button();
	$('.b-head__login').click(function()
	{
		$('.b-head__login_form').dialog({
			width: 350,
			height: 240,
			modal: true,
			resizable: false,
			draggable: false
		})
	})
})