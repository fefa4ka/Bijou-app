
// usage: log('inside coolFunc', this, arguments);
// paulirish.com/2009/log-a-lightweight-wrapper-for-consolelog/
window.log = function(){
  log.history = log.history || [];   // store logs to an array for reference
  log.history.push(arguments);
  if(this.console) {
      arguments.callee = arguments.callee.caller;
      console.log( Array.prototype.slice.call(arguments) );
  }
};
// make it safe to use console.log always
(function(b){function c(){}for(var d="assert,count,debug,dir,dirxml,error,exception,group,groupCollapsed,groupEnd,info,log,markTimeline,profile,profileEnd,time,timeEnd,trace,warn".split(","),a;a=d.pop();)b[a]=b[a]||c})(window.console=window.console||{});


// place any jQuery/helper plugins in here, instead of separate, slower script files.


/*-------------------------------------------------------------------- 
 * jQuery plugin: customInput()
 * by Maggie Wachs and Scott Jehl, http://www.filamentgroup.com
 * Copyright (c) 2009 Filament Group
 * Dual licensed under the MIT (filamentgroup.com/examples/mit-license.txt) and GPL (filamentgroup.com/examples/gpl-license.txt) licenses.
 * Article: http://www.filamentgroup.com/lab/accessible_custom_designed_checkbox_radio_button_inputs_styled_css_jquery/  
 * Usage example below (see comment "Run the script...").
--------------------------------------------------------------------*/

jQuery.fn.customInput = function(){
	$(this).each(function(i){	
        if( $(this).hasClass('b-form-custom-false') ) {
            return;
        }
        
		if($(this).is('[type=checkbox],[type=radio]')){
			var input = $(this);
			
			// get the associated label using the input's id
			var label = $('label[for='+input.attr('id')+']');
			
			//get type, for classname suffix 
			var inputType = (input.is('[type=checkbox]')) ? 'checkbox' : 'radio';
			
			// wrap the input + label in a div 
			$('<div class="b-form-'+ inputType +'"></div>').insertBefore(input).append(input, label);
			
			// find all inputs in this set using the shared name attribute
			var allInputs = $('input[name="'+input.attr('name')+'"]');
			
			// necessary for browsers that don't support the :hover pseudo class on labels
			label.hover(
				function(){ 
					$(this).addClass('hover'); 
					if(inputType == 'checkbox' && input.is(':checked')){ 
						$(this).addClass('checkedHover'); 
					} 
				},
				function(){ $(this).removeClass('hover checkedHover'); }
			);
			
			//bind custom event, trigger it, bind click,focus,blur events					
			input.bind('updateState', function(){	

				if (input.is(':checked')) {
					if (input.is(':radio')) {				
						allInputs.each(function(){
							$('label[for='+$(this).attr('id')+']').removeClass('checked');
						});		
					};
					label.addClass('checked');
					input.attr('checked', 'checked');
				}
				else { 
					label.removeClass('checked checkedHover checkedFocus'); 
					input.removeAttr('checked');
				}
										
			})
			.trigger('updateState')
			.click(function(){ 
				$(this).trigger('updateState'); 
			})
			.focus(function(){ 
				label.addClass('focus'); 
				if(inputType == 'checkbox' && input.is(':checked')){ 
					$(this).addClass('checkedFocus'); 
				} 
			})
			.blur(function(){ label.removeClass('focus checkedFocus'); });
		}
		else if($(this).is('[type=button],[type=submit],[button]')){
			$(this).button();
		}
	});
};

(function(a){var c=(a.browser.msie?"paste":"input")+".mask";var b=(window.orientation!=undefined);a.mask={definitions:{"9":"[0-9]",a:"[A-Za-z]","*":"[A-Za-z0-9]"}};a.fn.extend({caret:function(e,f){if(this.length==0){return}if(typeof e=="number"){f=(typeof f=="number")?f:e;return this.each(function(){if(this.setSelectionRange){this.focus();this.setSelectionRange(e,f)}else{if(this.createTextRange){var g=this.createTextRange();g.collapse(true);g.moveEnd("character",f);g.moveStart("character",e);g.select()}}})}else{if(this[0].setSelectionRange){e=this[0].selectionStart;f=this[0].selectionEnd}else{if(document.selection&&document.selection.createRange){var d=document.selection.createRange();e=0-d.duplicate().moveStart("character",-100000);f=e+d.text.length}}return{begin:e,end:f}}},unmask:function(){return this.trigger("unmask")},mask:function(j,d){if(!j&&this.length>0){var f=a(this[0]);var g=f.data("tests");return a.map(f.data("buffer"),function(l,m){return g[m]?l:null}).join("")}d=a.extend({placeholder:"_",completed:null},d);var k=a.mask.definitions;var g=[];var e=j.length;var i=null;var h=j.length;a.each(j.split(""),function(m,l){if(l=="?"){h--;e=m}else{if(k[l]){g.push(new RegExp(k[l]));if(i==null){i=g.length-1}}else{g.push(null)}}});return this.each(function(){var r=a(this);var m=a.map(j.split(""),function(x,y){if(x!="?"){return k[x]?d.placeholder:x}});var n=false;var q=r.val();r.data("buffer",m).data("tests",g);function v(x){while(++x<=h&&!g[x]){}return x}function t(x){while(!g[x]&&--x>=0){}for(var y=x;y<h;y++){if(g[y]){m[y]=d.placeholder;var z=v(y);if(z<h&&g[y].test(m[z])){m[y]=m[z]}else{break}}}s();r.caret(Math.max(i,x))}function u(y){for(var A=y,z=d.placeholder;A<h;A++){if(g[A]){var B=v(A);var x=m[A];m[A]=z;if(B<h&&g[B].test(x)){z=x}else{break}}}}function l(y){var x=a(this).caret();var z=y.keyCode;n=(z<16||(z>16&&z<32)||(z>32&&z<41));if((x.begin-x.end)!=0&&(!n||z==8||z==46)){w(x.begin,x.end)}if(z==8||z==46||(b&&z==127)){t(x.begin+(z==46?0:-1));return false}else{if(z==27){r.val(q);r.caret(0,p());return false}}}function o(B){if(n){n=false;return(B.keyCode==8)?false:null}B=B||window.event;var C=B.charCode||B.keyCode||B.which;var z=a(this).caret();if(B.ctrlKey||B.altKey||B.metaKey){return true}else{if((C>=32&&C<=125)||C>186){var x=v(z.begin-1);if(x<h){var A=String.fromCharCode(C);if(g[x].test(A)){u(x);m[x]=A;s();var y=v(x);a(this).caret(y);if(d.completed&&y==h){d.completed.call(r)}}}}}return false}function w(x,y){for(var z=x;z<y&&z<h;z++){if(g[z]){m[z]=d.placeholder}}}function s(){return r.val(m.join("")).val()}function p(y){var z=r.val();var C=-1;for(var B=0,x=0;B<h;B++){if(g[B]){m[B]=d.placeholder;while(x++<z.length){var A=z.charAt(x-1);if(g[B].test(A)){m[B]=A;C=B;break}}if(x>z.length){break}}else{if(m[B]==z[x]&&B!=e){x++;C=B}}}if(!y&&C+1<e){r.val("");w(0,h)}else{if(y||C+1>=e){s();if(!y){r.val(r.val().substring(0,C+1))}}}return(e?B:i)}if(!r.attr("readonly")){r.one("unmask",function(){r.unbind(".mask").removeData("buffer").removeData("tests")}).bind("focus.mask",function(){q=r.val();var x=p();s();setTimeout(function(){if(x==j.length){r.caret(0,x)}else{r.caret(x)}},0)}).bind("blur.mask",function(){p();if(r.val()!=q){r.change()}}).bind("keydown.mask",l).bind("keypress.mask",o).bind(c,function(){setTimeout(function(){r.caret(p(true))},0)})}p()})}})})(jQuery);                     

jQuery.fn.nl2br = function(){
   return this.each(function(){
     jQuery(this).val().replace(/(<br>)|(<br \/>)|(<p>)|(<\/p>)/g, "\r\n");
   });
};


/* 
 *	autocomplete_input plugin
 */

$(function() {
(function( $ ) {
    $.widget( "ui.combobox", {
        options: {
            combobox_class: "",
            input_disabled: false
        },
        _create: function() {
            var self = this,
                select = this.element.hide(),
                selected = select.children( ":selected" ),
                value = selected.val() ? selected.text() : "",
                input = this.input = $( "<input>" )
                .insertAfter( select )
                .val( value )
                .autocomplete({
                    delay: 0,
                    minLength: 0,
                    source: function( request, response ) {
                        var matcher = new RegExp( $.ui.autocomplete.escapeRegex(request.term), "i" );
                        response( select.children( "option" ).map(function() {
                            var text = $( this ).text();
                            if ( this.value && ( !request.term || matcher.test(text) ) )
                                return {
                                    label: text.replace(
                                        new RegExp(
                                            "(?![^&;]+;)(?!<[^<>]*)(" +
                                            $.ui.autocomplete.escapeRegex(request.term) +
                                            ")(?![^<>]*>)(?![^&;]+;)", "gi"
                                        ), "<strong>$1</strong>" ),
                                    value: text,
                                    option: this
                                };
                        }) );
                    },
                    select: function( event, ui ) {
                        ui.item.option.selected = true;
                        self._trigger( "selected", event, {
                            item: ui.item.option
                        });
                        log('select');
                    },
                    change: function( event, ui ) {
                        log('change');
                        if ( !ui.item ) {
                            var matcher = new RegExp( "^" + $.ui.autocomplete.escapeRegex( $(this).val() ) + "$", "i" ),
                                valid = false;
                            select.children( "option" ).each(function() {
                                if ( $( this ).text().match( matcher ) ) {
                                    this.selected = valid = true;
                                    return false;
                                }
                            });
                            if ( !valid ) {
                                // remove invalid value, as it didn't match anything
                                $( this ).val( "" );
                                select.val( "" );
                                input.data( "autocomplete" ).term = "";
                                return false;
                            }
                        }
                    }
                })
                .addClass( "ui-widget ui-widget-content " + this.options.combobox_class );

                function showOptions() {
                    // close if already visible
                    if ( input.autocomplete( "widget" ).is( ":visible" ) ) {
                        input.autocomplete( "close" );
                        log('close');
                        return;
                    }

                    // work around a bug (likely same cause as #5265)
                    $( this ).blur();

                    // pass empty string as value to search for, displaying all results
                    input.autocomplete( "search", "" );
                    input.focus();
                    log('create');
                };

            input.data( "autocomplete" )._renderItem = function( ul, item ) {
                return $( "<li></li>" )
                    .data( "item.autocomplete", item )
                    .append( "<a>" + item.label + "</a>" )
                    .appendTo( ul );
            };

            this.button = $( "<button type='button'>&nbsp;</button>" )
                .attr( "tabIndex", -1 )
                .attr( "title", "Show All Items" )
                .insertAfter( input )
                .button()
                .removeClass( "ui-corner-all" )
                .addClass( "ui-button-icon ui-dropdown-button-input " + this.options.combobox_class )
                .click(showOptions);

            if( this.options.input_disabled ) {
                this.button.unbind('click');
                input.attr('readonly','readonly')
                     .css('cursor', 'pointer')
                     .parent()
                     .click(showOptions);
            }


        },

        destroy: function() {
            this.input.remove();
            this.button.remove();
            this.element.show();
            $.Widget.prototype.destroy.call( this );
        }
    });
})( jQuery );

});
