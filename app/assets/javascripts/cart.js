withinControllerScope('orders', 'cart', function(W, D, $) {
    W.goToNextTab = function() {
        var nextTabNumber = +$('#orderSteps').tabs('option')['active'] + 1;
        $('#orderSteps').tabs('option', 'active', nextTabNumber);
        return nextTabNumber;
    };

    W.addErrorsAtTab = function(errors, tabNumber) {
        $('#orderSteps').tabs('option', 'active', tabNumber);
        $('.dsc-orders-step-errors:visible').addClass('dsc-form-errors-bordered').html(errors);
    };

    $('#orderSteps').tabs({
        hide: {
            effect: 'drop',
            duration: 500
        },
        show: {
            effect: 'drop',
            duration: 500
        }
    });

    $('body').on('click', '.orders-steps-go-back', function() {
        var active = +$('#orderSteps').tabs('option')['active'];
        $('#orderSteps').tabs('option', 'active', active ? active - 1 : 0);
    });


});
