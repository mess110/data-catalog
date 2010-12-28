DataCatalog::Application.routes.draw do
  resources :catalogs
  resources :categories
  resources :data_sets do
    post 'custom_search', :on => :collection
  end
  resources :discussions
  resources :locations
  resources :organizations
  resources :sites
  resources :tags
  resources :users

  # devise_for :users, :class_name => 'Account'
  devise_for :users, :path => 'account'

  root :to => "home#index"
end
