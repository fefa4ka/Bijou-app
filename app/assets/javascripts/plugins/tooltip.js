(function($) {
    // Настройки поумолчанию
    var defaults = {
        content: 'Tooltip example',
        tooltipCl: 'b-tooltip',
        tooltipTailCl: 'b-tooltip__tail',
        tooltipContentCl: 'b-tooltip__content',
        toggleOnClick: false

    },
        options = {},
        opts = $.extend(defaults, options),
        methods = {
            init: function(options) {
                return this.each(function(i) {
                    if ($(this).attr('tooltip')) {
                        return true;
                    }

                    var tooltip = methods.createTooltip.apply(this);

                });
            },
            toggle: function() {
                if ($(this).attr('tooltip')) {
                    var tooltip = $('#' + $(this).attr('tooltip'));
                    tooltip.toggle();
                    methods.positioning.apply(this, [tooltip]);
                } else {
                    methods.createTooltip.apply(this);
                }
            },
            positioning: function(tooltip) {
                var space = {
                    height: $(window).height(),
                    width: $(window).width(),
                    top: $(window).scrollTop(),
                    left: $(window).scrollLeft()
                },
                    element = {
                        height: $(this).height(),
                        width: $(this).width(),
                        top: $(this).offset().top,
                        left: $(this).offset().left,
                    },
                    tailPosition;

                switch (true) {
                case ((space.top + space.height) - (element.top + element.height) > 0) && ((space.left + space.width) - (element.left + element.width + tooltip.width()) > 0):
                    tailPosition = 'left';
                    tooltip.css('top', element.top + element.height / 2 - tooltip.height() / 2).css('left', element.left + element.width);
                    break;

                case ((element.top - tooltip.height()) > space.top) && ((space.left + space.width) - (element.left + element.width / 2 + tooltip.width())):
                    tailPosition = 'bottom';
                    tooltip.css('top', element.top - tooltip.height()).css('left', element.left + element.width / 2);
                    break;

                case (element.top + element.height + tooltip.height() < space.top + space.height):
                    tailPosition = 'top';
                    tooltip.css('top', element.top + element.height).css('left', element.left);
                    break;
                }

                tooltip.removeClass('top left bottom right').addClass(tailPosition);
            },
            createTooltip: function() {
                var id = new Date().getTime()
                	tail = $('<i/>').addClass(opts['tooltipTailCl'] + '_border').append($('<b/>').addClass(opts['tooltipTailCl'])),
                    content = $('<div/>').addClass(opts['tooltipContentCl']).html(opts['content']),
                    tooltip = $('<div/>').html('').addClass(opts['tooltipCl']).attr('id', id).append(tail).append(content),
                    tailPosition = opts['tailPosition'];

                // Помечаем, что тултип уже создан для этого элемента
                $(this).attr('tooltip', id);
                $('body').append(tooltip);

                methods.positioning.apply(this, [tooltip]);
                return tooltip;
            }

        }

        $.fn.tooltip = function(method) {
            opts = $.extend(opts, options);


            if (methods[method]) {
                return methods[method].apply(this, Array.prototype.slice.call(arguments, 1));
            } else if (typeof method === 'object' || !method) {
                methods.init.apply(this, arguments);
            } else {
                $.error('Method ' + method + '')
            }
        }
})(jQuery);
