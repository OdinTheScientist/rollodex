Rails.application.routes.draw do
  root "positions#index"
  resources :positions
  resources :techniques
  resources :resources
end
