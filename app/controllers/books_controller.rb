class BooksController < ApplicationController
  load_and_authorize_resource

  def index
    @books = %w(Hello world)
    respond_to :html, :js
  end
end
