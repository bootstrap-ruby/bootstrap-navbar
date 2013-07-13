module BootstrapNavbar::Helpers
  def nav_bar(options = {}, &block)
    nav_bar_div options do
      navbar_inner_div do
        container_div options[:brand], options[:brand_link], options[:responsive], options[:fluid], &block
      end
    end
  end

  def menu_group(pull = nil, &block)
    css_classes = %w(nav).tap do |css_classes|
      css_classes << "pull-#{pull}" if pull
    end
    <<-HTML
<ul class="#{css_classes.join(' ')}">
  #{block.call if block_given?}
</ul>
HTML
  end

  def menu_item(name, path = '#', options = {})
    css_class = path.sub(%r(/\z), '') == current_url.sub(%r(/\z), '') ? 'active' : nil
    options_string = options.map { |k, v| %(#{k}="#{v}") }
    <<-HTML
<li class="#{css_class}">
  <a href="#{path}" #{options_string}>
    #{name}
  </a>
</li>
HTML
  end

  def drop_down(name, &block)
    <<-HTML
<li class="dropdown">
  <a href="#" class="dropdown-toggle", data-toggle="dropdown">
    #{name} <b class="caret"></b>
  </a>
  <ul class="dropdown-menu">
    #{block.call if block_given?}
  </ul>
</li>
HTML
  end

  def drop_down_divider
    %(<li class="divider"></li>)
  end

  def drop_down_header(text)
    %(<li class="nav-header">#{text}</li>)
  end

  def menu_divider
    %(<li class="divider-vertical"></li>)
  end

  def menu_text(text = nil, pull = nil, &block)
    css_classes = %w(navbar-text).tap do |css_classes|
      css_classes << "pull-#{pull}" if pull
    end
    <<-HTML
<p class="#{css_classes.join(' ')}">
  #{block_given? ? block.call : text}
</p>
HTML
  end

  def brand_link(name, url = nil)
    %(<a href="#{url || '/'}" class="brand">#{name}</a>)
  end

  private

  def nav_bar_div(options, &block)
    position = case
    when options.has_key?(:static)
      "static-#{options[:static]}"
    when options.has_key?(:fixed)
      "fixed-#{options[:fixed]}"
    end

    css_classes = %w(navbar).tap do |css_classes|
      css_classes << "navbar-#{position}" if position
      css_classes << 'navbar-inverse' if options[:inverse]
    end

    <<-HTML
<div class="#{css_classes.join(' ')}">
  #{block.call if block_given?}
</div>
HTML
  end

  def navbar_inner_div(&block)
    <<-HTML
<div class="navbar-inner">
  #{block.call if block_given?}
</div>
HTML
  end

  def container_div(brand, brand_link, responsive, fluid, &block)
    css_class = fluid ? 'container-fluid' : 'container'
    content = [].tap do |content|
      content << responsive_button if responsive
      content << brand_link(brand, brand_link) if brand || brand_link
      content << if responsive
        responsive_wrapper(&block)
      else
        block.call if block_given?
      end
    end
    <<-HTML
<div class="#{css_class}">
  #{content.join("\n")}
</div>
HTML
  end

  def responsive_wrapper(&block)
    <<-HTML
<div class="nav-collapse collapse">
  #{block.call if block_given?}
</div>
HTML
  end

  def responsive_button
    <<-HTML
<a class="btn btn-navbar", data-toggle="collapse" data-target=".nav-collapse">
  <span class='icon-bar'></span>
  <span class='icon-bar'></span>
  <span class='icon-bar'></span>
</div>
HTML
  end

  def current_url
    raise StandardError, 'current_url_method is not defined.' if BootstrapNavbar.current_url_method.nil?
    instance_eval BootstrapNavbar.current_url_method
  end
end
