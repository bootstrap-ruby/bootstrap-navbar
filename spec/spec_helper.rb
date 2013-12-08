require 'bootstrap-navbar'
require 'rspec-html-matchers'

Dir[File.expand_path('../support/**/*.rb', __FILE__)].each { |f| require f }

RSpec.configure do |config|
  config.treat_symbols_as_metadata_keys_with_true_values = true
  config.run_all_when_everything_filtered = true
  config.filter_run :focus
  config.order = 'random'
  config.include ::Helpers
end
