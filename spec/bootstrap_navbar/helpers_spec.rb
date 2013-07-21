require 'spec_helper'
require 'padrino-helpers'

shared_examples 'active menu item' do
  it 'generates the correct HTML' do
    paths_and_urls.each do |current_path_or_url|
      paths_and_urls.each do |menu_path_or_url|
        BootstrapNavbar.current_url_method = "'#{current_path_or_url}'"
        subject.menu_item('foo', menu_path_or_url).should have_tag(:li, with: { class: 'active' })
      end
    end
  end
end

describe BootstrapNavbar::Helpers do
  subject do
    Class.new do
      include Padrino::Helpers::OutputHelpers
      include BootstrapNavbar::Helpers
    end.new
  end

  before do
    BootstrapNavbar.current_url_method = ''
  end

  describe '#nav_bar' do
    context 'without parameters' do
      it 'generates the correct HTML' do
        subject.nav_bar.should have_tag(:div, with: { class: 'navbar' }) do
          with_tag :div, with: { class: 'navbar-inner' } do
            with_tag :div, with: { class: 'container' }
          end
        end
      end
    end

    context 'with block' do
      it 'generates the correct HTML' do
        subject.nav_bar { 'foo' }.should have_tag(:div, with: { class: 'navbar' }, content: 'foo')
      end
    end

    context 'with "static" parameter' do
      it 'generates the correct HTML' do
        subject.nav_bar(static: 'top').should have_tag(:div, with: { class: 'navbar navbar-static-top' })
        subject.nav_bar(static: 'bottom').should have_tag(:div, with: { class: 'navbar navbar-static-bottom' })
      end
    end

    context 'with "fixed" parameter' do
      it 'generates the correct HTML' do
        subject.nav_bar(fixed: 'top').should have_tag(:div, with: { class: 'navbar navbar-fixed-top' })
        subject.nav_bar(fixed: 'bottom').should have_tag(:div, with: { class: 'navbar navbar-fixed-bottom' })
      end
    end

    context 'with "inverse" parameter' do
      it 'generates the correct HTML' do
        subject.nav_bar(inverse: true).should have_tag(:div, with: { class: 'navbar navbar-inverse' })
      end
    end

    context 'with "brand" and "brank_link" parameters' do
      it 'generates the correct HTML' do
        subject.nav_bar(brand: 'foo').should have_tag(:a, with: { href: '/', class: 'brand' }, content: 'foo')
        subject.nav_bar(brand: 'foo', brand_link: 'http://google.com').should have_tag(:a, with: { href: 'http://google.com', class: 'brand' }, content: 'foo')
        subject.nav_bar(brand_link: 'http://google.com').should have_tag(:a, with: { href: 'http://google.com', class: 'brand' })
      end
    end

    context 'with "responsive" parameter' do
      it 'generates the correct HTML' do
        subject.nav_bar(responsive: true).should have_tag(:a, with: { class: 'btn btn-navbar', :'data-toggle' => 'collapse', :'data-target' => '.nav-collapse' }) do
          3.times do
            with_tag :span, with: { class: 'icon-bar' }
          end
        end
      end
    end

    context 'with "fluid" parameter' do
      it 'generates the correct HTML' do
        subject.nav_bar(fluid: true).should have_tag(:div, with: { class: 'container-fluid' })
      end
    end
  end

  describe '#menu_group' do
    context 'without parameters' do
      it 'generates the correct HTML' do
        subject.menu_group.should have_tag(:ul, with: { class: 'nav' })
        subject.menu_group { 'foo' }.should have_tag(:ul, with: { class: 'nav' }, content: 'foo')
      end
    end

    context 'with "pull" parameter' do
      it 'generates the correct HTML' do
        subject.menu_group(pull: 'right').should have_tag(:ul, with: { class: 'nav pull-right' })
      end
    end

    context 'with "class" parameter' do
      it 'generates the correct HTML' do
        subject.menu_group(class: 'foo').should have_tag(:ul, with: { class: 'nav foo' })
      end
    end

    context 'with random parameters' do
      it 'generates the correct HTML' do
        subject.menu_group(:'data-foo' => 'bar').should have_tag(:ul, with: { class: 'nav', :'data-foo' => 'bar' })
      end
    end

    context 'with many parameters' do
      it 'generates the correct HTML' do
        subject.menu_group(pull: 'right', class: 'foo', :'data-foo' => 'bar').should have_tag(:ul, with: { class: 'nav foo pull-right', :'data-foo' => 'bar' })
      end
    end
  end

  describe '#menu_item' do
    context 'with current URL or path',:focus do
      # With root URL or path
      it_behaves_like 'active menu item' do
        let(:paths_and_urls) do
          %w(
            http://www.foobar.com/
            http://www.foobar.com
            /
            http://www.foobar.com/?foo=bar
            http://www.foobar.com?foo=bar
            /?foo=bar
            http://www.foobar.com/#foo
            http://www.foobar.com#foo
            /#foo
            http://www.foobar.com/#foo?foo=bar
            http://www.foobar.com#foo?foo=bar
            /#foo?foo=bar
          )
        end
      end

      # With sub URL or path
      it_behaves_like 'active menu item' do
        let(:paths_and_urls) do
          %w(
            http://www.foobar.com/foo
            http://www.foobar.com/foo/
            /foo
            /foo/
            http://www.foobar.com/foo?foo=bar
            http://www.foobar.com/foo/?foo=bar
            /foo?foo=bar
            /foo/?foo=bar
            http://www.foobar.com/foo#foo
            http://www.foobar.com/foo/#foo
            /foo#foo
            /foo/#foo
            http://www.foobar.com/foo#foo?foo=bar
            http://www.foobar.com/foo/#foo?foo=bar
            /foo#foo?foo=bar
            /foo/#foo?foo=bar
          )
        end
      end

      context 'with list item options' do
        it 'generates the correct HTML' do
          BootstrapNavbar.current_url_method = '"/"'
          subject.menu_item('foo', '/', class: 'bar', id: 'baz').should have_tag(:li, with: { class: 'active bar', id: 'baz' })
        end
      end
    end

    context 'without current URL' do
      it 'generates the correct HTML' do
        BootstrapNavbar.current_url_method = '"/foo"'
        subject.menu_item('foo').should have_tag(:li, without: { class: 'active' }) do
          with_tag :a, with: { href: '#' }, content: 'foo'
        end
        subject.menu_item('foo', '/').should have_tag(:li, without: { class: 'active' }) do
          with_tag :a, with: { href: '/' }, content: 'foo'
        end
        subject.menu_item('foo', '/bar').should have_tag(:li, without: { class: 'active' }) do
          with_tag :a, with: { href: '/bar' }, content: 'foo'
        end

        BootstrapNavbar.current_url_method = '"/"'
        subject.menu_item('foo', '/foo').should have_tag(:li, without: { class: 'active' }) do
          with_tag :a, with: { href: '/foo' }, content: 'foo'
        end
      end

      context 'with list item options' do
        it 'generates the correct HTML' do
          BootstrapNavbar.current_url_method = '"/foo"'
          subject.menu_item('foo', '/', class: 'bar', id: 'baz').should have_tag(:li, without: { class: 'active' }, with: { class: 'bar', id: 'baz' })
        end
      end
    end

    context 'with a block' do
      it 'generates the correct HTML' do
        subject.menu_item('/foo') { 'bar' }.should have_tag(:li) do
          with_tag :a, with: { href: '/foo' }, content: 'bar'
        end
      end

      it 'raises an error when name and path are passed' do
        expect do
          subject.menu_item('bar', '/foo') { 'bar' }
        end.to raise_error
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
