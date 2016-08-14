Rails.application.routes.draw do
  root 'home#index'
  resources :books, only: %i(index show)

  devise_for :admins
  devise_scope :admin do
    authenticated do
      namespace :admin_panel do
        get '/', to: 'dashboard#index'
      end
    end
  end
end
