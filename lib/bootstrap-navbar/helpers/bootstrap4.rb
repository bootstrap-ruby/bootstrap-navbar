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
    if options.key?(:toggleable)
      toggleable = options.delete(:toggleable)
      toggleable = 'xs' if toggleable == true
    end
    options[:class] = [options[:class], 'collapse'].compact
    options[:class] << "navbar-toggleable-#{toggleable}" if toggleable
    options[:class] = options[:class].join(' ')
    toggler_css_classes = %w(navbar-toggler).tap do |css_classes|
      if toggleable
        following_grid_size = case toggleable
                              when 'xs' then 'sm'
                              when 'sm' then 'md'
                              when 'md' then 'lg'
                              when 'lg' then 'xl'
                              else fail %(Unexpected "toggleable" parameter: #{toggleable}. Must be "xs", "sm", "md", "lg" or `true` (equals "xs").)
                              end
        css_classes << "hidden-#{following_grid_size}-up"
      end
    end
    options[:id] ||= 'navbar-collapsable'
    attributes = attributes_for_tag(options)
    toggler_attributes = attributes_for_tag(
      class:             toggler_css_classes.join(' '),
      type:              'button',
      'data-toggle'   => 'collapse',
      'data-target'   => "##{options[:id]}",
      'aria-controls' => options[:id],
      'aria-expanded' => false,
      'aria-label'    => 'Toggle navigation'
    )
    prepare_html <<-HTML.chomp!
<button#{toggler_attributes}>
  &#9776;
</button>
<div#{attributes}>
  #{capture(&block) if block_given?}
</div>
HTML
  end

  def navbar_group(options = {}, &block)
    options = options.dup
    options[:class] = [options[:class], 'nav', 'navbar-nav'].compact.join(' ')
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
    list_item_options[:class] = [list_item_options[:class], 'nav-item'].compact
    list_item_options[:class] << 'active' if current_url_or_sub_url?(url)
    list_item_options[:class] = list_item_options[:class].join(' ')
    link_options[:class] = [link_options[:class], 'nav-link'].compact.join(' ')
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
    options[:class] << "bg-#{options.delete(:bg) || 'primary'}" unless options[:bg] == false
    options[:class] << "navbar-#{options.delete(:placement)}" if options.key?(:placement)
    options[:class] = options[:class].join(' ')
    brand = brand_link(options[:brand], options[:brand_url]) if options[:brand]
    attributes = attributes_for_tag(options)
    prepare_html <<-HTML.chomp!
<nav#{attributes}>
  #{brand}
  #{capture(&block) if block_given?}
</nav>
HTML
  end
end
