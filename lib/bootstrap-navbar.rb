require 'gem_config'

module BootstrapNavbar
  include GemConfig::Base

  BOOTSTRAP_VERSIONS = %w(3.0.1 3.0.0 2.3.1 2.3.0 2.2.2 2.2.1 2.2.0 2.1.1 2.1.0 2.0.4 2.0.3 2.0.2 2.0.1 2.0.0)

  with_configuration do
    has :bootstrap_version, classes: String, values: BOOTSTRAP_VERSIONS
    has :current_url_method, classes: String
  end
end

require_relative 'bootstrap-navbar/version'
require_relative 'bootstrap-navbar/helpers'
require_relative 'bootstrap-navbar/helpers/bootstrap2'
require_relative 'bootstrap-navbar/helpers/bootstrap3'
