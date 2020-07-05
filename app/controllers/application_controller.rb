# frozen_string_literal: true

class ApplicationController < ActionController::Base
  include CurrentOrder
  protect_from_forgery with: :exception
  before_action :set_raven_context
  helper_method :settings

  rescue_from CanCan::AccessDenied do
    redirect_to root_path
  end

  rescue_from ActiveRecord::RecordNotFound do
    redirect_to root_path
  end

  private

  def set_raven_context
    Raven.user_context(id: current_user&.id || cookies[:temp_user_uuid])
    Raven.extra_context(params: params.to_unsafe_h, url: request.url)
  end

  def settings
    Rails.cache.fetch('discursus_settings', expires_in: 5.minutes) do
      Setting.retrieve
    end
  end
end
