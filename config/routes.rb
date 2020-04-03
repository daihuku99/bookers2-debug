Rails.application.routes.draw do

  root to: 'home#top'
  get 'home/about' => 'home#about', as: :about
  devise_for :users
  # devise_for :users, controllers: {
  # 	sessions: 'users/sessions',
  # 	registrations: 'users/registrations'
  # }
  resources :users, only: [:show,:index,:edit,:update]

  resources :books do
  	resource :favorites, only: [:create, :destroy]
  	resources :book_comments, only: [:create, :destroy]
  end

  post 'follow/:id' => 'relationships#follow', as: 'follow'
  post 'unfollow/:id' => 'relationships#unfollow', as: 'unfollow'
  get 'follower/:id' => 'users#follower', as: 'follower'
  get 'following/:id' => 'users#following', as: 'following'
  get 'search' => 'searches#search'

end