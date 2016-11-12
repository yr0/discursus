Rails.application.routes.draw do
  mount Ckeditor::Engine => '/ckeditor'
  root 'home#index'
  resources :books, only: %i(index show)
  resources :authors, only: %i(index show)
  resources :articles, only: %i(index show)

  devise_for :users

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
