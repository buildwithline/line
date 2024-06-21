# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :users, controllers: {
    registrations: 'users/registrations',
    omniauth_callbacks: 'users/callbacks',
    sessions: 'users/sessions'
  }

  devise_scope :user do
    get 'login', to: 'devise/sessions#new'
    get 'signup', to: 'devise/registrations#new'
  end

  root to: 'home#index'

  resources :users, only: [] do
    resource :wallet, only: %i[show create destroy]
    resources :campaigns
  end
  resources :campaigns, only: [:index]
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
