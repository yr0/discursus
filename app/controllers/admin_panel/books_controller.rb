module AdminPanel
  class BooksController < AdminPanelController
    include RestfulActions

    private

    def record_params
      params.require(:book).permit(:title, :description, :price, :pages_amount)
    end
  end
end
