# BootstrapNavbar

[![Gem Version](https://badge.fury.io/rb/bootstrap-navbar.png)](http://badge.fury.io/rb/bootstrap-navbar)
[![Build Status](https://secure.travis-ci.org/bootstrap-ruby/bootstrap-navbar.png)](http://travis-ci.org/bootstrap-ruby/bootstrap-navbar)
[![Dependency Status](https://gemnasium.com/bootstrap-ruby/bootstrap-navbar.png)](https://gemnasium.com/bootstrap-ruby/bootstrap-navbar)
[![Code Climate](https://codeclimate.com/github/bootstrap-ruby/bootstrap-navbar.png)](https://codeclimate.com/github/bootstrap-ruby/bootstrap-navbar)

Helpers to generate a Twitter Bootstrap style navbar

## Installation

This gem only provides a helper module with methods to generate HTML. It can be used by other gems to make these helpers available to a framework's rendering engine, e.g.:

* For Rails: https://github.com/julescopeland/Rails-Bootstrap-Navbar
* For [Middleman](http://middlemanapp.com/): https://github.com/bootstrap-ruby/middleman-bootstrap-navbar

In short: __Unless you know what you're doing, do not use this gem directly in your app!__

## Requirements

Only Bootstrap >= 2.1.0 is supported. It might work with earlier versions as well though.

## Setup

### Set bootstrap_version (required)

BootstrapNavbar needs to know what version of Bootstrap it's dealing with since each version has small changes compared to the previous one.

```ruby
BootstrapNavbar.configure do |config|
  config.bootstrap_version = '3.0.0'
end
```

### Set current_url_method (required)

BootstrapNavbar has to be able to query for the current URL when rendering the navbar, e.g. to determine if a menu item is active or not. Since the way the current URL is determined varies depending on whether you use Rails, Sinatra, etc., this has to be set beforehand in some kind of initializer:

```ruby
# For Rails >= 3.2
BootstrapNavbar.configure do |config|
  config.current_url_method = 'request.original_url'
end
```

`current_url_method` should be set to a string which can be `eval`ed later.

### Set up HTML escaping (optional)

If the framework or rendering engine that you use BootstrapNavbar with escapes HTML by default, you can instruct BootstrapNavbar to mark the returned HTML as html_safe by default by overriding `BootstrapNavbar#prepare_html`:

```ruby
# For Rails
module BootstrapNavbar::Helpers
  def prepare_html(html)
    html.html_safe
  end
end
```

### Mix in the helpers into the rendering engine (required)

```ruby
# For Rails
ActionView::Base.send :include, BootstrapNavbar::Helpers
```

## Usage

Since the navbar format changed quite a bit between Bootstrap 2.x and 3.x, generating them using this gem is quite different as well. Check out the Wiki pages for detailed instructions:

[Usage with Bootstrap 2.x](https://github.com/bootstrap-ruby/bootstrap-navbar/wiki/Usage-with-Bootstrap-2.x)

[Usage with Bootstrap 3.x](https://github.com/bootstrap-ruby/bootstrap-navbar/wiki/Usage-with-Bootstrap-3.x)

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
