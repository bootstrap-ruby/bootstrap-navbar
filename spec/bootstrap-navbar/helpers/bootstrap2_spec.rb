require 'spec_helper'

describe BootstrapNavbar::Helpers::Bootstrap2 do
  before do
    BootstrapNavbar.configure do |config|
      config.current_url_method = '"/"'
      config.bootstrap_version  = '2.0.0'
    end
  end

  it 'includes the correct module' do
    expect(renderer.class.ancestors).to include(BootstrapNavbar::Helpers::Bootstrap2)
    expect(renderer.class.ancestors).to_not include(BootstrapNavbar::Helpers::Bootstrap3)
  end

  describe '#navbar' do
    context 'without parameters' do
      it 'generates the correct HTML' do
        expect(renderer.navbar).to have_tag(:div, with: { class: 'navbar' }) do
          with_tag :div, with: { class: 'navbar-inner' } do
            with_tag :div, with: { class: 'container' }
          end
        end
      end
    end

    context 'with a block' do
      it 'generates the correct HTML' do
        expect(renderer.navbar { 'foo' }).to have_tag(:div, with: { class: 'navbar' }, text: /foo/)
      end
    end

    context 'with "static" parameter' do
      it 'generates the correct HTML' do
        expect(renderer.navbar(static: 'top')).to have_tag(:div, with: { class: 'navbar navbar-static-top' })
        expect(renderer.navbar(static: 'bottom')).to have_tag(:div, with: { class: 'navbar navbar-static-bottom' })
      end
    end

    context 'with "fixed" parameter' do
      it 'generates the correct HTML' do
        expect(renderer.navbar(fixed: 'top')).to have_tag(:div, with: { class: 'navbar navbar-fixed-top' })
        expect(renderer.navbar(fixed: 'bottom')).to have_tag(:div, with: { class: 'navbar navbar-fixed-bottom' })
      end
    end

    context 'with "inverse" parameter' do
      it 'generates the correct HTML' do
        expect(renderer.navbar(inverse: true)).to have_tag(:div, with: { class: 'navbar navbar-inverse' })
      end
    end

    context 'with "brand" and "brank_link" parameters' do
      it 'generates the correct HTML' do
        expect(renderer.navbar(brand: 'foo')).to have_tag(:a, with: { href: '/', class: 'brand' }, text: /foo/)
        expect(renderer.navbar(brand: 'foo', brand_link: 'http://google.com')).to have_tag(:a, with: { href: 'http://google.com', class: 'brand' }, text: /foo/)
        expect(renderer.navbar(brand_link: 'http://google.com')).to have_tag(:a, with: { href: 'http://google.com', class: 'brand' })
      end
    end

    context 'with "responsive" parameter' do
      it 'generates the correct HTML' do
        expect(renderer.navbar(responsive: true)).to have_tag(:a, with: { class: 'btn btn-navbar', :'data-toggle' => 'collapse', :'data-target' => '.nav-collapse' }) do
          3.times do
            with_tag :span, with: { class: 'icon-bar' }
          end
        end
        with_bootstrap_versions %w(2.2.0 2.2.1 2.2.2 2.3.0 2.3.1 2.3.2) do
          expect(renderer.navbar(responsive: true)).to have_tag(:div, with: { class: 'nav-collapse collapse' })
        end
        with_bootstrap_versions %w(2.0.0 2.0.1 2.0.2 2.0.3 2.0.4 2.1.0 2.1.1) do
          expect(renderer.navbar(responsive: true)).to have_tag(:div, with: { class: 'nav-collapse' })
        end
      end
    end

    context 'with "fluid" parameter' do
      it 'generates the correct HTML' do
        expect(renderer.navbar(fluid: true)).to have_tag(:div, with: { class: 'container-fluid' })
      end
    end

    context 'with wrapper parameters' do
      it 'generates the correct HTML' do
        expect(renderer.navbar({}, class: 'my-wrapper-class', id: 'my-wrapper-id')).to have_tag(:div, with: { class: 'navbar my-wrapper-class', id: 'my-wrapper-id' })
      end
    end
  end

  describe '#navbar_group' do
    context 'without parameters' do
      it 'generates the correct HTML' do
        expect(renderer.navbar_group).to have_tag(:ul, with: { class: 'nav' })
        expect(renderer.navbar_group { 'foo' }).to have_tag(:ul, with: { class: 'nav' }, text: /foo/)
      end
    end

    context 'with "pull" parameter' do
      it 'generates the correct HTML' do
        expect(renderer.navbar_group(pull: 'right')).to have_tag(:ul, with: { class: 'nav pull-right' })
      end
    end

    context 'with "class" parameter' do
      it 'generates the correct HTML' do
        expect(renderer.navbar_group(class: 'foo')).to have_tag(:ul, with: { class: 'nav foo' })
      end
    end

    context 'with random parameters' do
      it 'generates the correct HTML' do
        expect(renderer.navbar_group(:'data-foo' => 'bar')).to have_tag(:ul, with: { class: 'nav', :'data-foo' => 'bar' })
      end
    end

    context 'with many parameters' do
      it 'generates the correct HTML' do
        expect(renderer.navbar_group(pull: 'right', class: 'foo', :'data-foo' => 'bar')).to have_tag(:ul, with: { class: 'nav foo pull-right', :'data-foo' => 'bar' })
      end
    end
  end

  describe '#navbar_item' do
    it_behaves_like 'marking the navbar items as active correctly'

    context 'with root URL' do
      context 'with list item options' do
        it 'generates the correct HTML' do
          BootstrapNavbar.configuration.current_url_method = '"/"'
          expect(renderer.navbar_item('foo', '/', class: 'bar', id: 'baz')).to have_tag(:li, with: { class: 'active bar', id: 'baz' })
        end
      end

      context 'with link options' do
        it 'generates the correct HTML' do
          BootstrapNavbar.configuration.current_url_method = '"/"'
          expect(renderer.navbar_item('foo', '/', {}, class: 'pelle', id: 'fant')).to have_tag(:li, with: { class: 'active' }) do
            with_tag :a, with: { href: '/', class: 'pelle', id: 'fant' }, text: /foo/
          end
        end
      end

      context 'with list item options and link options' do
        it 'generates the correct HTML' do
          BootstrapNavbar.configuration.current_url_method = '"/"'
          expect(renderer.navbar_item('foo', '/', { class: 'bar', id: 'baz' }, class: 'pelle', id: 'fant')).to have_tag(:li, with: { class: 'active bar', id: 'baz' }) do
            with_tag :a, with: { href: '/', class: 'pelle', id: 'fant' }, text: /foo/
          end
        end
      end
    end

    context 'without current URL' do
      it 'generates the correct HTML' do
        BootstrapNavbar.configuration.current_url_method = '"/foo"'
        expect(renderer.navbar_item('foo')).to have_tag(:li, without: { class: 'active' }) do
          with_tag :a, with: { href: '#' }, text: /foo/
        end
        expect(renderer.navbar_item('foo', '/')).to have_tag(:li, without: { class: 'active' }) do
          with_tag :a, with: { href: '/' }, text: /foo/
        end
        expect(renderer.navbar_item('foo', '/bar')).to have_tag(:li, without: { class: 'active' }) do
          with_tag :a, with: { href: '/bar' }, text: /foo/
        end
        BootstrapNavbar.configuration.current_url_method = '"/"'
        expect(renderer.navbar_item('foo', '/foo')).to have_tag(:li, without: { class: 'active' }) do
          with_tag :a, with: { href: '/foo' }, text: /foo/
        end
      end

      context 'with list item options' do
        it 'generates the correct HTML' do
          BootstrapNavbar.configuration.current_url_method = '"/foo"'
          expect(renderer.navbar_item('foo', '/', class: 'bar', id: 'baz')).to have_tag(:li, without: { class: 'active' }, with: { class: 'bar', id: 'baz' })
        end
      end
    end

    context 'with a block' do
      it 'generates the correct HTML' do
        expect(renderer.navbar_item { 'bar' }).to have_tag(:li) do
          with_tag :a, with: { href: '#' }, text: /bar/
        end
      end

      context 'with list item options' do
        it 'generates the correct HTML' do
          expect(renderer.navbar_item('/foo', class: 'pelle', id: 'fant') { 'bar' }).to have_tag(:li, with: { class: 'pelle', id: 'fant' }) do
            with_tag :a, with: { href: '/foo' }, text: /bar/
          end
        end
      end

      context 'with link options' do
        it 'generates the correct HTML' do
          expect(renderer.navbar_item('/foo', {}, class: 'pelle', id: 'fant') { 'bar' }).to have_tag(:li) do
            with_tag :a, with: { href: '/foo', class: 'pelle', id: 'fant' }, text: /bar/
          end
        end
      end

      context 'with list item options and link options' do
        it 'generates the correct HTML' do
          expect(renderer.navbar_item('/foo', { class: 'bar', id: 'baz' }, class: 'pelle', id: 'fant') { 'shnoo' }).to have_tag(:li, with: { class: 'bar', id: 'baz' }) do
            with_tag :a, with: { href: '/foo', class: 'pelle', id: 'fant' }, text: /shnoo/
          end
        end
      end
    end
  end

  context 'dropdowns' do
    def with_dropdown_menu(content = nil)
      options = { with: { class: 'dropdown-menu' } }
      options[:content] = content unless content.nil?
      with_tag :ul, options
    end

    describe '#navbar_dropdown' do
      it 'generates the correct HTML' do
        expect(renderer.navbar_dropdown('foo')).to have_tag(:li, with: { class: 'dropdown' }) do
          with_tag :a, with: { href: '#', class: 'dropdown-toggle', :'data-toggle' => 'dropdown' } do
            with_text /foo/
            with_tag :b, with: { class: 'caret' }
          end
          with_dropdown_menu
        end

        expect(renderer.navbar_dropdown('foo') { 'bar' }).to have_tag(:li, with: { class: 'dropdown' }) do
          with_tag :a, with: { href: '#', class: 'dropdown-toggle', :'data-toggle' => 'dropdown' } do
            with_text /foo/
            with_tag :b, with: { class: 'caret' }
          end
          with_dropdown_menu('bar')
        end
      end
    end

    describe '#navbar_sub_dropdown' do
      it 'generates the correct HTML' do
        expect(renderer.navbar_sub_dropdown('foo')).to have_tag(:li, with: { class: 'dropdown-submenu' }) do
          with_tag :a, with: { href: '#' }, text: /foo/
          with_dropdown_menu
        end

        expect(renderer.navbar_sub_dropdown('foo') { 'bar' }).to have_tag(:li, with: { class: 'dropdown-submenu' }) do
          with_tag :a, with: { href: '#' }, text: /foo/
          with_dropdown_menu('bar')
        end
      end

      context 'with list item options' do
        it 'generates the correct HTML' do
          expect(renderer.navbar_sub_dropdown('foo', class: 'bar', id: 'baz')).to have_tag(:li, with: { class: 'dropdown-submenu bar', id: 'baz' }) do
            with_tag :a, with: { href: '#' }, text: /foo/
          end
        end
      end

      context 'with link options' do
        it 'generates the correct HTML' do
          expect(renderer.navbar_sub_dropdown('foo', {}, class: 'pelle', id: 'fant')).to have_tag(:li, with: { class: 'dropdown-submenu' }) do
            with_tag :a, with: { href: '#', class: 'pelle', id: 'fant' }, text: /foo/
          end
        end
      end

      context 'with list item options and link options' do
        it 'generates the correct HTML' do
          expect(renderer.navbar_sub_dropdown('foo', { class: 'bar', id: 'baz' }, class: 'pelle', id: 'fant')).to have_tag(:li, with: { class: 'dropdown-submenu bar', id: 'baz' }) do
            with_tag :a, with: { href: '#', class: 'pelle', id: 'fant' }, text: /foo/
          end
        end
      end
    end
  end

  describe '#navbar_dropdown_divider' do
    it 'generates the correct HTML' do
      expect(renderer.navbar_dropdown_divider).to have_tag(:li, with: { class: 'divider' }, text: '')
    end
  end

  describe '#navbar_dropdown_header' do
    it 'generates the correct HTML' do
      expect(renderer.navbar_dropdown_header('foo')).to have_tag(:li, with: { class: 'nav-header' }, text: /foo/)
    end
  end

  describe '#navbar_divider' do
    it 'generates the correct HTML' do
      expect(renderer.navbar_divider).to have_tag(:li, with: { class: 'divider-vertical' }, text: '')
    end
  end

  describe '#navbar_text' do
    it 'generates the correct HTML' do
      expect(renderer.navbar_text('foo')).to have_tag(:p, with: { class: 'navbar-text' }, text: /foo/)
      expect(renderer.navbar_text { 'foo' }).to have_tag(:p, with: { class: 'navbar-text' }, text: /foo/)
      expect(renderer.navbar_text('foo', 'right')).to have_tag(:p, with: { class: 'navbar-text pull-right' }, text: /foo/)
      expect(renderer.navbar_text(nil, 'left') { 'foo' }).to have_tag(:p, with: { class: 'navbar-text pull-left' }, text: /foo/)
    end
  end

  describe '#navbar_brand_link' do
    it 'generates the correct HTML' do
      expect(renderer.navbar_brand_link('foo')).to have_tag(:a, with: { class: 'brand', href: '/' }, text: /foo/)
      expect(renderer.navbar_brand_link('foo', '/foo')).to have_tag(:a, with: { class: 'brand', href: '/foo' }, text: /foo/)
    end
  end
end
