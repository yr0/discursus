# frozen_string_literal: true

class AuthorsController < ApplicationController
  load_resource find_by: :slug, only: :show

  def index
    @authors = Author.for_index.with_image.page(params[:page]).per(8)
    respond_to :html, :js
  end

  def show
    @books = @author.books.top_recent.available.limit(4)
  end
end
