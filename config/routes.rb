# frozen_string_literal: true

Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # pu:start routes

  # This block is required for plutonium to work correctly.
  # Do not modify unless you know what you are doing.

  # Onboarding routes
  scope 'onboarding' do
    get '', to: 'onboarding#new', as: 'onboarding'
    post '', to: 'onboarding#create'
    # pu:routes:onboarding
  end

  # Generic dashboard route
  get 'dashboard', to: 'dashboard#index' # pu:routes:dashboard

  # Entity specific dashboard route
  scope ':entity/dashboard', module: :dashboard, as: :entity do
    get '', to: 'index#index'
    # pu:routes:entity

    resources :users do
      # pu:routes:entity:users
    end
  end

  # pu:end routes

  # Defines the root path route ("/")
  root 'pages#home'

  # Add your routes after this line
end
