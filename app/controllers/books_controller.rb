class BooksController < ApplicationController
  load_and_authorize_resource find_by: :slug

  def index
    load_categories
    load_authors
    @search = @search_query.search(params[:page])
    @books = @search.results

    respond_to :html, :js
  end

  def show
  end

  private

  def load_categories
    @categories = Book.all_categories
  end

  def load_authors
    # load only authors who have books
    @authors = Author.joins(:books).distinct.all
  end

  def initialize_search_query
    @search_query = SearchQuery.new(search_query_params)
  end

  def search_query_params
    return {} unless params[:search_query].present?
    params.require(:search_query).permit(:order_field, :text_query, :search_all_categories,
                                         author_ids: [], category_ids: [],
                                         order_by_desc: [:title_for_sorting, :main_price, :created_at])
  end
end
