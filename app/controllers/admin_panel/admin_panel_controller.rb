module AdminPanel
  class AdminPanelController < ApplicationController
    layout 'admin_panel'
    before_action :check_admin

    rescue_from CanCan::AccessDenied do
      redirect_to root_path
    end

    private

    def current_ability
      @ability ||= Ability.new(current_admin)
    end

    def check_admin
      if current_admin.blank?
        render file: Rails.root.join('public', '404'), layout: false, status: :not_found
      end
    end
  end
end
