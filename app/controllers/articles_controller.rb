class ArticlesController < ApplicationController
  load_and_authorize_resource

  def index
    @articles = if params[:query].present?
                  search_articles
                else
                  @articles.page(params[:page]).per(per_page)
                end
    respond_to :html, :js
  end

  private

  def search_articles
    @search = Article.search do
      fulltext params[:query]
      paginate page: params[:page], per_page: per_page
    end
    @search.results
  end

  def per_page
    @per_page ||= params[:page].to_i > 1 ? 8 : 14
  end
end
