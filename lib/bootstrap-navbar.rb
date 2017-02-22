require 'gem_config'

module BootstrapNavbar
  include GemConfig::Base

  with_configuration do
    has :bootstrap_version,  classes: String
    has :current_url_method, classes: String
    has :root_paths,         classes: Array, default: %w(/)
  end
end

require_relative 'bootstrap-navbar/version'
require_relative 'bootstrap-navbar/helpers'
require_relative 'bootstrap-navbar/helpers/bootstrap2'
require_relative 'bootstrap-navbar/helpers/bootstrap3'
require_relative 'bootstrap-navbar/helpers/bootstrap4'
