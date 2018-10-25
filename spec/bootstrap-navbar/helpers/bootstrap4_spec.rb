require 'spec_helper'

describe BootstrapNavbar::Helpers::Bootstrap4 do
  before do
    BootstrapNavbar.configure do |config|
      config.current_url_method = '"/"'
      config.bootstrap_version  = '4.0.0'
    end
  end

  it 'includes the correct module' do
    expect(renderer.class.ancestors).to_not include(BootstrapNavbar::Helpers::Bootstrap3)
    expect(renderer.class.ancestors).to_not include(BootstrapNavbar::Helpers::Bootstrap2)
    expect(renderer.class.ancestors).to include(BootstrapNavbar::Helpers::Bootstrap4)
  end

  describe '#navbar' do
    context 'without parameters' do
      it 'generates the correct HTML' do
        expect(renderer.navbar { 'foo' }).to have_tag(:nav, with: { class: 'navbar navbar-dark bg-dark' }, text: /foo/)
      end
    end

    context 'with "color_scheme" parameter' do
      it 'generates the correct HTML' do
        expect(renderer.navbar(color_scheme: 'light')).to have_tag(:nav, with: { class: 'navbar navbar-light bg-dark' })
        expect(renderer.navbar(color_scheme: 'dark')).to have_tag(:nav, with: { class: 'navbar navbar-dark bg-dark' })
      end
    end

    context 'with "bg" parameter' do
      it 'generates the correct HTML' do
        expect(renderer.navbar(bg: 'primary')).to have_tag(:nav, with: { class: 'navbar navbar-dark bg-primary' })
        expect(renderer.navbar(bg: 'dark')).to have_tag(:nav, with: { class: 'navbar navbar-dark bg-dark' })
        expect(renderer.navbar(bg: false)).to have_tag(:nav, with: { class: 'navbar navbar-dark' }, without: { class: 'bg-primary' })
      end
    end

    context 'with "placement" parameter' do
      it 'generates the correct HTML' do
        %w(top bottom).each do |placement|
          expect(renderer.navbar(placement: placement)).to have_tag(:nav, with: { class: "navbar navbar-dark bg-dark fixed-#{placement}" })
        end
      end
    end

    context 'with "container" parameter' do
      it 'generates the correct HTML' do
        expect(renderer.navbar(container: true)).to have_tag(:nav, with: { class: 'navbar navbar-dark bg-dark' }) do
          with_tag :div, with: { class: 'container' }
        end
        expect(renderer.navbar(container: false)).to have_tag(:nav, with: { class: 'navbar navbar-dark bg-dark' }) do
          without_tag :div, with: { class: 'container' }
        end
      end
    end

    context 'with "class" parameter' do
      it 'generates the correct HTML' do
        expect(renderer.navbar(class: 'foo')).to have_tag(:nav, with: { class: 'navbar navbar-dark bg-dark foo' })
      end
    end

    context 'with "brand" parameter' do
      it 'generates the correct HTML' do
        expect(renderer.navbar(brand: 'Huhu')).to have_tag(:nav, with: { class: 'navbar navbar-dark bg-dark' }) do
          with_tag :a, with: { class: 'navbar-brand' }, text: /Huhu/
        end
        expect(renderer.navbar(brand: false)).to have_tag(:nav, with: { class: 'navbar navbar-dark bg-dark' }) do
          without_tag :a, with: { class: 'navbar-brand' }
        end
      end
    end

    context 'with "brand_url" parameter' do
      it 'generates the correct HTML' do
        expect(renderer.navbar(brand: true, brand_url: '/huhu')).to have_tag(:nav, with: { class: 'navbar navbar-dark bg-dark' }) do
          with_tag :a, with: { class: 'navbar-brand', href: '/huhu' }
        end
      end
    end
  end

  describe '#navbar_collapse' do
    context 'without parameters' do
      it 'generates the correct HTML' do
        output = renderer.navbar_collapse { 'foo' }
        expect(output).to have_tag :div, with: { class: 'collapse navbar-collapse', id: 'navbar-collapsable' }, text: /foo/
        button_attributes = {
          class:             'navbar-toggler',
          type:              'button',
          'data-toggle'   => 'collapse',
          'data-target'   => "#navbar-collapsable",
          'aria-controls' => 'navbar-collapsable',
          'aria-expanded' => false,
          'aria-label'    => 'Toggle navigation'
        }
        expect(output).to have_tag :button, with: button_attributes
      end
    end
  end

  describe '#navbar_group' do
    context 'without parameters' do
      it 'generates the correct HTML' do
        expect(renderer.navbar_group).to have_tag(:ul, with: { class: 'navbar-nav' })
      end
    end

    context 'with "class" parameter' do
      it 'generates the correct HTML' do
        expect(renderer.navbar_group(class: 'foo')).to have_tag(:ul, with: { class: 'navbar-nav foo' })
      end
    end
  end

  describe '#navbar_item' do
    #it_behaves_like 'marking the navbar items as active correctly' # TODO

    context 'with block' do
      it 'generates the correct HTML' do
        expect(renderer.navbar_item('/foo', { class: 'list-item' }, class: 'link') { 'link-text' }).to have_tag(:li, with: { class: 'nav-item list-item' }) do
          with_tag :a, with: { href: '/foo', class: 'nav-link link' }, text: /link-text/
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

  describe '#navbar_dropdown' do
    context 'with block' do
      it 'generates the correct HTML' do
        expect(renderer.navbar_dropdown('Foo', 'foo') { 'link-text' }).to have_tag(:li, with: { class: 'nav-item dropdown'}) do
          with_tag :div, with: { class: 'dropdown-menu' }
        end
      end
    end

    context 'with right aligned menu' do
      it 'generates the correct HTML' do
        expect(renderer.navbar_dropdown('Foo', 'foo', { wrapper_class: 'dropdown-menu-right' }) { 'link-text' }).to have_tag(:li, with: { class: 'nav-item dropdown' }) do
          with_tag :div, with: { class: 'dropdown-menu dropdown-menu-right' }
        end
      end
    end
  end
end
