class HomeController < ApplicationController
  def index
    @books = Book.available.top_recent.with_authors.page(1).per(8)
  end
end
