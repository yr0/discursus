class ApplicationController < ActionController::Base
  include CurrentOrder
  protect_from_forgery with: :exception

  rescue_from CanCan::AccessDenied do
    redirect_to root_path
  end

  rescue_from ActiveRecord::RecordNotFound do
    redirect_to root_path
  end
end
