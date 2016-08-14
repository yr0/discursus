module AdminPanel
  class AdminPanelController < ApplicationController
    layout 'admin_panel'

    private

    def current_ability
      @ability ||= Ability.new(current_admin)
    end
  end
end
