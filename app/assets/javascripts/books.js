withinControllerScope('books', 'index', function(W, D, $) {
    $('#filteredAuthors').selectize({
        plugins: ['remove_button'],
        placeholder: i18n.books.authors_filter_placeholder,
        valueField: 'id',
        labelField: 'name',
        searchField: 'name',
        render: {
            option: function (item, escape) {
                return '<div>' + escape(item.name) + '</div>';
            }
        }
    });
});
