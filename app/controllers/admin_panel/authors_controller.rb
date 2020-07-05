# frozen_string_literal: true

module AdminPanel
  class AuthorsController < AdminPanelController
    include RestfulActions

    def index
      super
      respond_to do |format|
        format.html
        format.json do
          query = params[:query].size < 2 ? '' : params[:query]
          render json: { authors: @authors.named_like(query).select(:id, :name) }
        end
      end
    end

    private

    def record_params
      params.require(:author).permit(:name, :short_description, :description, :image, :image_cache, :position)
    end
  end
end
