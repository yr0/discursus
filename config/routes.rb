# frozen_string_literal: true

Rails.application.routes.draw do
  mount Ckeditor::Engine => '/ckeditor'

  root 'home#index'

  devise_for :users, controllers: {
    omniauth_callbacks: 'users/omniauth_callbacks',
    registrations: 'users/registrations'
  }

  resources :books, only: %i(index show) do
    put 'toggle_favorite', on: :member
    post 'download', on: :member
  end
  resources :authors, only: %i(index show)
  resources :articles, only: %i(index show)
  resources :series, only: :show
  get 'about_us', to: 'about_us#index'

  resources :tokens_for_digital_books, only: %i(show) do
    get 'download', on: :member
  end

  post 'wayforpay_callback', to: 'payments#wayforpay_callback'
  post 'wayforpay_redirect', to: 'payments#wayforpay_redirect'

  scope :orders, controller: :orders do
    get 'cart'
    get 'thank_you', as: 'orders_thank_you'
    get 'payment_failed', as: 'orders_payment_failed'
    get 'modify_line_item_quantity'
    post 'populate'
    patch 'submit', as: 'submit_order'
  end

  namespace :u, module: :personal, as: '' do
    get 'bookshelf', to: 'bookshelf#index'
    get 'favorite_books', to: 'favorite_books#index'
    resources 'orders', only: %i(index show), as: :personal_orders
  end

  devise_for :admins
  namespace :admin_panel do
    get '/', to: 'orders#index'
    resources :orders, only: %i(index show) do
      member do
        %w(acknowledge_payment complete cancel).each { |action| put action }
      end
    end
    resources :books
    resources :articles
    resources :team_members
    resources :bookstores
    resources :authors
    resources :promo_codes
    resources :series
    resources :settings, only: %i(index update)
  end
end
