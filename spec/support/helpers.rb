require 'padrino-helpers'

module Helpers
  def renderer
    @renderer ||= Class.new do
      include Padrino::Helpers::OutputHelpers
      include BootstrapNavbar::Helpers
    end.new
  end

  def with_bootstrap_versions(versions, &block)
    versions.each do |version|
      puts "Testing Bootstrap version #{version}..."
      BootstrapNavbar.configuration.bootstrap_version = version
      block.call
    end
  end
end
