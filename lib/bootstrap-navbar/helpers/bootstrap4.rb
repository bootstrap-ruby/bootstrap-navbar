module BootstrapNavbar::Helpers::Bootstrap4
  def navbar(options = {}, &block)
    options = options.dup
    container = options.key?(:container) ? options.delete(:container) : false
    wrapper options do
      if container
        container(&block)
      else
        capture(&block) if block_given?
      end
    end
  end

  def navbar_collapse(options = {}, &block)
    options = options.dup
    options[:class] = [options[:class], 'collapse', 'navbar-collapse'].compact
    options[:class] = options[:class].join(' ')
    options[:id] ||= 'navbar-collapsable'
    attributes = attributes_for_tag(options)
    toggler_attributes = attributes_for_tag(
      class:             'navbar-toggler',
      type:              'button',
      'data-toggle'   => 'collapse',
      'data-target'   => "##{options[:id]}",
      'aria-controls' => options[:id],
      'aria-expanded' => false,
      'aria-label'    => 'Toggle navigation'
    )
    prepare_html <<-HTML.chomp!
<button#{toggler_attributes}>
  <span class="navbar-toggler-icon"></span>
</button>
<div#{attributes}>
  #{capture(&block) if block_given?}
</div>
HTML
  end

  def navbar_group(options = {}, &block)
    options = options.dup
    options[:class] = [options[:class], 'navbar-nav'].compact.join(' ')
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
    list_item_options[:class] = [list_item_options[:class], 'nav-item'].compact.join(' ')
    link_options[:class] = [link_options[:class], 'nav-link'].compact
    link_options[:class] << 'active' if current_url_or_sub_url?(url)
    link_options[:class]  = link_options[:class].join(' ')
    list_item_attributes = attributes_for_tag(list_item_options)
    link_attributes      = attributes_for_tag(link_options)
    prepare_html <<-HTML.chomp!
<li#{list_item_attributes}>
  <a href="#{url}"#{link_attributes}>
    #{text}
  </a>
</li>
HTML
  end

  def navbar_dropdown(text, id = '', list_item_options = {}, link_options = {}, &block)
    list_item_options, link_options = list_item_options.dup, link_options.dup
    list_item_options[:class] = [list_item_options[:class], 'nav-item', 'dropdown'].compact.join(' ')
    wrapper_class = [*list_item_options.delete(:wrapper_class), 'dropdown-menu'].compact.join(' ')
    list_item_attributes = attributes_for_tag(list_item_options)
    link_options[:class] = [link_options[:class], 'nav-link', 'dropdown-toggle'].compact.join(' ')
    id ||= "navbarDropdownMenuLink#{text}"
    link_attributes = attributes_for_tag(link_options)
    prepare_html <<-HTML.chomp!
<li#{list_item_attributes}>
  <a href="#" data-toggle="dropdown" id="##{id}" aria-haspopup="true" aria-expanded="false" role="button" #{link_attributes}>#{text}</a>
  <div class="#{wrapper_class}" aria-labelledby="#{id}">
    #{capture(&block) if block_given?}
  </div>
</li>
HTML
  end

  def navbar_dropdown_item(text, url = '#', link_options = {}, &block)
    link_options = link_options.dup
    link_options[:class] = [link_options[:class], 'dropdown-item'].compact
    link_options[:class] << 'active' if current_url_or_sub_url?(url)
    link_options[:class]  = link_options[:class].join(' ')
    link_attributes = attributes_for_tag(link_options)
    prepare_html <<-HTML.chomp!
<a href="#{url}"#{link_attributes}>
  #{text}
</a>
    HTML
  end

  def navbar_dropdown_divider
    prepare_html <<-HTML.chomp!
<div class="dropdown-divider"></div>
HTML
  end

  private

  def container(&block)
    prepare_html <<-HTML.chomp!
<div class="container">
  #{capture(&block) if block_given?}
</div>
HTML
  end

  def brand_link(text, url = nil)
    prepare_html <<-HTML.chomp!
<a href="#{url || '/'}" class="navbar-brand">
  #{text}
</a>
HTML
  end

  def wrapper(options, &block)
    options = options.dup
    options[:class] = [options[:class], 'navbar'].compact
    options[:class] << "navbar-#{options.key?(:color_scheme) ? options.delete(:color_scheme) : 'dark'}"
    options[:class] << "bg-#{options.delete(:bg) || 'dark'}" unless options[:bg] == false
    if options.key?(:sticky) && options.delete(:sticky) === true
      options[:class] << 'sticky-top'
    elsif options.key?(:placement)
      options[:class] << "fixed-#{options.delete(:placement)}"
    end
    options[:class] << "navbar-expand-#{options.delete(:expand_at) || 'sm'}"
    options[:class] = options[:class].join(' ')
    brand = brand_link(options.delete(:brand), options.delete(:brand_url)) if options[:brand]
    attributes = attributes_for_tag(options)
    prepare_html <<-HTML.chomp!
<nav#{attributes}>
  #{brand}
  #{capture(&block) if block_given?}
</nav>
HTML
  end
end
