# frozen_string_literal: true

class BooksController < ApplicationController
  before_action :load_and_validate_digital_book_download!, only: :download

  def index
    load_categories
    load_authors
    initialize_search_query
    @search = @search_query.search(params[:page])
    @books = @search.results

    respond_to :html, :js
  end

  def show
    @book = Book.available.friendly.find(params[:id])
  end

  def toggle_favorite
    @book = Book.available.friendly.find(params[:id])
    load_and_change_favorite if current_user.present?
  end

  def download
    if params[:book_variant] == 'audio'
      send_file @book.audio_file.path
    else
      send_file @book.ebook_file.path, filename: "#{@book.slug}.pdf", type: 'application/pdf'
    end
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
    @search_query = BookSearchQuery.new(search_query_params)
  end

  def search_query_params
    return {} if params[:book_search_query].blank?

    params.require(:book_search_query).permit(:order_field, :text_query, :search_all_categories,
                                              author_ids: [], category_ids: [],
                                              order_by_desc: %i(title_for_sorting main_price published_at))
  end

  def load_and_change_favorite
    favorite = UsersFavoriteBook.find_or_initialize_by(user_id: current_user.id, book_id: @book.id)
    favorite.assign_attributes(is_favorited: !favorite.is_favorited?) unless favorite.new_record?
    favorite.save
    @favorited = favorite.is_favorited?
  end

  def load_and_validate_digital_book_download!
    @book = Book.find_by(id: params[:id])
    variant_valid = @book.present? && 
                    @book.variant_available?(params[:book_variant]) && 
                    @book.price_of(params[:book_variant]).zero?

    return if variant_valid && (Rails.configuration.disable_recaptcha || verify_recaptcha)

    flash[:alert] = I18n.t('recaptcha_failed')
    @book.present? ? redirect_to(book_path(@book.slug)) : redirect_to(root_path)
  end
end
