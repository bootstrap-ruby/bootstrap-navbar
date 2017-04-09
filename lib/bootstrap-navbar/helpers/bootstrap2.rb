module BootstrapNavbar::Helpers::Bootstrap2
  def navbar(options = {}, wrapper_options = {}, &block)
    wrapper options, wrapper_options do
      inner_wrapper do
        container options[:brand], options[:brand_link], options[:responsive], options[:fluid], &block
      end
    end
  end

  def navbar_group(options = {}, &block)
    options = options.dup
    options[:class] = [options[:class], 'nav'].compact
    options[:class] << "pull-#{options.delete(:pull)}" if options.key?(:pull)
    options[:class] = options[:class].join(' ')
    attributes = attributes_for_tag(options)
    prepare_html <<-HTML.chomp!
<ul#{attributes}>
  #{capture(&block) if block_given?}
</ul>
HTML
  end

  def navbar_item(name = nil, path = nil, list_item_options = nil, link_options = nil, &block)
    name, path, list_item_options, link_options = capture(&block), name, path, list_item_options if block_given?
    path ||= '#'
    list_item_options   = list_item_options ? list_item_options.dup : {}
    link_options        = link_options      ? link_options.dup      : {}
    list_item_options[:class] = [list_item_options[:class]].compact
    list_item_options[:class] << 'active' if current_url_or_sub_url?(path)
    list_item_options[:class] = list_item_options[:class].join(' ')
    list_item_attributes = attributes_for_tag(list_item_options)
    link_attributes      = attributes_for_tag(link_options)
    prepare_html <<-HTML.chomp!
<li#{list_item_attributes}>
  <a href="#{path}"#{link_attributes}>
    #{name}
  </a>
</li>
HTML
  end

  def navbar_dropdown(name, &block)
    prepare_html <<-HTML.chomp!
<li class="dropdown">
  <a href="#" class="dropdown-toggle" data-toggle="dropdown">
    #{name} <b class="caret"></b>
  </a>
  #{dropdown_menu(&block)}
</li>
HTML
  end

  def navbar_sub_dropdown(name, list_item_options = {}, link_options = {}, &block)
    list_item_options, link_options = list_item_options.dup, link_options.dup
    list_item_options[:class] = [list_item_options.delete(:class), 'dropdown-submenu'].compact.join(' ')
    list_item_attributes = attributes_for_tag(list_item_options)
    link_attributes      = attributes_for_tag(link_options)
    prepare_html <<-HTML.chomp!
<li#{list_item_attributes}>
  <a href="#"#{link_attributes}>
    #{name}
  </a>
  #{dropdown_menu(&block)}
</li>
HTML
  end

  def navbar_dropdown_divider
    prepare_html %(<li class="divider"></li>)
  end

  def navbar_dropdown_header(text)
    prepare_html %(<li class="nav-header">#{text}</li>)
  end

  def navbar_divider
    prepare_html %(<li class="divider-vertical"></li>)
  end

  def navbar_text(text = nil, pull = nil, &block)
    css_classes = %w(navbar-text)
    css_classes << "pull-#{pull}" if pull
    prepare_html <<-HTML.chomp!
<p class="#{css_classes.join(' ')}">
  #{block_given? ? capture(&block) : text}
</p>
HTML
  end

  def navbar_brand_link(name, url = nil)
    prepare_html %(<a href="#{url || '/'}" class="brand">#{name}</a>)
  end

  private

  def wrapper(options, html_options, &block)
    options, html_options = options.dup, html_options.dup
    position = case
               when options.key?(:static) then "static-#{options[:static]}"
               when options.key?(:fixed)  then "fixed-#{options[:fixed]}"
               end
    html_options[:class] = [html_options[:class], 'navbar'].compact
    html_options[:class] << "navbar-#{position}" if position
    html_options[:class] << 'navbar-inverse'     if options[:inverse]
    html_options[:class] = html_options[:class].join(' ')
    attributes = attributes_for_tag(html_options)
    prepare_html <<-HTML.chomp!
<div#{attributes}>
  #{capture(&block) if block_given?}
</div>
HTML
  end

  def inner_wrapper(&block)
    prepare_html <<-HTML.chomp!
<div class="navbar-inner">
  #{capture(&block) if block_given?}
</div>
HTML
  end

  def container(brand, brand_link, responsive, fluid, &block)
    css_class = fluid ? 'container-fluid' : 'container'
    content = []
    content << responsive_button if responsive
    content << navbar_brand_link(brand, brand_link) if brand || brand_link
    content << if responsive
      responsive_wrapper(&block)
    else
      capture(&block) if block_given?
    end
    prepare_html <<-HTML.chomp!
<div class="#{css_class}">
  #{content.join("\n")}
</div>
HTML
  end

  def responsive_wrapper(&block)
    css_classes = %w(nav-collapse)
    css_classes << 'collapse' if BootstrapNavbar.configuration.bootstrap_version >= '2.2.0'
    attributes = attributes_for_tag(class: css_classes.join(' '))
    prepare_html <<-HTML.chomp!
<div#{attributes}>
  #{capture(&block) if block_given?}
</div>
HTML
  end

  def responsive_button
    prepare_html <<-HTML.chomp!
<a class="btn btn-navbar" data-toggle="collapse" data-target=".nav-collapse">
  <span class='icon-bar'></span>
  <span class='icon-bar'></span>
  <span class='icon-bar'></span>
</a>
HTML
  end

  def dropdown_menu(&block)
    prepare_html <<-HTML.chomp!
<ul class="dropdown-menu">
  #{capture(&block) if block_given?}
</ul>
HTML
  end
end
