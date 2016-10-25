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

    // strangely enough, even though selectize reads options from data-data attributes, it automatically pre-selects
    // them in the input field, while we only need them as auto-suggest
    $('#bookCategories').selectize({
        plugins: ['remove_button'],
        placeholder: i18n.admin_panel.books.select_categories_placeholder,
        delimiter: ',',
        options: $('#bookCategories').data('categories'),
        create: function(input) {
            return {
                value: input,
                text: input
            }
        }
    });

    function what(data) {
        console.log(data);
        return JSON.parse(data);
    }
});
