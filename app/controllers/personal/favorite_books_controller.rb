# frozen_string_literal: true

module Personal
  class FavoriteBooksController < PersonalController
    def index
      @books = current_user.favorite_books.page(params[:page])
    end
  end
end
