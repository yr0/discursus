//= require jquery
//= require jquery_ujs
//= require jquery-ui/tooltip
//= require adminlte/adminlte.min
//= require ckeditor/init
//= require gritter
//= require sweetalert2.min
//= require underscore.min
//= require gmaps4rails.min
//= require markerclusterer
//= require turbolinks

//= require 'shared/general_functions'
//= require_tree .

(function(W, D, $){
    // constants
    W.ukraineCenter = { lat: 49.224772722794825, lng: 31.44287109375 };

    // actions concerning external libraries in context of turbolinks
    D.addEventListener('turbolinks:load', function(){
        // adminLTE
        var o = $.AdminLTE.options;
        if (o.sidebarPushMenu) {
            $.AdminLTE.pushMenu.activate(o.sidebarToggleSelector);
        }

        $.AdminLTE.layout.activate();

        // reload CKEditor windows
        $('.input-ckeditor').each(function() {
            if($(this).css('visibility') != 'hidden') {
                CKEDITOR.replace($(this).attr('id'));
            }
        });

        // Reinitialize sweet alert
        swal.init();
    });
}(window, document, jQuery));
