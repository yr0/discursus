withinControllerScope('orders', 'cart', function(W, D, $) {
    $('#orderSteps').tabs({
        hide: {
            effect: 'slide',
            duration: 800,
            direction: 'left'
        },
        show: {
            effect: 'slide',
            duration: 800,
            delay: 0,
            direction: 'right'
        }
    });

    W.cloneUserFields = function() {
        var fields = ['name', 'phone', 'email', 'password'];

        for(var i = 0; i < fields.length; i++) {
            var field = fields[i],
                value = $('#order_submission_user_for_order_' + field).val();
            $('#hidden-user-' + field).val(value);
        }
    }
});
