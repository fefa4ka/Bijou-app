$(function(){
	if( $(".p-report").length == 0 ) return;

    function render_report() {  
		$('input[name=report_type]').each(function() {
		  	var type = $(this).val();    
			if( $(this).attr('checked') ) {
				$('.b-report__list .element').hide();      
				switch(type){
					case 'all':
						$('.b-report__list .element').show();   
						$('.b-report__list .element.Message.sent').hide(); 

						break;

					case 'messages':
						$('.b-report__list .element.Message.received').show(); 
						break; 

					case 'sent':
						$('.b-report__list .element.Message.sent').show(); 
						break;

					case 'seen':
						$('.b-report__list .element.SeenTheMissing').show(); 
						break;
                    
                    case 'can_help':
                        $('.b-report__list .element.CanHelp').show(); 
                        break;
				}  
			}
		});    
	}
	                                           
	// Выбор типов сводки
	$('input[name=report_type]').change(render_report).trigger('change');
   
});
