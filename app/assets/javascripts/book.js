withinControllerScope('books', 'show', function(W, D, $) {
   // Unfortunately can't figure out how to do this with CSS - clicking one label triggers clicking another label
    $('body').on('click', '.dsc-book-variant-row', function(){
       $('#bookVariantsCheckbox').prop('checked', false);
    });
});
