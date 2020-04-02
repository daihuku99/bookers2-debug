Rails.application.routes.draw do

  root to: 'home#top'
  get 'home/about' => 'home#about', as: :about
  devise_for :users
  # devise_for :users, controllers: {
  # 	sessions: 'users/sessions',
  # 	registrations: 'users/registrations'
  # }
  resources :users, only: [:show,:index,:edit,:update]
  resources :books
end