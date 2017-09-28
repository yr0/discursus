class HomeController < ApplicationController
  def index
    @books = Book.available.top_recent.page(1).per(8)
  end
end
