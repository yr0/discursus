class BooksController < ApplicationController
  load_and_authorize_resource

  def index
    per_page = params[:page].nil? && request.format == :html ? 12 : 8
    @books = @books.page(params[:page]).per(per_page)
    respond_to :html, :js
  end
end
