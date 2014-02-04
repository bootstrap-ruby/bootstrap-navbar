require 'padrino-helpers'

module Helpers
  def renderer
    @renderer ||= Class.new do
      include Padrino::Helpers::OutputHelpers
      include BootstrapNavbar::Helpers
    end.new
  end

  def with_all_2_dot_x_versions(&block)
    with_versions '2'...'3', &block
  end

  def with_all_3_dot_x_versions(&block)
    with_versions '3'...'4', &block
  end

  def with_version(version, &block)
    with_versions version..version, &block
  end

  def with_versions(versions, &block)
    BootstrapNavbar::BOOTSTRAP_VERSIONS.each do |version|
      next unless versions.cover?(version)
      puts "Testing version #{version}..."
      BootstrapNavbar.configuration.bootstrap_version = version
      block.call
    end
  end
end
