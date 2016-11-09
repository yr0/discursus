(function(W, D, $){
   D.addEventListener('turbolinks:load', function(){
       $('body').on('mouseenter', '.has-tooltipster:not(.tooltipstered)', function(){
           // on which side of element the tooltipster must appear
           var side = $(this).data('tooltipster-side') || 'top';
           $(this).tooltipster({
               theme: 'tooltipster-borderless',
               side: side
           }).tooltipster('open');
       });
   });
})(window, document, jQuery);
