# frozen_string_literal: true

module AdminPanel
  class SeriesController < AdminPanelController
    include RestfulActions

    private

    def record_params
      params.require(:series).permit(:title, :description, :slug, book_ids: [])
    end
  end
end
