Rails.application.routes.draw do

  get "up" => "rails/health#show", as: :rails_health_check

  root "games#new"

  resource :game, only: [:create, :show] do
    post :hit
    post :stand
  end
end
