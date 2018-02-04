Rails.application.routes.draw do
  namespace :api, defaults: { format: :json } do
    resources :locations, only: [:index, :create, :update]
  end

  post 'api/locations/route_coordinates/' => 'api/locations#route_coordinates',
    as: 'api_locations_route_coordinates',
    defaults: { format: :json }

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  post 'webhook' => 'webhooks#handle_callback'
  require 'sidekiq/web'
	mount Sidekiq::Web => '/sidekiq'
end

