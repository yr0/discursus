class AuthorsController < ApplicationController
  def index
    @authors = @authors.includes(:books).for_index.page(params[:page]).per(8)
    respond_to :html, :js
  end
end
