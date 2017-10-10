class AuthorsController < ApplicationController
  load_resource find_by: :slug, only: :show

  def index
    @authors = Author.with_last_book_titles.for_index.page(params[:page]).per(8)
    respond_to :html, :js
  end

  def show
    @books = @author.books.top_recent.available.limit(4)
  end
end
