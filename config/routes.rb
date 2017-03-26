Rails.application.routes.draw do
  mount Ckeditor::Engine => '/ckeditor'
  root 'home#index'
  resources :books, only: %i(index show)
  resources :authors, only: %i(index show)
  resources :articles, only: %i(index show)
  get 'about_us', to: 'about_us#index'

  scope :orders, controller: :orders do
    get 'cart'
    get 'modify_line_item_quantity'
    post 'populate'
    patch 'submit', as: 'submit_order'
  end

  devise_for :users, controllers: {
    omniauth_callbacks: 'users/omniauth_callbacks',
    registrations: 'users/registrations'
  }

  devise_for :admins
  namespace :admin_panel do
    get '/', to: 'dashboard#index'
    resources :books
    resources :articles
    resources :team_members
    resources :bookstores
    resources :authors
  end
end
