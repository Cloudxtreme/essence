ENV['RAILS_ENV'] ||= 'test'
require File.expand_path("../../config/environment", __FILE__)
require 'rspec/rails'

require 'capybara/rails'
require 'capybara/rspec'
require 'selenium-webdriver'

require 'shoulda-matchers'

Dir[Rails.root.join('spec/support/**/*.rb')].each { |f| require f }

Capybara.register_driver :firefox do |app|
  profile                                     = Selenium::WebDriver::Firefox::Profile.new
  profile.secure_ssl                          = false
  profile.assume_untrusted_certificate_issuer = false

  client = Selenium::WebDriver::Remote::Http::Default.new
  client.timeout = 300

  Capybara::Selenium::Driver.new(app, browser: :firefox, profile: profile, http_client: client)
end

Capybara.register_driver :chrome do |app|
  client = Selenium::WebDriver::Remote::Http::Default.new
  client.timeout = 300

  Capybara::Selenium::Driver.new(app, browser: :chrome, http_client: client)
end

Capybara.register_driver :phantomjs do |app|
  client = Selenium::WebDriver::Remote::Http::Default.new
  client.timeout = 120
  Capybara::Selenium::Driver.new(app, browser: :phantomjs, http_client: client)
end

Capybara.configure do |config|
  config.default_selector = :css

  config.ignore_hidden_elements = true
  config.match                  = :prefer_exact

  config.default_driver    = :rack_test
  config.javascript_driver = ENV['JS_DRIVER'] ? ENV['JS_DRIVER'].to_sym : :firefox
end

RSpec.configure do |config|
  config.include Support::Integration, type: :feature

  config.mock_with :rspec
  config.use_transactional_fixtures                      = false

  config.before(:each, type: :feature) do
    Capybara.reset_sessions!
    Capybara.current_driver = Capybara.javascript_driver
  end
end
