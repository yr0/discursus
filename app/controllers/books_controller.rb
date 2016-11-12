class BooksController < ApplicationController
  load_and_authorize_resource

  def index
    @books = @books.page(params[:page]).per(8)
    respond_to :html, :js
  end
end
