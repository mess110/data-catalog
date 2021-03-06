DataCatalog::Application.routes.draw do
  resources :catalogs
  resources :categories
  resources :data_sets do
    post 'search', :on => :collection
  end
  resources :discussions
  resources :locations
  resources :organizations
  resources :sites
  resources :tags
  resources :users

  resource :dashboard, :controller => 'dashboard', :only => :show

  # devise_for :users, :class_name => 'Account'
  devise_for :users, :path => 'account'

  root :to => "home#show"
end
