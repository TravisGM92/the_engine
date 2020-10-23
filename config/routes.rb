# frozen_string_literal: true

Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      namespace :merchants do
        get '/:id/items', to: 'items#index'
        get '/find', to: 'search#show'
        get '/find_all', to: 'search#index'
        get 'most_revenue', to: 'most_revenue#index'
        get '/most_items', to: 'most_items#index'
        get '/:id/revenue', to: 'revenue#show'
      end
      resources :merchants, only: %i[index show create update destroy]

      namespace :items do
        get '/:id/merchants', to: 'merchants#show'
        get '/find', to: 'search#show'
        get '/find_all', to: 'search#index'
      end
      resources :items, only: %i[index show create update destroy]

      get '/revenue', to: 'merchants/most_revenue#show'
    end
  end
end
