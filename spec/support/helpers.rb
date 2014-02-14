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

shared_examples 'marking the menu items as active correctly' do
  context 'when URL is the root URL' do
    it_behaves_like 'marking current URLs as current and non-current ones not' do
      let(:navbar_item_urls) do
        %w(
          http://www.foobar.com/
          http://www.foobar.com
          /
        )
      end
      let(:current_urls) do
        %w(
          http://www.foobar.com/
          http://www.foobar.com
          /
        )
      end
      let(:non_current_urls) do
        %w(
          http://www.foobar.com/foo
          /foo
        )
      end
    end
  end

  context 'when URL is a sub URL' do
    it_behaves_like 'marking current URLs as current and non-current ones not' do
      let(:navbar_item_urls) do
        %w(
          http://www.foobar.com/foo/
          http://www.foobar.com/foo
          /foo
          /foo/
        )
      end
      let(:current_urls) do
        %w(
          http://www.foobar.com/foo/
          http://www.foobar.com/foo
          /foo
          /foo/

          http://www.foobar.com/foo/bar/
          http://www.foobar.com/foo/bar
          /foo/bar
          /foo/bar/
        )
      end
      let(:non_current_urls) do
        %w(
          http://www.foobar.com/
          http://www.foobar.com
          /

          http://www.foobar.com/bar/
          http://www.foobar.com/bar
          /bar
          /bar/
        )
      end
    end
  end
end

shared_examples 'marking current URLs as current and non-current ones not' do
  it 'generates the correct HTML' do
    navbar_item_urls.each do |navbar_item_url|
      current_urls.each do |current_url|
        BootstrapNavbar.configuration.current_url_method = "'#{current_url}'"
        expect(renderer.navbar_item('foo', navbar_item_url)).to have_tag(:li, with: { class: 'active' })
      end
      non_current_urls.each do |non_current_url|
        BootstrapNavbar.configuration.current_url_method = "'#{non_current_url}'"
        expect(renderer.navbar_item('foo', navbar_item_url)).to have_tag(:li, without: { class: 'active' })
      end
    end
  end
end
