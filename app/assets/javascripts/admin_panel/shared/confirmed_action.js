(function(W, D, $) {
    $.rails.allowAction = function (link) {
        var $link = $(link),
            message = $link.data('confirm-message') || '';
        if ($link.data('confirm') == null) return true;
        W.swal({
            title: i18n.are_you_sure,
            text: message,
            type: 'warning',
            showCancelButton: true,
            allowOutsideClick: false,
            confirmButtonText: i18n.yes_button,
            cancelButtonText: i18n.no_button
        }).then(function () {
            $link.data('confirm', null).trigger('click').data('confirm', true);
        }, function (dismiss) {});

        // returning false prevents the link from being clicked
        return false;
    };
}(window, document, jQuery));
