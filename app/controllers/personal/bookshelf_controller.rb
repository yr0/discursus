# frozen_string_literal: true

module Personal
  class BookshelfController < PersonalController
    def index
      @books = current_user.bought_books.page(params[:page])
      respond_to :html, :js
    end
  end
end
