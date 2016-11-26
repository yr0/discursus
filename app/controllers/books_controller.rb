class BooksController < ApplicationController
  load_and_authorize_resource

  def index
    load_categories
    initialize_search_query

    p @search_query
    @books = @books.page(params[:page]).per(8)
    respond_to :html, :js
  end

  private

  def load_categories
    @categories = Book.all_categories
  end

  def initialize_search_query
    @search_query = SearchQuery.new(search_query_params)
  end

  def search_query_params
    return {} unless params[:search_query].present?
    params.require(:search_query).permit(:order_by, :text_query, :search_all_categories,
                                         category_ids: [], price_range: [], order_by_desc: [:title, :price, :date])
  end
end
