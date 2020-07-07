Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resources :activities
      get 'events/read', to: 'events#read'
      get 'events/import', to: 'events#import'
      resources :events
      get 'deadlines/webscrap', to: 'deadlines#webscrap'
      get 'deadlines/import', to: 'deadlines#import'
      resources :deadlines

    end
  end
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
