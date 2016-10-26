//= require jquery
//= require jquery_ujs
//= require jquery-ui/tooltip
//= require bootstrap-sprockets
//= require adminlte/adminlte.min
//= require ckeditor/init
//= require gritter
//= require selectize.min
//= require sweetalert2.min
//= require underscore.min
//= require gmaps4rails.min
//= require markerclusterer
//= require cocoon
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
            var ckeditorId =  $(this).attr('id');
            if (CKEDITOR.instances[ckeditorId]) {
                CKEDITOR.remove(CKEDITOR.instances[ckeditorId]);
            }
            if($(this).css('visibility') != 'hidden') {
                CKEDITOR.replace(ckeditorId);
            }
        });

        // Reinitialize sweet alert
        swal.init();
    });
}(window, document, jQuery));
