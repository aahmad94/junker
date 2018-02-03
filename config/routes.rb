Rails.application.routes.draw do
  namespace :api do
    get 'locations/create'
  end

  namespace :api do
    get 'locations/update'
  end

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
