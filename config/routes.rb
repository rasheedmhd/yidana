# frozen_string_literal: true

Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  root 'pages#home'

  get 'onboarding', to: 'onboarding#new', as: 'onboarding'
  post 'onboarding', to: 'onboarding#create'

  # scope 'dashboard', module: 'users' do
  #   get '', to: 'dashboard#index', as: 'dashboard'
  # end

  scope 'dashboard', module: :dashboard do
    get '', to: 'index#index', as: 'dashboard'
    get 'switch/:entity_id', to: 'index#switch_entity', as: 'switch_entity'
  end
end
