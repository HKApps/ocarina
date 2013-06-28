MusicApp::Application.routes.draw do
  root to: "sessions#new"
  get '/login', to: 'sessions#new', as: 'login'
  match '/auth/:provider/callback', to: 'sessions#create', :via => [:get, :post]
  match "/logout", to: "sessions#destroy", :via => [:get, :post]
  match "/dropbox_files", to: "dropbox#create", :via => [:get, :post]
end
