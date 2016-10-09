withinControllerScope('books', ['new', 'edit', 'create', 'update'], function(W, D, $){
    $('#bookAuthors').selectize({
        plugins: ['remove_button'],
        placeholder: i18n.admin_panel.authors.select_placeholder,
        valueField: 'id',
        labelField: 'name',
        render: {
            option: function(item, escape) {
                return '<div>' + escape(item.name) + '</div>';
            }
        }
    });
});
