require 'sidekiq/web'

Ocarina::Application.routes.draw do

  # TODO(mn) - Make this admin-only
  #mount Sidekiq::Web, at: '/sidekiq'

  namespace :api do
    get 'current_user', to: 'users#current_user_json'
    get '/users/:id',   to: 'users#show'

    resources :saved_songs, only: [:index, :destroy, :create]

    resources :playlists, only: [:index, :show, :create] do
      member do
        post 'add_songs', to: "playlist_songs#create"
        post 'join', to: "playlists#join"
        get 'current_song_request', to: "playlists#current_song_request"
        post 'current_song_response', to: "playlists#current_song_response"
      end

      resources :playlist_songs, only: [:create] do
        member do
          get  'media_url'
          post 'upvote'
          post 'downvote'
          post 'played'
          post 'skip_song_vote'
        end
      end
    end

    resources :songs, only: [:index] do
      post 'dropbox_refresh', on: :collection, to: 'dropbox_songs#update'
    end

    resources :saved_songs, only: [:index, :create, :destroy]
  end

  get '/login', to: 'sessions#new', as: 'login'
  match '/auth/:provider/callback', to: 'sessions#create', :via => [:get, :post]
  match "/logout", to: "sessions#destroy", :via => [:get, :post]
  post '/defer_dropbox_connect', to: 'sessions#defer_dropbox_connect'

  get 'partials/*partial' => 'partials#partial'

  get '/*path', to: 'playlists#index_template'

  root to: 'playlists#index_template'
end
