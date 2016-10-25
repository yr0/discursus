module AdminPanel
  class BooksController < AdminPanelController
    include RestfulActions

    private

    def eager_load_associations
      { authors_books: :author }
    end

    def record_params
      params.require(:book).permit(:title, :description, :price, :pages_amount, :ebook_file, :audio_file,
                                   :category_list, author_ids: [],
                                   variants: Book::VARIANT_TYPES.map { |v| [v, %i(is_available price)] }.to_h)
    end
  end
end
