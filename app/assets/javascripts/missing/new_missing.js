$(function(){
	var form = $("#new_missing"),
        submit_action,
		selected_step,
		redirect_disallow,
        validate = {
            errorClass: 'b-tooltip-error',
            debug: true,
            rules: {
                "missing[name]": { required: true },
                "missing[gender]": { required: true },
                "missing[birthday(1i)]": { required: true },
                "missing[user_attributes][name]": { required: true },
                "missing[user_attributes][email]": { required: true, email: true },
                "missing[user_attributes][phone]": { required: true },
                "missing[user_attributes][password]": { required: true }
            }
        };
	
	if( $(".p-new-missing").length == 0 ) return; 

    $('.b-new-missing-form[data-step!=' + current_step + ']').hide(); 

    function change_step(next_step) {
        function show_buttons(step) {
            for(var i = 0; i < steps.length; i++) {
                if( step == steps[i] ) break;
            }
            log('step i:', step, i);

            if( i == 0 ) {
                $('.b-form__back_button').hide();	    
                $('.b-form__next_button').show();	
                $('.b-form__save_button').hide();	
            } else if( i > 0 && i < steps.length - 1 ) {
                $('.b-form__back_button').show();	    
                $('.b-form__next_button').show();	
                $('.b-form__save_button').hide();	
            } else if( i == steps.length - 1 ) {
                $('.b-form__back_button').show();	    
                $('.b-form__next_button').hide();	
                $('.b-form__save_button').show();	
            }

        }

    	var steps = ["common", "history", "contacts"],
    		current_step_container = $('.b-new-missing-form[data-step=' + current_step + ']'),
    		next_step_container,
    		direction,
    		position = current_step_container.offset(),
            step_container = $('.b-new-missing-form-container');
    	
    	position.left = current_step_container.width();
    	
    	for(var i = 0; i < steps.length; i++) {
    		if( next_step == steps[i] ) {
    			direction = "left";

    			break;
    		}
    		if( current_step == steps[i] ) {
    			next_step = next_step ? next_step : steps[i+1];
                
                direction = next_step == -1 ? "left" : "right";

				next_step = next_step == -1 ? steps[i-1] : next_step;
    			
    			break;
    		}
    	}	    	

        if( direction == "left" ) {
            form.validate().cancelSubmit = true;        
            form.submit();

	    	position.left = position.left * -1;
	    } else {
            if( !form.valid() ){
                return;
            }
        }

        show_buttons(next_step);
        $('.b-form__nav_element').removeClass('b-form__nav_current_element');
        $('.b-form__nav_element[data-step=' + next_step + ']').addClass('b-form__nav_current_element');


	    next_step_container = $('.b-new-missing-form[data-step=' + next_step + ']');

	    next_step_container.css('position', 'relative')
            .css('top', 0)
	    	.css('left', position.left)
            .css('width', 0);
	    
	    current_step_container
	 		.hide();
	 	
	 	next_step_container.css('width', 0).show()
	    	.animate({ left: 0, width: $(window).width() }, { queue: false, duration: 500 }, 'linear', function(){ log(form); form.validate().resetForm() } ); 

        $(window).scrollTop( $('.p-new-missing__header').offset().top );
	    current_step = next_step;
        

        log(form, form.validate());
        form.validate().resetForm();
    }

    function next_step() {
        form.submit();

    	change_step();
    }

    function prev_step() {
    	change_step(-1);
    }

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
        e.preventDefault();

		next_step();
	});
		
	$(".b-form__back_button").click(function(e){
        e.preventDefault();

        prev_step();
	});
	
	$(".b-form__save_button").click(function(){
		$("#save").val(1);
		submit_action = "save_step";
		
		form.submit();
		return false;
	});
	
	form
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
			}
			
			// Обновляем фотки
			if (data.data_type == "photos") {
				update_photos(data.data);
			}
			
        })
        .validate(validate);
	
	$('.missing_step').click( function(e) {
        e.preventDefault();
        form.validate().cancelSubmit = true;                
		form.submit();

		selected_step = $(this).parent().attr("data-step");

		change_step(selected_step);
		return false;
	});
	
	$(".b-form__photos input[type=file]").change(function(){   
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
	        if (!((n == 8)              // backspae
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
