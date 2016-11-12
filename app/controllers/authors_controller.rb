class AuthorsController < ApplicationController
  load_and_authorize_resource find_by: :slug

  def index
    @authors = @authors.includes(:books).where.not(image: nil).page(params[:page]).per(8)
    respond_to :html, :js
  end
end
