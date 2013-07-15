MusicApp::Application.routes.draw do
  root to: "parties#index"

  get '/login', to: 'sessions#new', as: 'login'
  match '/auth/:provider/callback', to: 'sessions#create', :via => [:get, :post]
  match "/logout", to: "sessions#destroy", :via => [:get, :post]

  match "/dropbox_files", to: "dropbox#create", :via => [:get, :post]

  resources :parties, only: [:index, :show, :create] do
    resources :playlist, only: [:index]
  end
end
