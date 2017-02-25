withinControllerScope('orders', 'cart', function(W, D, $) {
    W.cloneUserFields = function() {
        var fields = ['name', 'phone', 'email', 'password'];

        for(var i = 0; i < fields.length; i++) {
            var field = fields[i],
                value = $('#order_submission_user_for_order_' + field).val();
            $('#hidden-user-' + field).val(value);
        }
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
