module BootstrapNavbar::Helpers::Bootstrap4
  def navbar(options = {}, &block)
    options = options.dup
    container = options.key?(:container) ? options.delete(:container) : true
    wrapper options do
      if container
        container(container, &block)
      else
        capture(&block) if block_given?
      end
    end
  end

  def navbar_header(options = {}, &block)
    options = options.dup
    brand, brand_link = options.delete(:brand), options.delete(:brand_link)
    css_classes = %w(navbar-header).tap do |css_classes|
      css_classes << options.delete(:class) if options.key?(:class)
    end
    attributes = attributes_for_tag(options.reverse_merge(class: css_classes.join(' ')))
    prepare_html <<-HTML.chomp!
<div#{attributes}>
  <button type="button" class="navbar-toggle" data-toggle="collapse" data-target="#navbar-collapsable">
    <span class="sr-only">Toggle navigation</span>
    <span class="icon-bar"></span>
    <span class="icon-bar"></span>
    <span class="icon-bar"></span>
  </button>
  #{brand_link brand, brand_link unless brand.nil?}
  #{capture(&block) if block_given?}
</div>
HTML
  end

  def navbar_collapse(options = {}, &block)
    options = options.dup
    css_classes = %w(collapse navbar-collapse).tap do |css_classes|
      css_classes << options.delete(:class) if options.key?(:class)
    end
    attributes = attributes_for_tag(options.reverse_merge(class: css_classes.join(' '), id: 'navbar-collapsable'))
    prepare_html <<-HTML.chomp!
<div#{attributes}>
  #{capture(&block) if block_given?}
</div>
HTML
  end

  def navbar_group(options = {}, &block)
    options = options.dup
    css_classes = %w(nav navbar-nav).tap do |css_classes|
      css_classes << "navbar-#{options.delete(:align)}" if options.key?(:align)
      css_classes << options.delete(:class) if options.key?(:class)
    end
    attributes = attributes_for_tag(options.reverse_merge(class: css_classes.join(' ')))
    prepare_html <<-HTML.chomp!
<ul#{attributes}>
  #{capture(&block) if block_given?}
</ul>
HTML
  end

  def navbar_item(text, url = nil, list_item_options = nil, link_options = nil, &block)
    text, url, list_item_options, link_options = capture(&block), text, url, list_item_options if block_given?
    url               ||= '#'
    list_item_options   = list_item_options.nil? ? {} : list_item_options.dup
    link_options        = link_options.nil?      ? {} : link_options.dup
    list_item_css_classes = %w(nav-item).tap do |css_classes|
      css_classes << 'active' if current_url_or_sub_url?(url)
      css_classes << list_item_options.delete(:class) if list_item_options.key?(:class)
    end
    link_css_classes = %w(nav-link).tap do |css_classes|
      css_classes << link_options.delete(:class) if link_options.key?(:class)
    end
    list_item_attributes = attributes_for_tag(
      { class: list_item_css_classes.join(' ') }
        .delete_if { |k, v| v.empty? }
        .merge(list_item_options)
    )
    link_attributes = attributes_for_tag({ class: link_css_classes.join(' ') }
                                             .delete_if { |k, v| v.empty? }.merge(link_options))
    prepare_html <<-HTML.chomp!
<li#{list_item_attributes}>
  <a href="#{url}"#{link_attributes}>
    #{text}
  </a>
</li>
HTML
  end

  def navbar_form(url, options = {}, &block)
    options = options.dup
    css_classes = %w(form-inline).tap do |css_classes|
      css_classes << "pull-xs-#{options.delete(:align)}" if options.key?(:align)
      css_classes << options.delete(:class) if options.key?(:class)
    end
    role = options.delete(:role) || 'form'
    attributes = attributes_for_tag(options.reverse_merge(class: css_classes.join(' '), role: role))
    prepare_html <<-HTML.chomp!
<form action="#{url}" #{attributes}>
  #{capture(&block) if block_given?}
</form>
HTML
  end

  def navbar_text(text = nil, options = {}, &block)
    raise StandardError, 'Please provide either the "text" parameter or a block.' if (text.nil? && !block_given?) || (!text.nil? && block_given?)
    options = options.dup
    text ||= capture(&block)
    css_classes = %w(nav-item).tap do |css_classes|
      css_classes << options.delete(:class) if options.key?(:class)
    end
    attributes = attributes_for_tag(options.reverse_merge(class: css_classes.join(' ')))
    prepare_html <<-HTML.chomp!
<p#{attributes}>#{text}</p>
HTML
  end

  def navbar_button(text, options = {})
    options = options.dup
    css_classes = %w(btn navbar-btn).tap do |css_classes|
      css_classes << options.delete(:class) if options.key?(:class)
    end
    type = options.delete(:type) || 'button'
    attributes = attributes_for_tag(options.reverse_merge(class: css_classes.join(' '), type: type))
    prepare_html <<-HTML.chomp!
<button#{attributes}>#{text}</button>
HTML
  end

  def navbar_dropdown(text, list_item_options = {}, link_options = {}, &block)
    list_item_options, link_options = list_item_options.dup, link_options.dup
    list_item_options[:class] = [list_item_options[:class], 'dropdown'].compact.join(' ')
    list_item_attributes = attributes_for_tag(list_item_options)
    link_options[:class] = [link_options[:class], 'dropdown-toggle'].compact.join(' ')
    link_attributes = attributes_for_tag(link_options)
    prepare_html <<-HTML.chomp!
<li#{list_item_attributes}>
  <a href="#" data-toggle="dropdown"#{link_attributes}>#{text} <b class="caret"></b></a>
  <ul class="dropdown-menu">
    #{capture(&block) if block_given?}
  </ul>
</li>
HTML
  end

  def navbar_dropdown_header(text)
    prepare_html <<-HTML.chomp!
<li class="dropdown-header">
  #{text}
</li>
HTML
  end

  def navbar_dropdown_divider
    prepare_html <<-HTML.chomp!
<li class="divider"></li>
HTML
  end

  private

  def container(type, &block)
    css_class = 'container'
    css_class << "-#{type}" if type.is_a?(String)
    attributes = attributes_for_tag(class: css_class)
    prepare_html <<-HTML.chomp!
<div#{attributes}>
  #{capture(&block) if block_given?}
</div>
HTML
  end

  def brand_link(name, url = nil)
    url ||= '/'
    prepare_html <<-HTML.chomp!
<a href="#{url}" class="navbar-brand">
  #{name}
</a>
HTML
  end

  def wrapper(options, &block)
    options = options.dup
    css_classes = %w(navbar).tap do |css_classes|
      # Inverse is now called dark and light (StarWars?)
      css_classes << "navbar-#{options.delete(:dark) or options.delete(:inverse) ? 'dark' : 'light'}"
      # Bootstrap4 need background
      if options.key? :bg
        css_classes << "bg-#{options.delete(:bg)}"
      elsif not options.key? :color
        css_classes << "bg-primary"
      end
      # No more static in B4
      if options.key?(:fixed) or options.key? options.delete(:static)
        css_classes << "navbar-fixed-#{options.delete(:fixed) || 'top'}"
        css_classes << 'navbar-full'
      elsif options.delete(:full)
        css_classes << 'navbar-full'
      end
      css_classes << options.delete(:class) if options.key?(:class)
    end
    role = options.delete(:role) || 'navigation'
    attributes = attributes_for_tag(options.reverse_merge(class: css_classes.join(' '), role: role))
    prepare_html <<-HTML.chomp!
<nav#{attributes}>
  #{capture(&block) if block_given?}
</nav>
HTML
  end
end
