// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file. JavaScript code in this file should be added after the last require_* statement.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require jquery-ui/widgets/tabs
//= require jquery-ui/effect.all
//= require darkbox.min
//= require gritter
//= require tooltipster.bundle.min
//= require selectize.min
//= require turbolinks
//= require shared/general_functions
//= require ajax_spinner
//= require has_tooltipster
//= require form_enter_submitted
//= require checkbox_main_among
//= require books
//= require book
//= require cart

$.extend($.gritter.options, {
    position: 'top-left'
});

$(window).on('scroll', function(){
    $('.dsc-clicked-inview').each(function(){
        var $element = $(this),
            clientRect = $element[0].getBoundingClientRect();
        if($element.parent().hasClass('dsc-disappearing')) return;
        if(clientRect.top >= 0 && clientRect.bottom <= window.innerHeight) {
            $element.click();
            $element.removeClass('dsc-clicked-inview');
            setTimeout(function(){
                $element.addClass('dsc-clicked-inview');
            }, 1000);
        }
    });
});
