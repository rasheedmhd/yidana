# frozen_string_literal: true

Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  root 'pages#home'

  # Add your routes after this line

  ## pu:start routes

  # This following is required for plutonium to work correctly.
  # Do not modify unless you know what you are doing.

  entity_concerns = []
  common_resource_concerns = %i[custom_actions]

  # pu:routes:resources

  concern :house_routes do
    house_concerns = %i[job_description_routes]
    house_concerns += common_resource_concerns
    resources :houses, concerns: house_concerns do
      # pu:routes:houses
    end
  end
  entity_concerns << :house_routes

  concern :job_description_routes do
    job_description_concerns = %i[]
    job_description_concerns += common_resource_concerns
    resources :job_descriptions, concerns: job_description_concerns do
      # pu:routes:job_descriptions
    end
  end
  entity_concerns << :job_description_routes

  # Generic dashboard route
  get 'dashboard', to: 'dashboard#index' # pu:routes:dashboard

  # Onboarding routes
  scope 'onboarding' do
    get '', to: 'onboarding#new', as: 'onboarding'
    post '', to: 'onboarding#create'
    # pu:routes:onboarding
  end

  # pu:routes:concerns

  concern :custom_actions do
    member do
      get 'action/:custom_action', action: :custom_action, as: :custom_action
      post 'action/:custom_action', action: :commit_custom_action
    end
  end

  # Entity resources routes
  scope ':entity_id/dashboard', module: :entity_resources, as: :entity do
    get '', to: 'index#index'
    concerns entity_concerns
    # pu:routes:entity
  end

  constraints Rodauth::Rails.authenticate(:user) do
    # pu:routes:shrine
    mount Shrine.upload_endpoint(:cache) => '/upload'
  end

  ## pu:end routes
end
