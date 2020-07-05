module AdminPanel
  module BooksHelper
    def book_categories_for_select
      @book_categories_for_select ||= Book.all_categories.pluck(:name).map { |c| { value: c, text: c } }.to_json
    end
  end
end
