# frozen_string_literal: true

module AdminPanel
  class AdminPanelController < ApplicationController
    layout 'admin_panel'
    before_action :check_admin

    rescue_from CanCan::AccessDenied do
      redirect_to root_path
    end

    private

    def current_ability
      @current_ability ||= Ability.new(current_admin)
    end

    def check_admin
      return if current_admin.present?

      render file: Rails.root.join('public/404'), layout: false, status: :not_found
    end
  end
end
