Rails.application.routes.draw do
  root 'home#index'
  resources :books, only: %i(index show)

  namespace :admin_panel do
    get '/', to: 'dashboard#index'
  end
end
