(function(W, D, $){
    D.addEventListener('turbolinks:load', function(){
        $('body').on('keypress', '.dsc-form-enter-submitted', function(e){
            var keyCode = e.keyCode || e.which,
                $input = $(this).children('.dsc-form-text').first();
            if(keyCode == 13 && $input.val().length < 3) {
                $input.tooltipster('open');
                return false
            }
        });
    });
})(window, document, jQuery);
