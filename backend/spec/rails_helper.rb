# frozen_string_literal: true

# This file is copied to spec/ when you run 'rails generate rspec:install'
require 'spec_helper'
ENV['RAILS_ENV'] = 'test' if ENV['RAILS_ENV'].nil? || ENV['RAILS_ENV'] == 'development'
SAMPLE_SIZE = 5

require File.expand_path('../config/environment', __dir__)

# Prevent database truncation if the environment is not test
abort('The Rails environment is not running in testing mode!') unless Rails.env.test?
require 'rspec/rails'
require 'rake'

# # Add additional requires below this line. Rails is not loaded until this point!
# require 'shoulda/matchers'
require 'support/factory_bot'

# # Test sidekiq jobs in inline mode
# require 'sidekiq/testing'
# Sidekiq::Testing.inline!

# # Add test coverage report
# # Run the test with 'COVERAGE=true rspec spec/tests' to generate the coverage report in coverage/index.html
# require 'simplecov'
# SimpleCov.start 'rails' if ENV['COVERAGE']

include ActiveJob::TestHelper

# require 'shoulda/matchers'
Shoulda::Matchers.configure do |config|
  config.integrate do |with|
    with.test_framework :rspec
    with.library :rails
  end
end

# Requires supporting ruby files with custom matchers and macros, etc, in
# spec/support/ and its subdirectories. Files matching `spec/**/*_spec.rb` are
# run as spec files by default. This means that files in spec/support that end
# in _spec.rb will both be required and run as specs, causing the specs to be
# run twice. It is recommended that you do not name files matching this glob to
# end with _spec.rb. You can configure this pattern with the --pattern
# option on the command line or in ~/.rspec, .rspec or `.rspec-local`.
#
# The following line is provided for convenience purposes. It has the downside
# of increasing the boot-up time by auto-requiring all files in the support
# directory. Alternatively, in the individual `*_spec.rb` files, manually
# require only the support files necessary.
#
Dir[Rails.root.join('spec', 'support', '**', '*.rb')].sort.each { |f| require f }

# Checks for pending migrations and applies them before tests are run.
# If you are not using ActiveRecord, you can remove these lines.
begin
  ActiveRecord::Migration.maintain_test_schema!
rescue ActiveRecord::PendingMigrationError => e
  puts e.to_s.strip
  exit 1
end
RSpec.configure do |config|
  # Remove this line if you're not using ActiveRecord or ActiveRecord fixtures
  config.fixture_paths = [ "#{Rails.root}/spec/fixtures" ]

  # If you're not using ActiveRecord, or you'd prefer not to run each of your
  # examples within a transaction, remove the following line or assign false
  # instead of true.
  config.use_transactional_fixtures = true

  # Setting DatabaseCleaner configuration to clean database after each example
  config.before(:suite) do
    DatabaseCleaner.clean_with(:truncation)
    # Set the queue adapter to :test to prevent job execution
    ActiveJob::Base.queue_adapter = :test
    # Import all necessary rspec default models records
    # load 'lib/tasks/import.rake'
    # Rake::Task['import:rspec'].invoke
  end
  config.before(:each, type: :feature) do
    # For feature specs, use truncation strategy
    DatabaseCleaner.strategy = :truncation
  end
  # set up the cleaning strategy before the example runs
  config.before(:each) do
    DatabaseCleaner.strategy = :transaction
    DatabaseCleaner.start
  end
  # ensure that the cleaning actually happens after the example
  config.after(:each) do
    DatabaseCleaner.clean
  end
  # ensure that the cleaning actually happens after the example and clear the enqueued jobs
  config.after(:each) do
    DatabaseCleaner.clean
    clear_enqueued_jobs
  end

  # RSpec Rails can automatically mix in different behaviours to your tests
  # based on their file location, for example enabling you to call `get` and
  # `post` in specs under `spec/controllers`.
  #
  # You can disable this behaviour by removing the line below, and instead
  # explicitly tag your specs with their type, e.g.:
  #
  #     RSpec.describe UsersController, :type => :controller do
  #       # ...
  #     end
  #
  # The different available types are documented in the features, such as in
  # https://relishapp.com/rspec/rspec-rails/docs
  config.infer_spec_type_from_file_location!

  # Filter lines from Rails gems in backtraces.
  config.filter_rails_from_backtrace!
  # arbitrary gems may also be filtered via:
  # config.filter_gems_from_backtrace("gem name")
  config.include Rails.application.routes.url_helpers
  Dir[Rails.root.join('spec/support/**/*.rb')].each { |f| require f }
end
