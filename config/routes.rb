Rails.application.routes.draw do
  namespace :api, defaults: { format: :json } do
    resources :locations, only: [:create, :update]
  end

  get 'api/locations/route/' => 'api/location#route',
    as: 'api_locations_route',
    defaults: { format: :json }

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end

