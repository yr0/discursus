class ApplicationController < ActionController::Base
  include CurrentOrder
  protect_from_forgery with: :exception
end
