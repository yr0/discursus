(function(W, D, $){
    W.addTooltipster = function($elem) {
        // on which side of element the tooltipster must appear
        var side = $elem.data('tooltipster-side') || 'top',
            trigger = $elem.data('tooltipster-trigger') || 'hover',
            isInteractive = !!($elem.data('tooltipster-interactive') || false);
        $elem.tooltipster({
            IEmin: 9,
            interactive: isInteractive,
            theme: 'tooltipster-borderless',
            side: side,
            trigger: trigger
        });
    };

    D.addEventListener('turbolinks:load', function(){
        $.each($('.has-tooltipster:not(.tooltipstered)'), function(){
            addTooltipster($(this));
        });
    });
})(window, document, jQuery);
