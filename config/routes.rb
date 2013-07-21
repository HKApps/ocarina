require 'sidekiq/web'

Ocarina::Application.routes.draw do

  # TODO(mn) - Make this admin-only
  mount Sidekiq::Web, at: '/sidekiq'

  get '/login', to: 'sessions#new', as: 'login'
  match '/auth/:provider/callback', to: 'sessions#create', :via => [:get, :post]
  match "/logout", to: "sessions#destroy", :via => [:get, :post]

  match "/dropbox_files", to: "dropbox#create", :via => [:get, :post]
  get   "/dropbox", to: "dropbox#index"

  resources :users, only: [:show]

  get 'partials/*partial' => 'partials#partial'

  resources :playlists, only: [:index, :show, :create] do
    post 'add_songs', on: :member, to: "playlist_songs#create"

    resources :playlist_songs, only: [:create] do
      post 'up',   on: :member
      post 'down', on: :member
    end
  end

  get 'current_user', to: 'users#current_user_json'

  get '/*path', to: 'playlists#index_template'

  root to: 'playlists#index_template'
end
