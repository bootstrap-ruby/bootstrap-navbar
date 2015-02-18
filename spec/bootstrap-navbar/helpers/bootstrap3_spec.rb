require 'spec_helper'

describe BootstrapNavbar::Helpers::Bootstrap3 do
  before do
    BootstrapNavbar.configure do |config|
      config.current_url_method = '"/"'
      config.bootstrap_version  = '3.0.0'
    end
  end

  it 'includes the correct module' do
    expect(renderer.class.ancestors).to include(BootstrapNavbar::Helpers::Bootstrap3)
    expect(renderer.class.ancestors).to_not include(BootstrapNavbar::Helpers::Bootstrap2)
  end

  describe '#navbar' do
    context 'without parameters' do
      it 'generates the correct HTML' do
        expect(renderer.navbar { 'foo' }).to have_tag(:nav, with: { class: 'navbar navbar-default', role: 'navigation' }, text: /foo/)
      end
    end

    context 'with "inverse" parameter' do
      it 'generates the correct HTML' do
        expect(renderer.navbar(inverse: true)).to have_tag(:nav, with: { class: 'navbar navbar-inverse' })
      end
    end

    context 'with "fixed" parameter' do
      it 'generates the correct HTML' do
        expect(renderer.navbar(fixed: 'top')).to have_tag(:nav, with: { class: 'navbar navbar-default navbar-fixed-top' })
        expect(renderer.navbar(fixed: 'bottom')).to have_tag(:nav, with: { class: 'navbar navbar-default navbar-fixed-bottom' })
      end
    end

    context 'with "static" parameter' do
      it 'generates the correct HTML' do
        expect(renderer.navbar(static: true)).to have_tag(:nav, with: { class: 'navbar navbar-default navbar-static-top' })
      end
    end

    context 'with "container" parameter' do
      it 'generates the correct HTML' do
        expect(renderer.navbar(container: true)).to have_tag(:nav, with: { class: 'navbar navbar-default' }) do
          with_tag :div, with: { class: 'container' }
        end
        expect(renderer.navbar(container: false)).to have_tag(:nav, with: { class: 'navbar navbar-default' }) do
          without_tag :div, with: { class: 'container' }
        end
        with_bootstrap_versions %w(3.1.0) do
          expect(renderer.navbar(container: 'fluid')).to have_tag(:nav, with: { class: 'navbar navbar-default' }) do
            with_tag :div, with: { class: 'container-fluid' }
          end
        end
      end
    end
  end

  describe '#navbar_header' do
    context 'without parameters' do
      it 'generates the correct HTML' do
        expect(renderer.navbar_header { 'foo' }).to have_tag :div, with: { class: 'navbar-header' } do
          with_tag :button, with: { type: 'button', class: 'navbar-toggle', :'data-toggle' => 'collapse', :'data-target' => '#navbar-collapsable' } do
            with_tag :span, with: { class: 'sr-only' }, text: /Toggle navigation/
            3.times do
              with_tag :span, with: { class: 'icon-bar' }
            end
          end
        end
      end
    end

    context 'with "brand" and "brank_link" parameters' do
      it 'generates the correct HTML' do
        expect(renderer.navbar_header(brand: 'foo')).to have_tag(:a, with: { href: '/', class: 'navbar-brand' }, text: /foo/)
        expect(renderer.navbar_header(brand: 'foo', brand_link: 'http://google.com')).to have_tag(:a, with: { href: 'http://google.com', class: 'navbar-brand' }, text: /foo/)
      end
    end

    context 'with "class" parameter' do
      it 'generates the correct HTML' do
        expect(renderer.navbar_header(class: 'bar')).to have_tag :div, with: { class: 'navbar-header bar' }
      end
    end
  end

  describe '#navbar_collapse' do
    context 'without parameters' do
      it 'generates the correct HTML' do
        expect(renderer.navbar_collapse { 'foo' }).to have_tag :div, with: { class: 'collapse navbar-collapse', id: 'navbar-collapsable' }, text: /foo/
      end
    end

    context 'with "class" parameter' do
      it 'generates the correct HTML' do
        expect(renderer.navbar_collapse(class: 'bar')).to have_tag :div, with: { class: 'collapse navbar-collapse bar', id: 'navbar-collapsable' }
      end
    end
  end

  describe '#navbar_group' do
    context 'without parameters' do
      it 'generates the correct HTML' do
        expect(renderer.navbar_group).to have_tag(:ul, with: { class: 'nav navbar-nav' })
      end
    end

    context 'with "align" parameter' do
      it 'generates the correct HTML' do
        expect(renderer.navbar_group(align: 'right')).to have_tag(:ul, with: { class: 'nav navbar-nav navbar-right' })
        expect(renderer.navbar_group(align: 'left')).to have_tag(:ul, with: { class: 'nav navbar-nav navbar-left' })
      end
    end
  end

  describe '#navbar_dropdown' do
    context 'without parameters' do
      it 'generates the correct HTML' do
        expect(renderer.navbar_dropdown('foo') { 'bar' }).to have_tag(:li, with: { class: 'dropdown' }) do
          with_tag :a, with: { href: '#', class: 'dropdown-toggle', :'data-toggle' => 'dropdown' } do
            with_text 'foo '
            with_tag :b, with: { class: 'caret' }
          end
          with_tag :ul, with: { class: 'dropdown-menu' }, text: /bar/
        end
      end
    end

    context 'with list item parameters' do
      it 'generates the correct HTML' do
        expect(renderer.navbar_dropdown('foo', class: 'list-item-class', id: 'list-item-id') { 'bar' }).to have_tag(:li, with: { class: 'dropdown list-item-class', id: 'list-item-id' }) do
          with_tag :a, with: { href: '#', class: 'dropdown-toggle', :'data-toggle' => 'dropdown' } do
            with_text 'foo '
            with_tag :b, with: { class: 'caret' }
          end
          with_tag :ul, with: { class: 'dropdown-menu' }, text: /bar/
        end
      end
    end

    context 'with link parameters' do
      it 'generates the correct HTML' do
        expect(renderer.navbar_dropdown('foo', {}, class: 'link-class', id: 'link-id') { 'bar' }).to have_tag(:li, with: { class: 'dropdown' }) do
          with_tag :a, with: { href: '#', class: 'dropdown-toggle link-class', id: 'link-id', :'data-toggle' => 'dropdown' } do
            with_text 'foo '
            with_tag :b, with: { class: 'caret' }
          end
          with_tag :ul, with: { class: 'dropdown-menu' }, text: /bar/
        end
      end
    end

    context 'with list item parameters and link parameters' do
      it 'generates the correct HTML' do
        expect(renderer.navbar_dropdown('foo', { class: 'list-item-class', id: 'list-item-id' }, class: 'link-class', id: 'link-id') { 'bar' }).to have_tag(:li, with: { class: 'dropdown list-item-class', id: 'list-item-id' }) do
          with_tag :a, with: { href: '#', class: 'dropdown-toggle link-class', id: 'link-id', :'data-toggle' => 'dropdown' } do
            with_text 'foo '
            with_tag :b, with: { class: 'caret' }
          end
          with_tag :ul, with: { class: 'dropdown-menu' }, text: /bar/
        end
      end
    end
  end

  describe '#navbar_item' do
    it_behaves_like 'marking the navbar items as active correctly'

    context 'with block' do
      it 'generates the correct HTML' do
        expect(renderer.navbar_item('/foo', { class: 'list-item' }, class: 'link') { 'link-text' }).to have_tag(:li, with: { class: 'list-item' }) do
          with_tag :a, with: { href: '/foo', class: 'link' }, text: /link-text/
        end
      end
    end

    context 'without current URL' do
      it 'generates the correct HTML' do
        BootstrapNavbar.configuration.current_url_method = '"/foo"'
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
    end
  end

  describe '#navbar_form' do
    let(:url) { '/foo' }

    context 'without additional parameters' do
      it 'generates the correct HTML' do
        expect(renderer.navbar_form(url) { 'foo' }).to have_tag(:form, with: { action: url, class: 'navbar-form', role: 'form' }, text: /foo/)
      end
    end

    context 'with "align" parameter' do
      it 'generates the correct HTML' do
        expect(renderer.navbar_form(url, align: 'left') { 'foo' }).to have_tag(:form, with: { action: url, class: 'navbar-form navbar-left', role: 'form' }, text: /foo/)
      end
    end
  end

  describe '#navbar_text' do
    context 'without parameters' do
      it 'raises an error' do
        expect { renderer.navbar_text }.to raise_error(StandardError, 'Please provide either the "text" parameter or a block.')
      end
    end

    context 'with "text" parameter and a block' do
      it 'raises an error' do
        expect { renderer.navbar_text }.to raise_error(StandardError, 'Please provide either the "text" parameter or a block.')
      end
    end

    context 'with "text" parameter' do
      it 'generates the correct HTML' do
        expect(renderer.navbar_text('foo')).to have_tag(:p, with: { class: 'navbar-text' }, text: /foo/)
      end
    end

    context 'with block' do
      it 'generates the correct HTML' do
        expect(renderer.navbar_text { 'foo' }).to have_tag(:p, with: { class: 'navbar-text' }, text: /foo/)
      end
    end
  end

  describe '#navbar_button' do
    context 'without parameters' do
      it 'generates the correct HTML' do
        expect(renderer.navbar_button('foo')).to have_tag(:button, with: { class: 'btn navbar-btn', type: 'button' }, text: /foo/)
      end
    end

    context 'with "class" parameter' do
      it 'generates the correct HTML' do
        expect(renderer.navbar_button('foo', class: 'bar')).to have_tag(:button, with: { class: 'btn navbar-btn bar', type: 'button' }, text: /foo/)
      end
    end
  end
end
