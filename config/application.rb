# frozen_string_literal: true

require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Line
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 7.1

    # Handle deprecation warnings
    config.active_support.deprecation = :log
    config.active_support.deprecation_behavior = %i[log notify]
    config.action_dispatch.show_exceptions = :none

    # Uncomment the following line if it is required for the assets pipeline
    config.assets.css_compressor = nil

    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    # config.time_zone = "Central Time (US & Canada)"
    # config.eager_load_paths << Rails.root.join("extras")
    # Handle background jobs with Sidekiq
    config.active_job.queue_adapter = :sidekiq

    config.middleware.insert_before 0, Rack::Cors do
      allow do
        origins '*'

        resource '*',
                 headers: :any, methods: %i[get post put patch options head delete]
      end
    end
  end
end
