Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  devise_for :users
  get 'welcome/index'
  get 'admin/index'
  get '/client', to: 'clients#index', as: '/client'

  resources :clients
  
  root 'welcome#index'

  resources :characters
  resources :rooms
  resources :items
  resources :areas
  
end
