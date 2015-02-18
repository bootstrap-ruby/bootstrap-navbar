require_relative '../lib/bootstrap-navbar'
require 'rspec-html-matchers'

module Padrino
  IGNORE_NO_RENDERING_ENGINE = true
end
require 'padrino-helpers'

Dir[File.expand_path('../support/**/*.rb', __FILE__)].each { |f| require f }

RSpec.configure do |config|
  config.run_all_when_everything_filtered = true
  config.filter_run :focus
  config.order = 'random'
  config.include ::Helpers
  config.include RSpecHtmlMatchers
end
