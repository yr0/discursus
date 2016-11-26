// Adds ability to define a 'main' checkbox within a set of checkboxes. If the 'main' checkbox is clicked, all other
// checkboxes within the container become unchecked. If one of not 'main' checkboxes is checked, the 'main' checkbox
// becomes unchecked. To make a checkbox 'main', add to it 'data-main-among' attribute whose value
// is a container selector.
(function(W, D, $){
    D.addEventListener('turbolinks:load', function(){
        var mainAmongSelector = 'input[type=checkbox][data-main-among]',
            notMainAmongSelector = 'input[type=checkbox]:not([data-main-among])';

        $(mainAmongSelector).each(function(){
            var containerSelector = $(this).data('main-among'),
                containerMainAmongSelector = containerSelector + ' ' + mainAmongSelector,
                containerNotMainAmongSelector = containerSelector + ' ' + notMainAmongSelector;

            $('body').on('click', containerMainAmongSelector, function(){
               $(containerNotMainAmongSelector).prop('checked', false);
            }).on('click', containerNotMainAmongSelector, function(){
                $(containerMainAmongSelector).prop('checked', false);
            });
        });
    });
})(window, document, jQuery);
