module BootstrapNavbar::Helpers::Bootstrap3
  def navbar(options = {}, &block)
    options = options.dup
    navbar_content =
      header(options.delete(:brand), options.delete(:brand_link)) <<
      collapsable(&block)
    wrapper options do
      unless options[:container] == false
        container(options[:container], navbar_content)
      else
        navbar_content
      end
    end
  end

  def navbar_group(options = {}, &block)
    options = options.dup
    css_classes = %w(nav navbar-nav).tap do |css_classes|
      css_classes << "navbar-#{options.delete(:align)}" if options.has_key?(:align)
      css_classes << options.delete(:class) if options.has_key?(:class)
    end
    attributes = attributes_for_tag(options.reverse_merge(class: css_classes.join(' ')))
    prepare_html <<-HTML.chomp!
<ul#{attributes}>
  #{capture(&block) if block_given?}
</ul>
HTML
  end

  def navbar_item(text, url = nil, list_item_options = nil, link_options = nil, &block)
    text, url, list_item_options, link_options = capture(&block), text, list_item_options if block_given?
    url               ||= '#'
    list_item_options   = list_item_options.nil? ? {} : list_item_options.dup
    link_options        = link_options.nil?      ? {} : link_options.dup
    list_item_css_classes = [].tap do |css_classes|
      css_classes << 'active' if current_url?(url)
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
  <a href="#{url}"#{link_attributes}>
    #{text}
  </a>
</li>
HTML
  end

  def navbar_form(options = {}, &block)
    options = options.dup
    css_classes = %w(navbar-form).tap do |css_classes|
      css_classes << "navbar-#{options.delete(:align)}" if options.has_key?(:align)
      css_classes << options.delete(:class) if options.has_key?(:class)
    end
    role = options.delete(:role) || 'form'
    attributes = attributes_for_tag(options.reverse_merge(class: css_classes.join(' '), role: role))
    prepare_html <<-HTML.chomp!
<form#{attributes}>
  #{capture(&block) if block_given?}
</form>
HTML
  end

  def navbar_text(text = nil, options = {}, &block)
    raise StandardError, 'Please provide either the "text" parameter or a block.' if (text.nil? && !block_given?) || (!text.nil? && block_given?)
    options = options.dup
    text ||= capture(&block)
    css_classes = %w(navbar-text).tap do |css_classes|
      css_classes << options.delete(:class) if options.has_key?(:class)
    end
    attributes = attributes_for_tag(options.reverse_merge(class: css_classes.join(' ')))
    prepare_html <<-HTML.chomp!
<p#{attributes}>#{text}</p>
HTML
  end

  def navbar_button(text, options = {})
    options = options.dup
    css_classes = %w(btn navbar-btn).tap do |css_classes|
      css_classes << options.delete(:class) if options.has_key?(:class)
    end
    type = options.delete(:type) || 'button'
    attributes = attributes_for_tag(options.reverse_merge(class: css_classes.join(' '), type: type))
    prepare_html <<-HTML.chomp!
<button#{attributes}>#{text}</button>
HTML
  end

  def navbar_dropdown(text, &block)
    prepare_html <<-HTML.chomp!
<li class="dropdown">
  <a href="#" class="dropdown-toggle" data-toggle="dropdown">#{text} <b class="caret"></b></a>
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

  def container(type, content)
    css_class = 'container'
    css_class << "-#{type}" if type.is_a?(String)
    attributes = attributes_for_tag(class: css_class)
    prepare_html <<-HTML.chomp!
<div#{attributes}>
  #{content}
</div>
HTML
  end

  def header(brand, brand_link)
    prepare_html <<-HTML.chomp!
<div class="navbar-header">
  <button type="button" class="navbar-toggle" data-toggle="collapse" data-target="#navbar-collapsable">
    <span class="sr-only">Toggle navigation</span>
    <span class="icon-bar"></span>
    <span class="icon-bar"></span>
    <span class="icon-bar"></span>
  </button>
  #{brand_link brand, brand_link unless brand.nil?}
</div>
HTML
  end

  def collapsable(&block)
    prepare_html <<-HTML.chomp!
<div class="collapse navbar-collapse" id="navbar-collapsable">
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
    style = options.delete(:inverse) ? 'inverse' : 'default'
    css_classes = %w(navbar).tap do |css_classes|
      css_classes << "navbar-fixed-#{options.delete(:fixed)}" if options.has_key?(:fixed)
      css_classes << 'navbar-static-top' if options.delete(:static)
      css_classes << 'navbar-inverse' if options.delete(:inverse)
      css_classes << "navbar-#{style}"
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
