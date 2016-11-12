module AdminPanel
  class AdminPanelController < ApplicationController
    layout 'admin_panel'

    rescue_from CanCan::AccessDenied do
      redirect_to root_path
    end

    private

    def current_ability
      @ability ||= Ability.new(current_admin)
    end
  end
end
