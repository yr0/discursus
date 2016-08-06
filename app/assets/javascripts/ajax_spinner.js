(function(W, D, $){
    $(D).on('turbolinks:load', function() {
        $('body').on('click', '[data-with-ajax-spinner]', function(event) {
            displaySpinner.call(this, event);
        }).on('ajax:success', '[data-with-ajax-spinner]', function() {
            setTimeout(hideSpinner.bind(this), 2000);
        });
    });

    function displaySpinner(event) {
        hide($(this));
        var clone = $('#dscSpinnerTemplate').clone()
            .attr('id', 'dscSpinner')
            .css({
                display: $('#dscSpinnerTemplate').data('display'),
                top: event.pageY
            });
        show(clone.insertBefore($(this)));
    }

    function hideSpinner() {
        //hide($('#dscSpinner'));
        //show($(this));
        //$('#dscSpinner').remove();
    }

    function show($element) {
        $element.removeClass('dsc-disappearing').addClass('dsc-appearing');
    }

    function hide($element) {
        $element.removeClass('dsc-appearing').addClass('dsc-disappearing');
    }

    // button_to generates form, so final element is a submit within the form, while link_to generates a link
    // which by itself is final for us
    function getFinalElement($element) {
        return $element.is('form') ? $element.children('input[type=submit]:first') : $element;
    }
})(window, document, jQuery);
