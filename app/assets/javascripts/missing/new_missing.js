$(function(){
	var submit_action,
		selected_step,
		redirect_disallow,
        validate = {
            errorClass: 'b-tooltip-error',
            rules: {
                "missing[name]": { required: true, minlenght: 3 },
                "missing[gender]": { required: true },
                "missing[birthday(1i)]": { required: true },
                "missing[user_attributes][name]": { required: true },
                "missing[user_attributes][email]": { required: true, email: true },
                "missing[user_attributes][phone]": { required: true },
                "missing[user_attributes][password]": { required: true }
            }
        };
	
	if( $(".p-new-missing").length == 0 ) return; 

	$('#missing_user_attributes_phone').mask("+7 999 999-99-99");
		
	function update_photos(data){
		var filefield = $('input[name$="[photo]"]'),
			new_id = new Date().getTime();
		
		$('.b-form__photo, .b-form__photo_loading').remove();
		
		filefield
			.val("")
			.attr('name', filefield.attr("name").replace(/[0-9]+/i, new_id) );
		
		for(id in data) {
			var element = data[id],
				name = 'missing[photos_attributes][' + element.id + ']';
			
			$('.b-form__photos')
				.append( 
					$('<li/>')
						.addClass('b-form__photo')
						.append( 
							$('<img/>')
								.attr('src', element.image_name)
								.addClass('b-form__photo')
						)
						.append(
							$('<input/>')
								.attr('type', 'button')
								.addClass('b-form__photo_delete red_action destroy')
								.val('удалить')
								.button()
						)
						
			);
		}
	}         
	
	$(".b-form__next_button").click(function(){
		submit_action = "next_step";
	});
		
	$(".b-form__back_button").click(function(){
		submit_action = "previous_step";
	});
	
	$(".b-form__save_button").click(function(){
		$("#save").val(1);
		submit_action = "save_step";
		
		$("#new_missing").submit();
		return false;
	});
	
	$("#new_missing")
		.bind("ajax:beforeSend", function(e, xhr, settings){      
			if ( submit_action == "upload_photo")
			{      
				$("#upload_photo").val(0); 
			    submit_action = "";                          
				$('.b-form__photos')
					.append( 
						$('<li/>')
							.addClass('b-form__photo_loading')
					);   
			}
		})
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
			} else if ( submit_action && submit_action != "upload_photo") {
				document.location = $(this).attr(submit_action);
			} else if ( selected_step ) {
				document.location = selected_step;
			}
			
			// Обновляем фотки
			if (data.data_type == "photos") {
				update_photos(data.data);
			}
			
        })
        .validate(validate);
	
	$('.missing_step').click( function() {
		$("#new_missing").submit();
		selected_step = $(this).attr("href");
		
		return false;
	});
	
	$(".b-form__photos input[type=file]").change(function(){   
        var form = $("#new_missing");
		submit_action = "upload_photo";
		$("#upload_photo").val(1);
        form.validate().cancelSubmit = true;        
            form.submit();
	});
	
   
 
	// Удаляем фотографию 
	$(".b-form__photo .destroy").live('click', function(){

		$(this).toggle(function(){	
			$(this)
				.val('восстановить')
				.removeClass('red_action').addClass('silver_action')
			.parent()
				.removeClass('active').addClass('deleted')
			.children('input[name$="[_destroy]"]')
				.val(1);
		},
		function(){
			$(this)
				.val('удалить')
				.removeClass('silver_action').addClass('red_action')
			.parent()
				.removeClass('deleted').addClass('active')
			.children('input[name$="[_destroy]"]')
				.val(0);
		}).trigger('click');
	});
	                            
	
	// Только числа, там где только числа
	$('.b-form__text_age, .b-form__text_growth').keydown(function (e) {
	    if (e.shiftKey || e.ctrlKey || e.altKey) { // if shift, ctrl or alt keys held down
	        e.preventDefault();         // Prevent character input
	    } else {
	        var n = e.keyCode;
	        if (!((n == 8)              // backspace
			|| (n == 9)					// tab
	        || (n == 46)                // delete
	        || (n >= 35 && n <= 40)     // arrow keys/home/end
	        || (n >= 48 && n <= 57)     // numbers on keyboard
	        || (n >= 96 && n <= 105))   // number on keypad
	        ) {
	            e.preventDefault();     // Prevent character input
	        }
	    }
	});
	     
	// Обрабатываем изменение возраста
	$('.b-form__text_age').keyup(function (e) {
		var year = new Date().getFullYear(),
			age = $(this).val(),
			value = year - age,
			sign = 'год';
			
		$("#missing_birthday_1i").val(value);
		$(".man_age_sign").text(pluralForm(age, 'год', 'года', 'лет'));
	});  
	
	$('#missing_birthday_1i').change(function() { 
		var value = $(this).val() * 1,
			year = new Date().getFullYear(); 
		
		if (value > 0) $('.b-form__text_age').val(year - value); 
	});

});

function add_hidden_fields(element, prefix, fields)
{
	var new_id = new Date().getTime();

	for(id in fields) {
		var field = $(prefix + fields[id]),
			new_name;
		
		if (field.attr('name')) {
			new_name = field.attr('name').replace(/[0-9]+/i, new_id);      
		}
		
		element.append( $('<input type=hidden />')
		 					.attr("name", new_name)
							.val(field.val().replace(/\r\n|\r|\n/g,"<br />"))
		);
	}
	
	return element;
}
