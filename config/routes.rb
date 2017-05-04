Rails.application.routes.draw do
  mount Ckeditor::Engine => '/ckeditor'
  root 'home#index'
  resources :books, only: %i(index show)
  resources :authors, only: %i(index show)
  resources :articles, only: %i(index show)
  get 'about_us', to: 'about_us#index'

  devise_for :users, controllers: {
      omniauth_callbacks: 'users/omniauth_callbacks',
      registrations: 'users/registrations'
  }

  resources :tokens_for_digital_books, only: %i(show) do
    get 'download', on: :member
  end

  scope :orders, controller: :orders do
    get 'cart'
    get 'modify_line_item_quantity'
    post 'populate'
    patch 'submit', as: 'submit_order'
  end

  namespace :u, module: :personal, as: '' do
    get 'bookshelf', to: 'bookshelf#index'
    get 'favorite_books', to: 'favorite_books#index'
    get 'orders', to: 'orders#index', as: :personal_orders
  end

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
