# BootstrapNavbar

[![Gem Version](https://badge.fury.io/rb/bootstrap_navbar.png)](http://badge.fury.io/rb/bootstrap_navbar)
[![Build Status](https://secure.travis-ci.org/krautcomputing/bootstrap_navbar.png)](http://travis-ci.org/krautcomputing/bootstrap_navbar)
[![Dependency Status](https://gemnasium.com/krautcomputing/bootstrap_navbar.png)](https://gemnasium.com/krautcomputing/bootstrap_navbar)
[![Code Climate](https://codeclimate.com/github/krautcomputing/bootstrap_navbar.png)](https://codeclimate.com/github/krautcomputing/bootstrap_navbar)

Helpers to generate a Twitter Bootstrap style navbar

## Installation

This gem only provides a helper module with methods to generate HTML. It can be used by other gems to make these helpers available to a framework's rendering engine, e.g.:

* For Rails: https://github.com/julescopeland/Rails-Bootstrap-Navbar
* For [Middleman](http://middlemanapp.com/): https://github.com/krautcomputing/middleman-bootstrap-navbar

In short: __Unless you know what you're doing, do not use this gem directly in your app!__

## Setup

### Set current_url_method (required)

BootstrapNavbar has to be able to query for the current URL when rendering the navbar, e.g. to determine if a menu item is active or not. Since the way the current URL is determined varies depending on whether you use Rails, Sinatra, etc., this has to be set beforehand in some kind of initializer:

```ruby
# For Rails >= 3.2
BootstrapNavbar.current_url_method = 'request.original_url'
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

Check out the [Twitter Bootstrap docs](http://twitter.github.io/bootstrap/components.html#navbar) for how a navbar can be constructed. All components and options mentioned there should be supported by this gem, so you don't need to write any HTML by hand. If there is something missing or wrong HTML is generated, please [open an issue](https://github.com/krautcomputing/bootstrap_navbar/issues).

Let's assume you have mixed in the helper in your rendering engine and use Haml.

### Full example

```ruby
= nav_bar fixed: :top, responsive: true do
  = brand_link 'My great app'
  = menu_group class: 'foo', id: 'menu' do
    = menu_text 'Pick an option:'
    = menu_item "Home", root_path
    = menu_item "About Us", about_us_path
    = menu_item contact_path do
      = image_tag 'contact.jpg'
      Contact Us!
    = menu_divider
    = drop_down "Stuff" do
      = drop_down_header 'Great stuff!'
      = menu_item "One", one_path
      = menu_item "Two", two_path
      = menu_item "Three", three_path
      - if current_user.admin?
        = drop_down_divider
        = menu_item "Admin", admin_path
  = menu_group pull: 'right' do
    - if current_user
      = menu_item "Log Out", log_out_path
    - else
      = menu_item "Log In", log_in_path
```

### Methods

#### nav_bar

This method sets up the basic structure of a navbar:

```haml
= nav_bar
```

generates:

```html
<div class="navbar">
  <div class="navbar-inner">
    <div class="container">
    </div>
  </div>
</div>
```

The content of the navbar is supplied by the block and the available options:

Options `brand` and `brand_link` autogenerate the brand link:

```haml
= nav_bar brand: 'My great app', brand_link: '/start'
```

generates:

```html
<div class="navbar">
  <div class="navbar-inner">
    <div class="container">
      <a href="/start" class="brand">My great app</a>
    </div>
  </div>
</div>
```

If only `brand` is defined, `brand_link` defaults to `/`.

Option `responsive` generates a responsive navbar:

```haml
= nav_bar responsive: true
```

generates:

```html
<div class="navbar">
  <div class="navbar-inner">
    <div class="container">
      <a class="btn btn-navbar" data-toggle="collapse" data-target=".nav-collapse">
      <span class='icon-bar'></span>
      <span class='icon-bar'></span>
      <span class='icon-bar'></span>
    </div>
  </div>
</div>
```

Option `fluid` changes the grid system to be [fluid](http://twitter.github.io/bootstrap/scaffolding.html#fluidGridSystem):

```haml
= nav_bar fluid: true
```

generates:

```html
<div class="navbar">
  <div class="navbar-inner">
    <div class="container-fluid">
    </div>
  </div>
</div>
```

#### menu_group

#### menu_item

#### drop_down

#### drop_down_divider

#### drop_down_header

#### menu_divider

#### menu_text

#### brand_link

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
