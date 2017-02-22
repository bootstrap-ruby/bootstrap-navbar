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

shared_examples 'marking the navbar items as active correctly' do
  context 'when the navbar item URL is the current root URL or path' do
    it_behaves_like 'marking current URLs as current and non-current URLs as not-current' do
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
        )
      end
      let(:non_current_urls) do
        %w(
          http://www.foobar.com/foo
        )
      end
    end
  end

  context 'when another root path is configured and the navbar item URL is the corresponding root URL or path' do
    before do
      @_previous_root_paths = BootstrapNavbar.configuration.root_paths
      BootstrapNavbar.configuration.root_paths = %w(/custom-root)
    end

    after do
      BootstrapNavbar.configuration.root_paths = @_previous_root_paths
    end

    it_behaves_like 'marking current URLs as current and non-current URLs as not-current' do
      let(:navbar_item_urls) do
        %w(
          http://www.foobar.com/custom-root/
          http://www.foobar.com/custom-root
          /custom-root/
          /custom-root
        )
      end
      let(:current_urls) do
        %w(
          http://www.foobar.com/custom-root/
          http://www.foobar.com/custom-root
        )
      end
      let(:non_current_urls) do
        %w(
          http://www.foobar.com/
          http://www.foobar.com
          http://www.foobar.com/foo/
          http://www.foobar.com/foo
          http://www.foobar.com/custom-root/foo/
          http://www.foobar.com/custom-root/foo
        )
      end
    end
  end

  context 'when the navbar item URL is a sub URL of the current URL' do
    it_behaves_like 'marking current URLs as current and non-current URLs as not-current' do
      let(:navbar_item_urls) do
        %w(
          http://www.foobar.com/foo/
          http://www.foobar.com/foo
          /foo/
          /foo
        )
      end
      let(:current_urls) do
        %w(
          http://www.foobar.com/foo/
          http://www.foobar.com/foo
          http://www.foobar.com/foo/bar/
          http://www.foobar.com/foo/bar
        )
      end
      let(:non_current_urls) do
        %w(
          http://www.foobar.com/
          http://www.foobar.com
          http://www.foobar.com/bar/
          http://www.foobar.com/bar
          http://www.foobar.com/foobar/
          http://www.foobar.com/foobar
          http://www.foobar.com/foobar/bar/
          http://www.foobar.com/foobar/bar
          http://www.foobar.com/foo_bar/
          http://www.foobar.com/foo_bar
          http://www.foobar.com/foo_bar/bar/
          http://www.foobar.com/foo_bar/bar
          http://www.foobar.com/foo-bar/
          http://www.foobar.com/foo-bar
          http://www.foobar.com/foo-bar/bar/
          http://www.foobar.com/foo-bar/bar
          http://www.foobar.com/bar/foo/
          http://www.foobar.com/bar/foo
        )
      end
    end
  end

  context 'when the navbar item URL is an external URL' do
    it_behaves_like 'marking current URLs as current and non-current URLs as not-current' do
      let(:navbar_item_urls) do
        %w(
          http://www.barfoo.com/
          http://www.barfoo.com
        )
      end
      let(:current_urls) { [] }
      let(:non_current_urls) do
        %w(
          http://www.foobar.com/
          http://www.foobar.com
          http://www.foobar.com/foo/
          http://www.foobar.com/foo
        )
      end
    end
  end
end

shared_examples 'marking current URLs as current and non-current URLs as not-current' do
  it 'generates the correct HTML' do
    navbar_item_urls.each do |navbar_item_url|
      puts "Testing navbar item with URL #{navbar_item_url}..."
      current_urls.each do |current_url|
        puts "...should be marked as active when current URL is #{current_url}"
        BootstrapNavbar.configuration.current_url_method = "'#{current_url}'"
        expect(renderer.navbar_item('foo', navbar_item_url)).to have_tag(:li, with: { class: 'active' })
      end
      non_current_urls.each do |non_current_url|
        puts "...should not be marked as active when current URL is #{non_current_url}"
        BootstrapNavbar.configuration.current_url_method = "'#{non_current_url}'"
        expect(renderer.navbar_item('foo', navbar_item_url)).to have_tag(:li, without: { class: 'active' })
      end
    end
  end
end
