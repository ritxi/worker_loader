# encoding: utf-8

require 'rspec'
require 'factory_girl_rails'
require 'workers_loader'

Rails.backtrace_cleaner.remove_silencers!

# Load support files
Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each { |f| require f }

RSpec.configure do |config|
  config.mock_with :rspec

  config.order = 'random'
end
