class ArticlesController < ApplicationController
  load_and_authorize_resource

  def index
    per_page = params[:page].to_i > 1 ? 8 : 14
    @articles = @articles.page(params[:page]).per(per_page)
    respond_to :html, :js
  end
end
