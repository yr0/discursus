class BooksController < ApplicationController
  def index
    @books = %w(Hello world)
    respond_to :html, :js
  end
end
