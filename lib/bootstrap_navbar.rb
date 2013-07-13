require 'bootstrap_navbar/version'

module BootstrapNavbar
  def self.current_url_method=(value)
    raise StandardError, '`current_url_method` must be an object that responds to `#call`' unless value.respond_to?(:call)
    @current_url_method = value
  end

  def self.current_url_method
    @current_url_method
  end
end

require 'bootstrap_navbar/helpers'
