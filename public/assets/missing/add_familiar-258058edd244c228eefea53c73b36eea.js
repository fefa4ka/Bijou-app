$(function(){function a(){return $(".b-form__add_familiar").hide(),$(".b-form__familiar").show(),$(".b-form__add_familiar .b-form__field input[type=text], .b-form__add_familiar .b-form__field textarea").val(""),$(".b-form__add_familiar .b-form__field input[type=checkbox], .b-form__add_familiar .b-form__field input[type=radio]").removeAttr("checked").trigger("updateState"),$(".b-form__add_familiar .b-form__field input[type=checkbox]").val(0).trigger("updateState"),$(window).scrollTop($(".b-form__familiars").offset().top+$(".b-form__familiars").height()),!1}$(".b-form__open_familiar_fields").click(function(){$(".b-form__familiar").hide(),$(".b-form__add_familiar").show(),$(window).scrollTop($(".b-form__add_familiar").offset().top)}),$(".b-form__add_familiar_button").click(function(){var b=(new Date).getTime(),c=".b-form__add_familiar_",d=["name","relations:checked","relations_quality:checked","relations_tense_description","description","seen_last_day"],e=$("<div></div>").addClass("b-form__field b-form__familiar").append($("<div></div>").addClass("b-form__label").text($(c+d[0]).val())).append($("<p></p>").text($(c+d[1]).val())).append($("<p></p>").html("Напряженные отношения:<br>"+$(c+d[3]).val()).addClass("familiar_description_"+b).hide()).append($("<p></p>").text($(c+d[4]).val()));add_hidden_fields(e,c,d),$(".b-form__familiars").append(e),a({clear_search_field:!0}),redirect_disallow=!0,$("#new_missing").submit()}),$(".b-form__add_familiar_button_cancel").click(a),$(".b-form__add_familiar_relations_quality").bind("updateState",function(){var a=$(this).val();a==2?$(".b-form__add_familiar_relations_tense_description_field").show():$(".b-form__add_familiar_relations_tense_description_field").hide()})})