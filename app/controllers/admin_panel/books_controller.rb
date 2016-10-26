module AdminPanel
  class BooksController < AdminPanelController
    include RestfulActions

    # before_action :build_extra_image, only: [:new, :edit]

    private

    def eager_load_associations
      { authors_books: :author }
    end

    def build_extra_image
      @book.extra_images.build
    end

    def record_params
      params.require(:book).permit(:title, :description, :price, :pages_amount, :category_list,
                                   :ebook_file, :ebook_file_cache, :audio_file, :audio_file_cache,
                                   :image, :image_cache, author_ids: [],
                                   extra_images_attributes: [:id, :title, :position, :image, :image_cache, :_destroy],
                                   variants: Book.variant_types.map { |v| [v, %i(is_available price)] }.to_h)
    end
  end
end
