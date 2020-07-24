Rails.application.routes.draw do
  resources :users, only: [:create]
  post "auth/login", to: "authentication#login"
  namespace :api do
    namespace :v1 do
      resources :activities
      post 'events/write', to: 'events#write'
      post 'events/read', to: 'events#read'
      get 'events/import', to: 'events#import'
      resources :events
      post 'deadlines/webscrap', to: 'deadlines#webscrap'
      post 'deadlines/import', to: 'deadlines#import'
      resources :deadlines
      resources :users
    end
  end
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
