Rails.application.routes.draw do
  
  resources :hollywoods
  resources :bollywoods
  resources :footballs
  resources :leaderboards
  resources :crickets
  get 'home/index'	
  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
  devise_for :users, :controllers => { registrations: 'users/registrations' }

  root 'home#index'
  # resources :qui
  get 'quiz/index'
  get 'crickets/index'
  get 'crickets/1'

  get 'footballs/index'
  get 'footballs/1'

  get 'bollywoods/index'
  get 'bollywoods/1'

  get 'hollywoods/index'
  get 'hollywoods/1'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
