Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      namespace :merchants do
        get '/:id/items', to: 'items#index'
        get '/find', to: 'search#show'
      end
      resources :merchants, only: [:index, :show, :create, :update, :destroy]

      namespace :items do
        get '/:id/merchant', to: 'merchants#show'
        get '/find', to: 'search#show'
      end
      resources :items, only: [:index, :show, :create, :update, :destroy]
    end
  end
end
