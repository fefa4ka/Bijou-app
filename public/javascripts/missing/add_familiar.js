$(function() {
	function hide_familiar()
	{
		$(".b-form__add_familiar").hide();
		$(".b-form__familiar").show();
		
		// Чистим поля
		$(".b-form__add_familiar .b-form__field input[type=text], .b-form__add_familiar .b-form__field textarea").val("");
		
		/*
			TODO Сделать очистку чекбоксов и радиобаттонов
		*/
		$(".b-form__add_familiar .b-form__field input[type=checkbox], .b-form__add_familiar .b-form__field input[type=radio]").removeAttr("checked").trigger("updateState");
		$(".b-form__add_familiar .b-form__field input[type=checkbox]").val(0).trigger("updateState");
		
		// Скроллим, чтобы не скакал экран
		$(window).scrollTop( $(".b-form__familiars").offset().top + $(".b-form__familiars").height() );
		
		// Для ссылки
		return false;
	}
	
	$(".b-form__open_familiar_fields").click( function() {
		$(".b-form__familiar").hide();
		$(".b-form__add_familiar").show();
		
		/*
			TODO Сделать ненавязчивый скрол
		*/
		$(window).scrollTop( $(".b-form__add_familiar").offset().top );
	
		
	});
	
	$(".b-form__add_familiar_button").click( function() {
		var name_field = $(".b-form__add_familiar_name"),
			relations_field = $(".b-form__add_familiar_relations:checked") || "",
			relations_quality_field = $(".b-form__add_familiar_relations_quality:checked") || "",
			relations_description_field = $(".b-form__add_familiar_relations_tense_description"),
			description_field = $(".b-form__add_familiar_description"),
			seen_last_day_field = $(".b-form__add_familiar_seen_last_day")
			new_id = new Date().getTime(),
			element = $("<div></div>")
						.addClass("b-form__field b-form__familiar")
						.append( $("<div></div>")
							.addClass("b-form__label")
								.text( name_field.val() )
						)
						.append( $("<p></p>")
							.text( relations_field.val() )
						)
						.append( $("<p></p>")
							.html("Напряженные отношения:<br>" + relations_description_field.val() )
							.addClass("familiar_description_" + new_id )
							// Если нужно, потом покажем
							.hide()
						)
						.append( $("<p></p>")
							.text( description_field.val() )
						)
						// Создаем поля
						.append( $("<input type=hidden />")
							.attr( "name", name_field.attr("name").replace(/[0-9]+/i, new_id) )
							.val( name_field.val() )
						)
						.append( $("<input type=hidden />")
							.attr( "name", relations_field.attr("name").replace(/[0-9]+/i, new_id) )
							.val( relations_field.val() )
						)
						.append( $("<input type=hidden />")
							.attr( "name", relations_quality_field.attr("name").replace(/[0-9]+/i, new_id) )
							.val( relations_quality_field.val() )
						)
						.append( $("<input type=hidden />")
							.attr( "name", relations_description_field.attr("name").replace(/[0-9]+/i, new_id) )
							.val( relations_description_field.val() )
						)
						.append( $("<input type=hidden />")
							.attr( "name", description_field.attr("name").replace(/[0-9]+/i, new_id) )
							.val( description_field.val() )
						)
						.append( $("<input type=hidden />")
							.attr( "name", seen_last_day_field.attr("name").replace(/[0-9]+/i, new_id) )
							.val( seen_last_day_field.val() )
						);
						
		$(".b-form__familiars").append( element );
		
		hide_familiar( { clear_search_field: true } );
		
		// Сохраняем добавленное место
		redirect_disallow = true;
		$("#new_missing").submit();	
	});
	
	$(".b-form__add_familiar_button_cancel").click( hide_familiar );
	
	$(".b-form__add_familiar_relations_quality").bind("updateState", function() {
		var value = $(this).val();
		
		if( value == 2 ) {
			$(".b-form__add_familiar_relations_tense_description_field").show();
		} else {
			$(".b-form__add_familiar_relations_tense_description_field").hide();
		}
		
	});
});