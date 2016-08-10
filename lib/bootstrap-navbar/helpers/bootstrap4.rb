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
    css_classes = %w(collapse).tap do |css_classes|
      css_classes << options.delete(:class) if options.key?(:class)
      css_classes << "navbar-toggleable-#{toggleable}" if toggleable
    end
    toggler_css_classes = %w(navbar-toggler).tap do |css_classes|
      if toggleable
        following_grid_size = case toggleable
        when 'xs' then 'sm'
        when 'sm' then 'md'
        when 'md' then 'lg'
        when 'lg' then 'xl'
        else
          fail %(Unexpected "toggleable" parameter: #{toggleable}. Must be "xs", "sm", "md", "lg" or `true` (equals "xs").)
        end
        css_classes << "hidden-#{following_grid_size}-up"
      end
    end
    id = options.delete(:id) || 'navbar-collapsable'
    attributes = attributes_for_tag(options.reverse_merge(class: css_classes.join(' '), id: id))
    toggler_attributes = attributes_for_tag(
      class:             toggler_css_classes.join(' '),
      type:              'button',
      'data-toggle'   => 'collapse',
      'data-target'   => "##{id}",
      'aria-controls' => id,
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
    css_classes = %w(nav navbar-nav).tap do |css_classes|
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
    link_attributes = attributes_for_tag(
      { class: link_css_classes.join(' ') }
        .delete_if { |k, v| v.empty? }
        .merge(link_options)
    )
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
    css_classes = %w(navbar).tap do |css_classes|
      css_classes << "navbar-#{options.key?(:color_scheme) ? options.delete(:color_scheme) : 'dark'}"
      css_classes << "bg-#{options.delete(:bg) || 'primary'}" unless options[:bg] == false
      css_classes << "navbar-#{options.delete(:placement)}" if options.key?(:placement)
      css_classes << options.delete(:class) if options.key?(:class)
    end
    brand = brand_link(options[:brand], options[:brand_url]) if options[:brand]
    attributes = attributes_for_tag(options.reverse_merge(class: css_classes.join(' ')))
    prepare_html <<-HTML.chomp!
<nav#{attributes}>
  #{brand}
  #{capture(&block) if block_given?}
</nav>
HTML
  end
end
