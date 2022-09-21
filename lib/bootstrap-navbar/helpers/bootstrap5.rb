module BootstrapNavbar::Helpers::Bootstrap5
  def navbar(options = {}, &block)
    options = options.dup
    unless container = options.key?(:container) ? options.delete(:container) : true
      raise "container cannot be false."
    end
    brand = if options[:brand]
      brand_url           = options.delete(:brand_url)
      element, attributes = brand_url == false ? ['span', {}] : ['a', { href: brand_url || '/' }]
      attributes[:class]  = 'navbar-brand'

      prepare_html <<~HTML
                     <#{element}#{attributes_for_tag(attributes)}>
                       #{options.delete(:brand)}
                     </#{element}>
                   HTML
    end
    wrapper options do
      container container do
        prepare_html <<~HTML
                       #{brand}
                       #{capture(&block) if block_given?}
                     HTML
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
      class:              'navbar-toggler',
      type:               'button',
      'data-bs-toggle' => 'collapse',
      'data-bs-target' => "##{options[:id]}",
      'aria-controls'  => options[:id],
      'aria-expanded'  => false,
      'aria-label'     => 'Toggle navigation'
    )
    prepare_html <<~HTML
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
    prepare_html <<~HTML
                   <ul#{attributes}>
                     #{capture(&block) if block_given?}
                   </ul>
                 HTML
  end

  def navbar_text(text)
    %(<span class="navbar-text">#{text}</span>)
  end

  def navbar_item(text, url = nil, list_item_options = nil, link_options = nil, &block)
    text, url, list_item_options, link_options = capture(&block), text, (url || {}), list_item_options if block_given?
    url ||= '#'
    list_item_options   = list_item_options ? list_item_options.dup : {}
    link_options        = link_options      ? link_options.dup      : {}
    list_item_options[:class] = [list_item_options[:class], 'nav-item'].compact.join(' ')
    link_options[:class] = [link_options[:class], 'nav-link'].compact
    link_options[:class] << 'active' if current_url_or_sub_url?(url)
    link_options[:class] = link_options[:class].join(' ')
    list_item_attributes = attributes_for_tag(list_item_options)
    link_attributes      = attributes_for_tag(link_options)
    prepare_html <<~HTML
                   <li#{list_item_attributes}>
                     <a href="#{url}"#{link_attributes}>
                       #{text}
                     </a>
                   </li>
                 HTML
  end

  def navbar_dropdown(text, list_item_options = {}, link_options = {}, wrapper_options = {}, &block)
    list_item_options, link_options = list_item_options.dup, link_options.dup
    list_item_options[:class] = [list_item_options[:class], 'nav-item', 'dropdown'].compact.join(' ')
    list_item_attributes = attributes_for_tag(list_item_options)
    link_options[:class] = [link_options[:class], 'nav-link', 'dropdown-toggle'].compact.join(' ')
    link_attributes = attributes_for_tag(link_options)
    wrapper_options = { class: [*wrapper_options.delete(:class), 'dropdown-menu'].compact.join(' ') }
    if id = link_options[:id]
      wrapper_options[:'aria-labelledby'] = id
    end
    wrapper_attributes = attributes_for_tag(wrapper_options)
    prepare_html <<~HTML
                   <li#{list_item_attributes}>
                     <a href="#" data-bs-toggle="dropdown" aria-haspopup="true" aria-expanded="false" role="button"#{link_attributes}>#{text}</a>
                     <ul#{wrapper_attributes}>
                       #{capture(&block) if block_given?}
                     </ul>
                   </li>
                 HTML
  end

  def navbar_dropdown_item(text, url = nil, link_options = {}, &block)
    text, url, link_options = capture(&block), text, (url || {}) if block_given?
    url ||= '#'
    link_options = link_options.dup
    link_options[:class] = [link_options[:class], 'dropdown-item'].compact
    link_options[:class] << 'active' if current_url_or_sub_url?(url)
    link_options[:class] = link_options[:class].join(' ')
    link_attributes = attributes_for_tag(link_options)
    prepare_html <<~HTML
                   <li>
                     <a href="#{url}"#{link_attributes}>
                       #{text}
                     </a>
                   </li>
                 HTML
  end

  def navbar_dropdown_divider
    '<div class="dropdown-divider"></div>'
  end

  private

  def container(container, &block)
    container_class = [
      'container',
      (container unless container == true)
    ].compact.join('-')
    attributes = attributes_for_tag(class: container_class)
    prepare_html <<~HTML
                    <div#{attributes}>
                      #{capture(&block) if block_given?}
                    </div>
                  HTML
  end

  def wrapper(options, &block)
    options = options.dup
    options[:class] = [options[:class], 'navbar'].compact
    options[:class] << "navbar-#{options.key?(:color_scheme) ? options.delete(:color_scheme) : 'dark'}"
    if bg = options.delete(:bg)
      options[:class] << "bg-#{bg == true ? 'dark' : bg}"
    end
    if options.key?(:sticky) && options.delete(:sticky) === true
      options[:class] << 'sticky-top'
    elsif options.key?(:placement)
      options[:class] << "fixed-#{options.delete(:placement)}"
    end
    expand_at = options.delete(:expand_at)
    unless expand_at == true
      options[:class] << "navbar-expand#{"-#{expand_at}" if expand_at}"
    end
    options[:class] = options[:class].join(' ')
    attributes = attributes_for_tag(options)
    prepare_html <<~HTML
                    <nav#{attributes}>
                      #{capture(&block) if block_given?}
                    </nav>
                  HTML
  end
end
