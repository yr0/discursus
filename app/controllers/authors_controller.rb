class AuthorsController < ApplicationController
  load_resource find_by: :slug, only: :show

  def index
    @authors = Author.includes(:books).for_index.page(params[:page]).per(8)
    respond_to :html, :js
  end
end
