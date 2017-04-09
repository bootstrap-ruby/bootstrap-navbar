module BootstrapNavbar::Helpers::Bootstrap3
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
    options[:class] = [options[:class], 'navbar-header'].compact.join(' ')
    attributes = attributes_for_tag(options)
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
    options[:class] = [options[:class], 'collapse', 'navbar-collapse'].compact.join(' ')
    options[:id] ||= 'navbar-collapsable'
    attributes = attributes_for_tag(options)
    prepare_html <<-HTML.chomp!
<div#{attributes}>
  #{capture(&block) if block_given?}
</div>
HTML
  end

  def navbar_group(options = {}, &block)
    options = options.dup
    options[:class] = [options[:class], 'nav', 'navbar-nav'].compact
    options[:class] << "navbar-#{options.delete(:align)}" if options.key?(:align)
    options[:class] = options[:class].join(' ')
    attributes = attributes_for_tag(options)
    prepare_html <<-HTML.chomp!
<ul#{attributes}>
  #{capture(&block) if block_given?}
</ul>
HTML
  end

  def navbar_item(text, url = nil, list_item_options = nil, link_options = nil, &block)
    text, url, list_item_options, link_options = capture(&block), text, url, list_item_options if block_given?
    url ||= '#'
    list_item_options   = list_item_options ? list_item_options.dup : {}
    link_options        = link_options      ? link_options.dup      : {}
    list_item_options[:class] = [list_item_options[:class]].compact
    list_item_options[:class] << 'active' if current_url_or_sub_url?(url)
    list_item_options[:class] = list_item_options[:class].join(' ')
    list_item_attributes = attributes_for_tag(list_item_options)
    link_attributes = attributes_for_tag(link_options)
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
    options[:class] = [options[:class], 'navbar-form'].compact
    options[:class] << "navbar-#{options.delete(:align)}" if options.key?(:align)
    options[:class] = options[:class].join(' ')
    options[:role] ||= 'form'
    attributes = attributes_for_tag(options)
    prepare_html <<-HTML.chomp!
<form action="#{url}" #{attributes}>
  #{capture(&block) if block_given?}
</form>
HTML
  end

  def navbar_text(text = nil, options = {}, &block)
    raise StandardError, 'Please provide either the "text" parameter or a block.' if !!text == block_given?
    options = options.dup
    text ||= capture(&block)
    options[:class] = [options[:class], 'navbar-text'].compact.join(' ')
    attributes = attributes_for_tag(options)
    prepare_html <<-HTML.chomp!
<p#{attributes}>#{text}</p>
HTML
  end

  def navbar_button(text, options = {})
    options = options.dup
    options[:class] = [options[:class], 'btn', 'navbar-btn'].compact.join(' ')
    options[:type] ||= 'button'
    attributes = attributes_for_tag(options)
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
    options[:class] = [options[:class], 'navbar'].compact
    options[:class] << "navbar-#{options.delete(:inverse) ? 'inverse' : 'default'}"
    options[:class] << "navbar-fixed-#{options.delete(:fixed)}" if options.key?(:fixed)
    options[:class] << 'navbar-static-top' if options.delete(:static)
    options[:class] = options[:class].join(' ')
    options[:role] ||= 'navigation'
    attributes = attributes_for_tag(options)
    prepare_html <<-HTML.chomp!
<nav#{attributes}>
  #{capture(&block) if block_given?}
</nav>
HTML
  end
end
