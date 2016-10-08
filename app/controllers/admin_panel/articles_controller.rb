module AdminPanel
  class ArticlesController < AdminPanelController
    include RestfulActions

    private

    def record_params
      params.require(:article).permit(:title, :body, :image, :image_cache)
    end
  end
end
