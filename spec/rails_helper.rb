# frozen_string_literal: true

# This file is copied to spec/ when you run 'rails generate rspec:install'
require 'spec_helper'
ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../config/environment', __dir__)
abort('The Rails environment is running in production mode!') if Rails.env.production?

# Requires
require 'rspec/rails'
Dir[Rails.root.join('spec/support/**/*.rb')].sort.each { |file| require file }

# Configure RSpec
RSpec.configure do |config|
  # Include FactoryBot methods
  config.include FactoryBot::Syntax::Methods

  # Include Devise test helpers
  config.include Devise::Test::IntegrationHelpers, type: :request

  # Fixture path
  config.fixture_paths = [Rails.root.join('spec/fixtures')]

  # Use transactional fixtures
  config.use_transactional_fixtures = true

  # Infer spec type from file location
  config.infer_spec_type_from_file_location!

  # Filter lines from Rails gems in backtraces
  config.filter_rails_from_backtrace!

  # Raise errors for deprecation warnings
  config.raise_errors_for_deprecations!

  # Handle deprecation warning for action_dispatch.show_exceptions by setting it to :none
  config.before(:each) do
    allow(Rails.application.config.action_dispatch).to receive(:show_exceptions).and_return(:none)
  end

  # Configure ActiveJob to use the test adapter
  config.before(:suite) do
    ActiveJob::Base.queue_adapter = :test
  end

  # Include ActiveJob::TestHelper to enable matchers for testing background job enqueuing and performing.
  # This is necessary for verifying that jobs are correctly enqueued or performed within controller tests.
  config.include ActiveJob::TestHelper, type: :controller
end

# Checks for pending migrations and applies them before tests are run
begin
  ActiveRecord::Migration.maintain_test_schema!
rescue ActiveRecord::PendingMigrationError => e
  abort e.to_s.strip
end

# The following line is provided for convenience purposes. It has the downside
# of increasing the boot-up time by auto-requiring all files in the support
# directory. Alternatively, in the individual `*_spec.rb` files, manually
# require only the support files necessary.
#
# Dir[Rails.root.join('spec/support/**/*.rb')].sort.each { |file| require file }
