# BootstrapNavbar

[![Gem Version](https://badge.fury.io/rb/bootstrap_navbar.png)](http://badge.fury.io/rb/bootstrap_navbar)
[![Build Status](https://secure.travis-ci.org/krautcomputing/bootstrap_navbar.png)](http://travis-ci.org/krautcomputing/bootstrap_navbar)
[![Dependency Status](https://gemnasium.com/krautcomputing/bootstrap_navbar.png)](https://gemnasium.com/krautcomputing/bootstrap_navbar)
[![Code Climate](https://codeclimate.com/github/krautcomputing/bootstrap_navbar.png)](https://codeclimate.com/github/krautcomputing/bootstrap_navbar)

Helpers to generate a Twitter Bootstrap style navbar

## Installation

Add this line to your application's Gemfile:

    gem 'bootstrap_navbar'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install bootstrap_navbar

## Usage

### Set current_url_method

BootstrapNavbar has to be able to query for the current URL when rendering the navbar, e.g. to determine if a menu item is active or not. Since the way the current URL is determined varies depending on whether you use Rails, Sinatra etc., this has to be set beforehand in some kind of initializer:

```ruby
# For Rails >= 3.2
BootstrapNavbar.current_url_method = 'request.original_url'
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
