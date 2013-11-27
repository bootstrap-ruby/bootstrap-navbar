require 'bootstrap-navbar'

module BootstrapNavbar
  class Railtie < Rails::Railtie
    config.after_initialize do
      # If Bootstrap version isn't set yet and the gem bootstrap-sass is loaded, sniff the Bootstrap version from it
      if BootstrapNavbar.configuration.bootstrap_version.nil? && Gem.loaded_specs.keys.include?('bootstrap-sass')
        bootstrap_sass_version = Gem.loaded_specs['bootstrap-sass'].version
        bootstrap_version = bootstrap_sass_version.segments.take(3).join('.')
        BootstrapNavbar.configure do |config|
          config.bootstrap_version = bootstrap_version
        end
      end
    end
  end
end
