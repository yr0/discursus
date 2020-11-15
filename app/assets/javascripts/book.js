withinControllerScope('books', 'show', function(W, D, $) {
   // Unfortunately can't figure out how to do this with CSS - clicking one label triggers clicking another label
    $('body').on('click', '.dsc-book-variant-row', function(){
       $('#bookVariantsCheckbox').prop('checked', false);
    });

    $('body').on('change', 'input[name=variant_outside_form]', function(e) {
      var value = e.target.value;

      $('#bookVariantToSubmit').val(value);

      e.target.getAttribute('data-is-free') ? $('#buyBookButton').hide() : $('#buyBookButton').show();
    });

    var free_variant_checked = $('input[name=variant_outside_form]').toArray().some(function(e) { 
      return e.checked && e.attributes['data-is-free'] 
    });

   if(free_variant_checked) { $('#buyBookButton').hide() }  
});
