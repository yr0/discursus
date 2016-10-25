module AdminPanel
  class BooksController < AdminPanelController
    include RestfulActions

    private

    def eager_load_associations
      { authors_books: :author }
    end

    def record_params
      params.require(:book).permit(:title, :description, :price, :pages_amount, :category_list,
                                   :ebook_file, :ebook_file_cache, :audio_file, :audio_file_cache,
                                   :image, :image_cache, author_ids: [],
                                   variants: Book.variant_types.map { |v| [v, %i(is_available price)] }.to_h)
    end
  end
end
