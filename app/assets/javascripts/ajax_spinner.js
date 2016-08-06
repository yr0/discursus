// There can only be one spinner within a div - sibling spinners will not work
(function(W, D, $){
    var spinnerDisplayMinTime = 1000; // display spinner for a minimum of 1 second
    $(D).on('turbolinks:load', function() {
        $('body').on('ajax:before', '[data-with-ajax-spinner]', function() {
            displaySpinner.apply(this);
        }).on('ajax:templateLoaded', '[data-with-ajax-spinner]', function() {
            hideSpinner.apply(this);
        });
    });

    function displaySpinner() {
        hide($(this));
        var $spinner = $(this).siblings('.dsc-spinner:first'),
            spinnerStarted = Date.now();
        if (!$spinner.length) {
            $spinner = $('#dscSpinnerTemplate').clone().insertBefore($(this));
            //apply the scale property so that initial animation is fired
            W.getComputedStyle($spinner.get(0)).getPropertyValue('transform');
        }
        // save start spinner time in order to hide it at least after spinnerDisplayMinTime milliseconds
        $spinner.attr('id', 'spinner' + spinnerStarted);
        $(this).data('spinner-started', spinnerStarted);
        show($spinner);
    }

    function hideSpinner() {
        var initialElement = $(this),
            spinnerStarted = initialElement.data('spinner-started');
        setTimeout(function(){
            hide($('#spinner' + spinnerStarted));
            show(initialElement);
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
