ENV["RAILS_ENV"] ||= 'test'
require File.expand_path("../../config/environment", __FILE__)
require 'rspec/rails'
require 'factory_girl_rails'
require 'capybara/rspec'
require 'vcr'

require './spec/support/pages/page_object'

Dir[Rails.root.join("spec/support/**/*.rb")].each { |f| require f }
ActiveRecord::Migration.maintain_test_schema!
Capybara.javascript_driver = :webkit

RSpec.configure do |config|
  config.fixture_path = "#{::Rails.root}/spec/fixtures"
  config.use_transactional_fixtures = false
  config.infer_spec_type_from_file_location!
  config.include FactoryGirl::Syntax::Methods
  config.include SigninHelper

  config.before(:suite) do
    DatabaseCleaner.strategy = :truncation
    begin
      DatabaseCleaner.start
    ensure
      DatabaseCleaner.clean
    end
  end

  config.before(:each) do
    DatabaseCleaner.start
  end

  config.after(:each) do
    DatabaseCleaner.clean
  end
end

VCR.configure do |c|
  c.cassette_library_dir = 'spec/fixtures/vcr_cassettes'
  c.hook_into :webmock
  c.ignore_localhost = true
end
