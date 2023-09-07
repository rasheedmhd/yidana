# frozen_string_literal: true

require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module MyApp
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 7.0

    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    # config.time_zone = "Central Time (US & Canada)"
    # config.eager_load_paths << Rails.root.join("extras")

    config.generators do |g|
      g.factory_bot false
      g.fixtures = false
      g.test_framework :rspec,
                       controller_specs: false,
                       request_specs: false,
                       model_specs: false,
                       view_specs: false,
                       helper_specs: false,
                       routing_specs: false
      g.assets false
      g.stylesheets false
      g.helper false
      g.test_unit fixture: false
    end

    config.active_job.queue_adapter = :sidekiq

    config.action_mailer.deliver_later_queue_name = 'mailers'
  end
end
