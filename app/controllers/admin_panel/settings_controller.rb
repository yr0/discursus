# frozen_string_literal: true

module AdminPanel
  class SettingsController < AdminPanelController
    authorize_resource

    def index
      @setting = Setting.retrieve
    end

    def update
      @setting = Setting.store!(setting_params)
      render :index
    end

    private

    def setting_params
      params.require(:setting).permit(:email, :phone, :facebook, :instagram, :twitter,
                                      :home_hero_title, :home_hero_details, :home_hero_image, :home_hero_image_cache,
                                      :home_hero_link, :team_hero_details, :free_shipping_price_after)
    end
  end
end
