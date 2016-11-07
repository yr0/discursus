// There can only be one spinner within a div - sibling spinners will not work
(function(W, D, $){
    var spinnerDisplayMinTime = 1000; // display spinner for a minimum of 1 second
    $(D).on('turbolinks:load', function() {
        $('body').on('ajax:before', '[data-with-ajax-spinner]', function() {
            displaySpinner.apply(this);
        }).on('ajax:templateLoaded', '[data-with-ajax-spinner]', function(_event, data) {
            hideSpinner.call(this, data.templateContainer);
        });
    });

    function displaySpinner() {
        var $spinner = $(this).siblings('.dsc-spinner:first'),
            spinnerStarted = Date.now(),
            elementTopPosition = $(this).position().top;
        hide($(this));
        if (!$spinner.length) {
            $spinner = $('#dscSpinnerTemplate').clone().insertBefore($(this));
            //apply the scale property so that initial animation is fired
            W.getComputedStyle($spinner.get(0)).getPropertyValue('transform');
        }
        // save start spinner time in order to hide it at least after spinnerDisplayMinTime milliseconds
        // set spinner position
        $spinner.attr('id', 'spinner' + spinnerStarted).css({ position: 'absolute', top: elementTopPosition });
        $(this).data('spinner-started', spinnerStarted);
        show($spinner);
    }

    function hideSpinner(templateContainer) {
        var $initialElement = $(this),
            spinnerStarted = $initialElement.data('spinner-started');
        setTimeout(function(){
            hide($('#spinner' + spinnerStarted));
            // show button 'load more' unless it has data attribute 'hide'
            if (!$initialElement.data('hide')) show($initialElement);
            $(templateContainer + ' .dsc-spinner-controlled-invisible').addClass('dsc-spinner-controlled-visible')
                .removeClass('dsc-spinner-controlled-invisible');
        }, getSpinnerDelay(spinnerStarted));
        $spinner.data('spinner-started')
    }

    function show($element) {
        $element.removeClass('dsc-disappearing').addClass('dsc-appearing');
    }

    function hide($element) {
        $element.removeClass('dsc-appearing').addClass('dsc-disappearing');
    }

    function getSpinnerDelay(startTime) {
        var result = spinnerDisplayMinTime - (Date.now() - startTime);
        return result > 0 ? result : 0;
    }

    // button_to generates form, so final element is a submit within the form, while link_to generates a link
    // which by itself is final for us
    function getFinalElement($element) {
        return $element.is('form') ? $element.children('input[type=submit]:first') : $element;
    }
})(window, document, jQuery);
