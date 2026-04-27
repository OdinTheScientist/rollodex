Rails.application.routes.draw do
  get "techniques/index"
  get "techniques/show"
  get "techniques/new"
  get "techniques/edit"
  get "positions/index"
  get "positions/show"
  get "positions/new"
  get "positions/edit"
  root "positions#index"

  resources :positions
  resources :techniques
end
