require 'spec_helper'

describe BootstrapNavbar::Helpers do
  subject do
    Class.new do
      extend BootstrapNavbar::Helpers
    end
  end

  before do
    BootstrapNavbar.current_url_method = -> { '' }
  end

  describe '#nav_bar' do
    context 'div.navbar' do
      context '"static" parameter' do
        it 'generates the correct HTML' do
          subject.nav_bar(static: 'top').should have_tag(:div, with: { class: 'navbar navbar-static-top' })
          subject.nav_bar(static: 'bottom').should have_tag(:div, with: { class: 'navbar navbar-static-bottom' })
        end
      end

      context '"fixed" parameter' do
        it 'generates the correct HTML' do
          subject.nav_bar(fixed: 'top').should have_tag(:div, with: { class: 'navbar navbar-fixed-top' })
          subject.nav_bar(fixed: 'bottom').should have_tag(:div, with: { class: 'navbar navbar-fixed-bottom' })
        end
      end

      context '"inverse" parameter' do
        it 'generates the correct HTML' do
          subject.nav_bar(inverse: true).should have_tag(:div, with: { class: 'navbar navbar-inverse' })
        end
      end

      context 'no parameters' do
        it 'generates the correct HTML' do
          subject.nav_bar.should have_tag(:div, with: { class: 'navbar' })
          subject.nav_bar { 'foo' }.should have_tag(:div, with: { class: 'navbar' }, content: 'foo')
        end
      end
    end

    context 'div.navbar-inner' do
      it 'generates the correct HTML' do
        subject.nav_bar.should have_tag(:div, with: { class: 'navbar-inner' })
      end
    end

    context 'div.container' do
      it 'generates the correct HTML' do
        subject.nav_bar.should have_tag(:div, with: { class: 'container' })
      end
    end

    describe 'brand and brank_link parameters' do
      it 'generates the correct HTML' do
        subject.nav_bar(brand: 'foo').should have_tag(:a, with: { href: '/', class: 'brand' }, content: 'foo')
        subject.nav_bar(brand: 'foo', brand_link: 'http://google.com').should have_tag(:a, with: { href: 'http://google.com', class: 'brand' }, content: 'foo')
        subject.nav_bar(brand_link: 'http://google.com').should have_tag(:a, with: { href: 'http://google.com', class: 'brand' })
      end
    end

    describe '"responsive" parameter' do
      it 'generates the correct HTML' do
        subject.nav_bar(responsive: true).should have_tag(:a, with: { class: 'btn btn-navbar', :'data-toggle' => 'collapse', :'data-target' => '.nav-collapse' }) do
          3.times do
            with_tag :span, with: { class: 'icon-bar' }
          end
        end
      end
    end

    describe '"fluid" parameter' do
      it 'generates the correct HTML' do
        subject.nav_bar(fluid: true).should have_tag(:div, with: { class: 'container-fluid' })
      end
    end
  end

  describe '#menu_group' do
    describe '"pull" parameter' do
      it 'generates the correct HTML' do
        subject.menu_group('right').should have_tag(:ul, with: { class: 'nav pull-right' })
      end
    end

    context 'no parameters' do
      it 'generates the correct HTML' do
        subject.menu_group.should have_tag(:ul, with: { class: 'nav' })
        subject.menu_group { 'foo' }.should have_tag(:ul, with: { class: 'nav' }, content: 'foo')
      end
    end
  end

  describe '#menu_item' do
    context 'with current URL' do
      it 'generates the correct HTML' do
        BootstrapNavbar.current_url_method = -> { '/' }
        subject.menu_item('foo', '/').should have_tag(:li, with: { class: 'active' }) do
          with_tag :a, with: { href: '/' }, content: 'foo'
        end

        BootstrapNavbar.current_url_method = -> { '/foo' }
        subject.menu_item('foo', '/foo').should have_tag(:li, with: { class: 'active' }) do
          with_tag :a, with: { href: '/foo' }, content: 'foo'
        end
      end
    end

    context 'without current URL' do
      it 'generates the correct HTML' do
        BootstrapNavbar.current_url_method = -> { '/foo' }
        subject.menu_item('foo').should have_tag(:li, without: { class: 'active' }) do
          with_tag :a, with: { href: '#' }, content: 'foo'
        end
        subject.menu_item('foo', '/').should have_tag(:li, without: { class: 'active' }) do
          with_tag :a, with: { href: '/' }, content: 'foo'
        end
        subject.menu_item('foo', '/bar').should have_tag(:li, without: { class: 'active' }) do
          with_tag :a, with: { href: '/bar' }, content: 'foo'
        end

        BootstrapNavbar.current_url_method = -> { '/' }
        subject.menu_item('foo', '/foo').should have_tag(:li, without: { class: 'active' }) do
          with_tag :a, with: { href: '/foo' }, content: 'foo'
        end
      end
    end
  end

  describe '#drop_down' do
    it 'generates the correct HTML' do
      subject.drop_down('foo').should have_tag(:li, with: { class: 'dropdown' }) do
        with_tag :a, with: { href: '#', class: 'dropdown-toggle', :'data-toggle' => 'dropdown' } do
          with_text /foo/
          with_tag :b, with: { class: 'caret' }
        end
        with_tag :ul, with: { class: 'dropdown-menu' }
      end

      subject.drop_down('foo') { 'bar' }.should have_tag(:li, with: { class: 'dropdown' }) do
        with_tag :a, with: { href: '#', class: 'dropdown-toggle', :'data-toggle' => 'dropdown' } do
          with_text /foo/
          with_tag :b, with: { class: 'caret' }
        end
        with_tag :ul, with: { class: 'dropdown-menu' }, content: 'bar'
      end
    end
  end

  describe '#drop_down_divider' do
    it 'generates the correct HTML' do
      subject.drop_down_divider.should have_tag(:li, with: { class: 'divider' }, content: '')
    end
  end

  describe '#drop_down_header' do
    it 'generates the correct HTML' do
      subject.drop_down_header('foo').should have_tag(:li, with: { class: 'nav-header' }, content: 'foo')
    end
  end

  describe '#menu_divider' do
    it 'generates the correct HTML' do
      subject.menu_divider.should have_tag(:li, with: { class: 'divider-vertical' }, content: '')
    end
  end

  describe '#menu_text' do
    it 'generates the correct HTML' do
      subject.menu_text('foo').should have_tag(:p, with: { class: 'navbar-text' }, content: 'foo')
      subject.menu_text { 'foo' }.should have_tag(:p, with: { class: 'navbar-text' }, content: 'foo')
      subject.menu_text('foo', 'right').should have_tag(:p, with: { class: 'navbar-text pull-right' }, content: 'foo')
      subject.menu_text(nil, 'left') { 'foo' }.should have_tag(:p, with: { class: 'navbar-text pull-left' }, content: 'foo')
    end
  end

  describe '#brand_link' do
    it 'generates the correct HTML' do
      subject.brand_link('foo').should have_tag(:a, with: { class: 'brand', href: '/' }, content: 'foo')
      subject.brand_link('foo', '/foo').should have_tag(:a, with: { class: 'brand', href: '/foo' }, content: 'foo')
    end
  end
end
