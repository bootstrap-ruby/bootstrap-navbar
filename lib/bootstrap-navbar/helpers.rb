module BootstrapNavbar::Helpers
  def self.included(base)
    helper_version = BootstrapNavbar.configuration.bootstrap_version.split('.').first
    base.send :include, const_get("BootstrapNavbar::Helpers::Bootstrap#{helper_version}")
  end

  def with_preceding_space(attributes)
    ' ' << attributes unless [nil, ''].include?(attributes)
  end

  def attribute_hash_to_string(hash)
    hash.map { |k, v| %(#{k}="#{v}") }.join(' ')
  end

  def current_url?(url)
    normalized_path, normalized_current_path = [url, current_url].map do |url|
      URI.parse(url).path.sub(%r(/\z), '') rescue nil
    end
    normalized_path == normalized_current_path
  end

  def current_url
    raise StandardError, 'current_url_method is not defined.' if BootstrapNavbar.configuration.current_url_method.nil?
    eval BootstrapNavbar.configuration.current_url_method
  end

  def prepare_html(html)
    html
  end
end
