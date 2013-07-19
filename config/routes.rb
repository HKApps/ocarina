require 'sidekiq/web'

MusicApp::Application.routes.draw do

  # TODO(mn) - Make this admin-only
  mount Sidekiq::Web, at: '/sidekiq'

  get '/login', to: 'sessions#new', as: 'login'
  match '/auth/:provider/callback', to: 'sessions#create', :via => [:get, :post]
  match "/logout", to: "sessions#destroy", :via => [:get, :post]

  match "/dropbox_files", to: "dropbox#create", :via => [:get, :post]
  get   "/dropbox", to: "dropbox#index"

  resources :users, only: [:show]

  get 'partials/*partial' => 'partials#partial'

  resources :parties, only: [:show, :create] do
    resources :playlist, only: [:index] do
      post 'add_songs', on: :collection
    end
  end

  get 'current_user', to: 'users#current_user_json'

  get '/*path', to: 'parties#index_template'

  root to: "parties#index_template"
end
