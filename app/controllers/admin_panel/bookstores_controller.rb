module AdminPanel
  class BookstoresController < AdminPanelController
    include RestfulActions

    private

    def record_params
      params.require(:bookstore).permit(:title, :description, :image, :image_cache, :location_name,
                                        :location_lat, :location_lng)
    end
  end
end
