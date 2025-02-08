# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :users, controllers: {
    omniauth_callbacks: 'users/callbacks'
  }

  root to: 'home#index'

  resources :users, only: [] do
    resource :wallet, only: %i[show create destroy]
    resources :repositories, only: [] do
      resources :campaigns, only: %i[show new create edit update destroy] do
        resources :contributions, only: %i[new create]
      end
    end
  end
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
