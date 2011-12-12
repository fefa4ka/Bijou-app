// usage: log('inside coolFunc', this, arguments);
// paulirish.com/2009/log-a-lightweight-wrapper-for-consolelog/
window.log=function(){log.history=log.history||[],log.history.push(arguments),this.console&&(arguments.callee=arguments.callee.caller,console.log(Array.prototype.slice.call(arguments)))},function(a){function b(){}for(var c="assert,count,debug,dir,dirxml,error,exception,group,groupCollapsed,groupEnd,info,log,markTimeline,profile,profileEnd,time,timeEnd,trace,warn".split(","),d;d=c.pop();)a[d]=a[d]||b}(window.console=window.console||{}),jQuery.fn.customInput=function(){$(this).each(function(a){if($(this).is("[type=checkbox],[type=radio]")){var b=$(this),c=$("label[for="+b.attr("id")+"]"),d=b.is("[type=checkbox]")?"checkbox":"radio";$('<div class="b-form-'+d+'"></div>').insertBefore(b).append(b,c);var e=$('input[name="'+b.attr("name")+'"]');c.hover(function(){$(this).addClass("hover"),d=="checkbox"&&b.is(":checked")&&$(this).addClass("checkedHover")},function(){$(this).removeClass("hover checkedHover")}),b.bind("updateState",function(){b.is(":checked")?(b.is(":radio")&&e.each(function(){$("label[for="+$(this).attr("id")+"]").removeClass("checked")}),c.addClass("checked"),b.attr("checked","checked")):(c.removeClass("checked checkedHover checkedFocus"),b.removeAttr("checked"))}).trigger("updateState").click(function(){$(this).trigger("updateState")}).focus(function(){c.addClass("focus"),d=="checkbox"&&b.is(":checked")&&$(this).addClass("checkedFocus")}).blur(function(){c.removeClass("focus checkedFocus")})}else $(this).is("[type=button],[type=submit],[button]")&&$(this).button()})},function(a){var b=(a.browser.msie?"paste":"input")+".mask",c=window.orientation!=undefined;a.mask={definitions:{9:"[0-9]",a:"[A-Za-z]","*":"[A-Za-z0-9]"}},a.fn.extend({caret:function(a,b){if(this.length==0)return;if(typeof a=="number")return b=typeof b=="number"?b:a,this.each(function(){if(this.setSelectionRange)this.focus(),this.setSelectionRange(a,b);else if(this.createTextRange){var c=this.createTextRange();c.collapse(!0),c.moveEnd("character",b),c.moveStart("character",a),c.select()}});if(this[0].setSelectionRange)a=this[0].selectionStart,b=this[0].selectionEnd;else if(document.selection&&document.selection.createRange){var c=document.selection.createRange();a=0-c.duplicate().moveStart("character",-1e5),b=a+c.text.length}return{begin:a,end:b}},unmask:function(){return this.trigger("unmask")},mask:function(d,e){if(!d&&this.length>0){var f=a(this[0]),g=f.data("tests");return a.map(f.data("buffer"),function(a,b){return g[b]?a:null}).join("")}e=a.extend({placeholder:"_",completed:null},e);var h=a.mask.definitions,g=[],i=d.length,j=null,k=d.length;return a.each(d.split(""),function(a,b){b=="?"?(k--,i=a):h[b]?(g.push(new RegExp(h[b])),j==null&&(j=g.length-1)):g.push(null)}),this.each(function(){function o(a){while(++a<=k&&!g[a]);return a}function p(a){while(!g[a]&&--a>=0);for(var b=a;b<k;b++)if(g[b]){l[b]=e.placeholder;var c=o(b);if(c<k&&g[b].test(l[c]))l[b]=l[c];else break}u(),f.caret(Math.max(j,a))}function q(a){for(var b=a,c=e.placeholder;b<k;b++)if(g[b]){var d=o(b),f=l[b];l[b]=c;if(d<k&&g[d].test(f))c=f;else break}}function r(b){var d=a(this).caret(),e=b.keyCode;m=e<16||e>16&&e<32||e>32&&e<41,d.begin-d.end!=0&&(!m||e==8||e==46)&&t(d.begin,d.end);if(e==8||e==46||c&&e==127)return p(d.begin+(e==46?0:-1)),!1;if(e==27)return f.val(n),f.caret(0,v()),!1}function s(b){if(m)return m=!1,b.keyCode==8?!1:null;b=b||window.event;var c=b.charCode||b.keyCode||b.which,d=a(this).caret();if(b.ctrlKey||b.altKey||b.metaKey)return!0;if(c>=32&&c<=125||c>186){var h=o(d.begin-1);if(h<k){var i=String.fromCharCode(c);if(g[h].test(i)){q(h),l[h]=i,u();var j=o(h);a(this).caret(j),e.completed&&j==k&&e.completed.call(f)}}}return!1}function t(a,b){for(var c=a;c<b&&c<k;c++)g[c]&&(l[c]=e.placeholder)}function u(){return f.val(l.join("")).val()}function v(a){var b=f.val(),c=-1;for(var d=0,h=0;d<k;d++)if(g[d]){l[d]=e.placeholder;while(h++<b.length){var m=b.charAt(h-1);if(g[d].test(m)){l[d]=m,c=d;break}}if(h>b.length)break}else l[d]==b[h]&&d!=i&&(h++,c=d);if(!a&&c+1<i)f.val(""),t(0,k);else if(a||c+1>=i)u(),a||f.val(f.val().substring(0,c+1));return i?d:j}var f=a(this),l=a.map(d.split(""),function(a,b){if(a!="?")return h[a]?e.placeholder:a}),m=!1,n=f.val();f.data("buffer",l).data("tests",g),f.attr("readonly")||f.one("unmask",function(){f.unbind(".mask").removeData("buffer").removeData("tests")}).bind("focus.mask",function(){n=f.val();var a=v();u(),setTimeout(function(){a==d.length?f.caret(0,a):f.caret(a)},0)}).bind("blur.mask",function(){v(),f.val()!=n&&f.change()}).bind("keydown.mask",r).bind("keypress.mask",s).bind(b,function(){setTimeout(function(){f.caret(v(!0))},0)}),v()})}})}(jQuery),jQuery.fn.nl2br=function(){return this.each(function(){jQuery(this).val().replace(/(<br>)|(<br \/>)|(<p>)|(<\/p>)/g,"\r\n")})}