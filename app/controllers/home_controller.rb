class HomeController < ApplicationController
  layout 'home'

  def index
    @books = Book.page(1).per(8)
  end
end
