require 'bootstrap_navbar/version'

module BootstrapNavbar
  def self.current_url_method=(value)
    @current_url_method = value
  end

  def self.current_url_method
    @current_url_method
  end
end

require 'bootstrap_navbar/helpers'
