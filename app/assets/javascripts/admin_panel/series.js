withinControllerScope('series', ['new', 'edit', 'create', 'update'], function(W, D, $){
    $('#seriesBooks').selectize({
        plugins: ['remove_button'],
        placeholder: i18n.admin_panel.series.books_selector_placeholder,
        valueField: 'id',
        labelField: 'name',
        render: {
            option: function(item, escape) {
                return '<div>' + escape(item.name) + '</div>';
            }
        }
    });
});
