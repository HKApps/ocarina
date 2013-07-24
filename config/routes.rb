require 'sidekiq/web'

Ocarina::Application.routes.draw do

  # TODO(mn) - Make this admin-only
  mount Sidekiq::Web, at: '/sidekiq'

  namespace :api do
    get 'current_user', to: 'users#current_user_json'
    get '/users/:id',   to: 'users#show'

    resources :playlists, only: [:index, :show, :create] do
      post 'add_songs', on: :member, to: "playlist_songs#create"

      resources :playlist_songs, only: [:create] do
        post 'upvote',   on: :member
        post 'downvote', on: :member
      end
    end

    resources :songs, only: [:index] do
      post 'dropbox_refresh', on: :collection, to: 'dropbox_songs#update'
    end
  end

  get '/login', to: 'sessions#new', as: 'login'
  match '/auth/:provider/callback', to: 'sessions#create', :via => [:get, :post]
  match "/logout", to: "sessions#destroy", :via => [:get, :post]

  get 'partials/*partial' => 'partials#partial'

  get '/*path', to: 'playlists#index_template'

  root to: 'playlists#index_template'
end
