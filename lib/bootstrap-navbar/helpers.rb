module BootstrapNavbar::Helpers
  def self.included(base)
    if BootstrapNavbar.configuration.bootstrap_version.nil?
      unless bootstrap_gem = %w(bootstrap bootstrap-sass).detect { |gem| Gem.loaded_specs.keys.include?(gem) }
        raise 'Bootstrap version is not configured.'
      end
      bootstrap_gem_version = Gem.loaded_specs[bootstrap_gem].version
      bootstrap_version = bootstrap_gem_version.segments.take(3).join('.')
      BootstrapNavbar.configuration.bootstrap_version = bootstrap_version
    end
    helper_version = BootstrapNavbar.configuration.bootstrap_version[0]
    base.send :include, const_get("Bootstrap#{helper_version}")
  end

  def attributes_for_tag(hash)
    string = hash.map { |k, v| %(#{k}="#{v}") }.join(' ')
    if string.length > 0
      ' ' << string
    else
      string
    end
  end

  def current_url_or_sub_url?(url)
    return false if url == '#' || url =~ /\Atel:/
    uri, current_uri = [url, current_url].map do |url|
      URI.parse(url)
    end
    return false if uri.is_a?(URI::MailTo) || (!uri.host.nil? && uri.host != current_uri.host)
    normalized_path, normalized_current_path = [uri, current_uri].map do |uri|
      uri.path.sub(%r(/\z), '')
    end
    normalized_root_paths = BootstrapNavbar.configuration.root_paths.map do |path|
      path.sub(%r(/\z), '')
    end
    # If the URL is one of the root URLS, it's only current if it is the current URL.
    # Otherwise it's current if we're currently on the URL or on a sub URL.
    if normalized_root_paths.include?(normalized_path)
      normalized_current_path == normalized_path
    else
      normalized_current_path =~ %r(\A#{Regexp.escape(normalized_path)}(/.+)?\z)
    end
  end

  def current_url
    raise StandardError, 'current_url_method is not defined.' if BootstrapNavbar.configuration.current_url_method.nil?
    eval BootstrapNavbar.configuration.current_url_method
  end

  def prepare_html(html)
    html
  end
end
