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

  def with_versions(versions, &block)
    versions = case versions
    when String
      raise "#{versions} is not a valid version!" unless BootstrapNavbar::BOOTSTRAP_VERSIONS.include?(versions)
      [versions]
    when Range
      BootstrapNavbar::BOOTSTRAP_VERSIONS.select do |version|
        versions.cover?(version)
      end
    else
      raise "Please pass a string or a range to this method, not a #{versions.class}."
    end

    versions.each do |version|
      puts "Testing version #{version}..."
      BootstrapNavbar.configuration.bootstrap_version = version
      block.call
    end
  end
end
