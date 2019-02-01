# BootstrapNavbar

[![Gem Version](https://badge.fury.io/rb/bootstrap-navbar.png)](http://badge.fury.io/rb/bootstrap-navbar)
[![Build Status](https://secure.travis-ci.org/bootstrap-ruby/bootstrap-navbar.png)](http://travis-ci.org/bootstrap-ruby/bootstrap-navbar)
[![Code Climate](https://codeclimate.com/github/bootstrap-ruby/bootstrap-navbar.png)](https://codeclimate.com/github/bootstrap-ruby/bootstrap-navbar)

Helpers to generate a Bootstrap style navbar

## Installation

This gem only provides a helper module with methods to generate HTML. It can be used by other gems to make these helpers available to a framework's rendering engine, e.g.:

* For Rails: https://github.com/bootstrap-ruby/rails-bootstrap-navbar
* For [Middleman](http://middlemanapp.com/): https://github.com/bootstrap-ruby/middleman-bootstrap-navbar

In short: __Unless you know what you're doing, do not use this gem directly in your app!__

## Requirements

Only Bootstrap >= 2.1.0 is supported. It might work with earlier versions as well though.

## Setup

### Set bootstrap_version (required)

BootstrapNavbar needs to know what version of Bootstrap it's dealing with since each version has small changes compared to the previous one.

```ruby
BootstrapNavbar.configure do |config|
  config.bootstrap_version = '4.0.0'
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

### Set up root paths (optional)

When deciding whether a navbar link is marked as current, the following steps are followed:

* If the link target is one of the root paths (only "/" by default), the link is only marked as current if the target is the current path.
* Otherwise the link is marked as current if the target is the current path or a sub path of the current path.

In certain cases you might want to treat more paths as root paths, e.g. when different locales are mapped at "/en", "/de" etc. This can be achieved by setting the `root_paths` configuration.

```ruby
BootstrapNavbar.configure do |config|
  config.root_paths = ['/', '/en', '/de'] # default: ['/']
end
```

With this configuration, if your brand link would be "/en" for example, it would not be marked as current if you are on "/en/some-page".

### Mix in the helpers into the rendering engine (required)

```ruby
# For Rails
ActionView::Base.send :include, BootstrapNavbar::Helpers
```

## Usage

Since the navbar format differs quite a bit between Bootstrap 2, 3 and 4, generating them using this gem works quite differently as well. Check out the Wiki pages for detailed instructions:

[Usage with Bootstrap 2](https://github.com/bootstrap-ruby/bootstrap-navbar/wiki/Usage-with-Bootstrap-2)

[Usage with Bootstrap 3](https://github.com/bootstrap-ruby/bootstrap-navbar/wiki/Usage-with-Bootstrap-3)

[Usage with Bootstrap 4](https://github.com/bootstrap-ruby/bootstrap-navbar/wiki/Usage-with-Bootstrap-4)

## Changes

See [CHANGELOG](CHANGELOG.md)

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

## Support

If you like this project, consider [buying me a coffee](https://www.buymeacoffee.com/279lcDtbF)! :)
