class ArticlesController < ApplicationController
  load_resource find_by: :slug, only: :show
  before_action :set_default_per_page, only: :index

  def index
    @articles = if params[:query].present?
                  search_articles_result
                else
                  Article.page(params[:page]).per(params[:per_page])
                end
    respond_to :html, :js
  end

  private

  def set_default_per_page
    params[:per_page] ||= params[:page].to_i > 1 ? 8 : 14
  end

  def search_articles_result
    @search = Article.sunspot_search permitted_search_params
    @search.results
  end

  def permitted_search_params
    params.permit(:query, :page, :per_page)
  end
end
