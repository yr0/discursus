module AdminPanel
  class BooksController < AdminPanelController
    include RestfulActions

    private

    def eager_load_associations
      :authors
    end

    def record_params
      # params[:book][:author_ids].reject!(&:blank?)
      params.require(:book).permit(:title, :description, :price, :pages_amount, author_ids: [])
    end
  end
end
