module AdminPanel
  class BooksController < AdminPanelController
    include RestfulActions

    helper_method :book_categories_for_select

    private

    def book_categories_for_select
      @book_categories_for_select ||= Book.all_categories.pluck(:name).map { |c| { value: c, text: c } }.to_json
    end

    def eager_load_associations
      { authors_books: :author }
    end

    def build_extra_image
      @book.extra_images.build
    end

    def record_params
      params.require(:book).permit(:title, :description, :price, :pages_amount, :category_list,
                                   :ebook_file, :ebook_file_cache, :audio_file, :audio_file_cache,
                                   :image, :image_cache, :сover_designer, :translator, :age_recommendations,
                                   :is_hidden, :is_top, :published_at, :fragment_file, :fragment_file_cache,
                                   :weight, :dimensions, :isbn, :authors_within_anthology,
                                   extra_images_attributes: %i(id title position image image_cache _destroy),
                                   variants: variant_types_params, author_ids: [])
    end

    def variant_types_params
      Book.variant_types.map { |v| [v, %i(is_available price)] }.to_h
    end
  end
end
