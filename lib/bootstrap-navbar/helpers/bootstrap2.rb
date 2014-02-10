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
    css_classes = %w(nav).tap do |css_classes|
      css_classes << "pull-#{options.delete(:pull)}" if options.has_key?(:pull)
      css_classes << options.delete(:class) if options.has_key?(:class)
    end
    attributes = attributes_for_tag({ class: css_classes.join(' ') }.merge(options))
    prepare_html <<-HTML.chomp!
<ul#{attributes}>
  #{capture(&block) if block_given?}
</ul>
HTML
  end

  def navbar_item(name = nil, path = nil, list_item_options = nil, link_options = nil, &block)
    name, path, list_item_options, link_options = capture(&block), name, path, list_item_options if block_given?
    path              ||= '#'
    list_item_options   = list_item_options.nil? ? {} : list_item_options.dup
    link_options        = link_options.nil?      ? {} : link_options.dup
    list_item_css_classes = [].tap do |css_classes|
      css_classes << 'active' if current_url?(path)
      css_classes << list_item_options.delete(:class) if list_item_options.has_key?(:class)
    end
    list_item_attributes = attributes_for_tag(
      { class: list_item_css_classes.join(' ') }
        .delete_if { |k, v| v.empty? }
        .merge(list_item_options)
    )
    link_attributes = attributes_for_tag(link_options)
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
    list_item_css_classes = %w(dropdown-submenu).tap do |css_classes|
      css_classes << list_item_options.delete(:class) if list_item_options.has_key?(:class)
    end
    list_item_attributes = attributes_for_tag({ class: list_item_css_classes.join(' ') }.merge(list_item_options))
    link_attributes = attributes_for_tag(link_options)
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
    css_classes = %w(navbar-text).tap do |css_classes|
      css_classes << "pull-#{pull}" if pull
    end
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
    when options.has_key?(:static)
      "static-#{options[:static]}"
    when options.has_key?(:fixed)
      "fixed-#{options[:fixed]}"
    end
    css_classes = %w(navbar).tap do |css_classes|
      css_classes << "navbar-#{position}" if position
      css_classes << 'navbar-inverse' if options[:inverse]
      css_classes << html_options.delete(:class)
    end
    attribute_hash = { class: css_classes.join(' ') }.merge(html_options)
    attributes = attributes_for_tag(attribute_hash)
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
    content = [].tap do |content|
      content << responsive_button if responsive
      content << navbar_brand_link(brand, brand_link) if brand || brand_link
      content << if responsive
        responsive_wrapper(&block)
      else
        capture(&block) if block_given?
      end
    end
    prepare_html <<-HTML.chomp!
<div class="#{css_class}">
  #{content.join("\n")}
</div>
HTML
  end

  def responsive_wrapper(&block)
    css_classes = %w(nav-collapse).tap do |css_classes|
      css_classes << 'collapse' if BootstrapNavbar.configuration.bootstrap_version >= '2.2.0'
    end
    attributes = attributes_for_tag({ class: css_classes.join(' ') })
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
