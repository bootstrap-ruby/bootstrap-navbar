module BootstrapNavbar::Helpers::Bootstrap3
  def navbar(options = {}, &block)
    container = options.has_key?(:container) ? options[:container] : true
    navbar_content =
      navbar_header(options[:brand], options[:brand_link]) <<
      navbar_collapsable(&block)
    navbar_wrapper options do
      if container
        navbar_container(navbar_content)
      else
        navbar_content
      end
    end
  end

  def navbar_group(options = {}, &block)
    css_classes = %w(nav navbar-nav).tap do |css_classes|
      css_classes << "navbar-#{options[:align]}" if options.has_key?(:align)
    end
    attributes = attribute_hash_to_string({ class: css_classes.join(' ') }.merge(options))
    prepare_html <<-HTML.chomp!
<ul#{with_preceding_space attributes}>
  #{capture(&block) if block_given?}
</ul>
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

  def navbar_group_item(text, url)
    attributes = {}
    attributes[:class] = 'active' if current_url?(url)
    attributes = attribute_hash_to_string(attributes)
    prepare_html <<-HTML.chomp!
<li#{with_preceding_space attributes}>
  <a href="#{url}">#{text}</a>
</li>
HTML
  end

  def navbar_form(options = {}, &block)
    css_classes = %w(navbar-form).tap do |css_classes|
      css_classes << "navbar-#{options[:align]}" if options.has_key?(:align)
    end
    attribute_hash = { class: css_classes.join(' '), role: 'form' }
    attributes = attribute_hash_to_string(attribute_hash)
    prepare_html <<-HTML.chomp!
<form#{with_preceding_space attributes}>
  #{capture(&block) if block_given?}
</form>
HTML
  end

  def navbar_divider
    prepare_html <<-HTML.chomp!
<li class="divider"></li>
HTML
  end

  def navbar_text(text = nil, &block)
    raise StandardError, 'Please provide either the "text" parameter or a block.' if (text.nil? && !block_given?) || (!text.nil? && block_given?)
    text ||= capture(&block)
    prepare_html <<-HTML.chomp!
<p class="navbar-text">#{text}</p>
HTML
  end

  def navbar_button(text, options = {})
    css_classes = %w(btn navbar-btn).tap do |css_classes|
      css_classes << options[:class] if options.has_key?(:class)
    end
    attribute_hash = { class: css_classes.join(' '), type: 'button' }
    attributes = attribute_hash_to_string(attribute_hash)
    prepare_html <<-HTML.chomp!
<button#{with_preceding_space attributes}>#{text}</button>
HTML
  end

  private

  def navbar_container(content)
    prepare_html <<-HTML.chomp!
<div class="container">
  #{content}
</div>
HTML
  end

  def navbar_header(brand, brand_link)
    prepare_html <<-HTML.chomp!
<div class="navbar-header">
  <button type="button" class="navbar-toggle" data-toggle="collapse" data-target="#navbar-collapsable">
    <span class="sr-only">Toggle navigation</span>
    <span class="icon-bar"></span>
    <span class="icon-bar"></span>
    <span class="icon-bar"></span>
  </button>
  #{brand_link brand, brand_link}
</div>
HTML
  end

  def navbar_collapsable(&block)
    prepare_html <<-HTML.chomp!
<div class="collapse navbar-collapse" id="navbar-collapsable">
  #{capture(&block) if block_given?}
</div>
HTML
  end

  def brand_link(name, url = nil)
    prepare_html %(<a href="#{url || '/'}" class="navbar-brand">#{name}</a>)
  end

  def navbar_wrapper(options, &block)
    style = options[:inverse] ? 'inverse' : 'default'
    css_classes = %w(navbar).tap do |css_classes|
      css_classes << "navbar-fixed-#{options[:fixed]}" if options.has_key?(:fixed)
      css_classes << 'navbar-static-top' if options[:static]
      css_classes << 'navbar-inverse' if options[:inverse]
      css_classes << "navbar-#{style}"
    end
    attribute_hash = { class: css_classes.join(' '), role: 'navigation' }
    attributes = attribute_hash_to_string(attribute_hash)
    prepare_html <<-HTML.chomp!
<nav#{with_preceding_space attributes}>
  #{capture(&block) if block_given?}
</nav>
HTML
  end
end
