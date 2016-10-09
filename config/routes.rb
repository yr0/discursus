Rails.application.routes.draw do
  mount Ckeditor::Engine => '/ckeditor'
  root 'home#index'
  resources :books, only: %i(index show)

  devise_for :admins
  devise_scope :admin do
    authenticated do
      namespace :admin_panel do
        get '/', to: 'dashboard#index'
        resources :books
        resources :articles
        resources :team_members
        resources :bookstores
      end
    end
  end
end
