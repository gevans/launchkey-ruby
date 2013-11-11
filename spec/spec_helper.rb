$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))

unless ENV['CI']
  require 'simplecov'
  SimpleCov.start do
    add_filter '/spec/'
  end
end

require 'rspec'
require 'ffaker'
require 'factory_girl'

require 'launchkey'

ENV['LAUNCHKEY_TEST_USER'] ||= ENV['USER']

RSpec.configure do |config|
  include FactoryGirl::Syntax::Methods

  config.before(:suite) do
    FactoryGirl.find_definitions
    LaunchKeyHelpers.load_config
  end

  # Run specs in random order to surface order dependencies. If you find an
  # order dependency and want to debug it, you can fix the order by providing
  # the seed, which is printed after each run.
  #     --seed 1234
  config.order = 'random'

  if ENV['TRAVIS_SECURE_ENV_VARS'] != 'true'
    config.filter_run_excluding external: true
  end

  config.filter_run focus: true unless ENV['CI']
  config.run_all_when_everything_filtered = true
  config.treat_symbols_as_metadata_keys_with_true_values = true
  config.expect_with(:rspec) { |c| c.syntax = :expect }
end

# Requires supporting files with custom matchers and macros, etc,
# in ./support/ and its subdirectories.
Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each { |f| require f }
