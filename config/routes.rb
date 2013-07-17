require 'sidekiq/web'

MusicApp::Application.routes.draw do

  # TODO(mn) - Make this admin-only
  mount Sidekiq::Web, at: '/sidekiq'

  get '/login', to: 'sessions#new', as: 'login'
  match '/auth/:provider/callback', to: 'sessions#create', :via => [:get, :post]
  match "/logout", to: "sessions#destroy", :via => [:get, :post]

  match "/dropbox_files", to: "dropbox#create", :via => [:get, :post]

  resources :users, only: [:show]

  get 'partials/*partial' => 'partials#partial'

  # resources :parties, only: [:index, :show, :create] do
  #   resources :playlist, only: [:index] do
  #     post 'add_songs', on: :collection
  #   end
  # end

  get '/*path', to: 'parties#index_template'

  root to: "parties#index_template"
end
