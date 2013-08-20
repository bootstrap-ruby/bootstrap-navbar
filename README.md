# BootstrapNavbar

[![Gem Version](https://badge.fury.io/rb/bootstrap-navbar.png)](http://badge.fury.io/rb/bootstrap-navbar)
[![Build Status](https://secure.travis-ci.org/krautcomputing/bootstrap-navbar.png)](http://travis-ci.org/krautcomputing/bootstrap-navbar)
[![Dependency Status](https://gemnasium.com/krautcomputing/bootstrap-navbar.png)](https://gemnasium.com/krautcomputing/bootstrap-navbar)
[![Code Climate](https://codeclimate.com/github/krautcomputing/bootstrap-navbar.png)](https://codeclimate.com/github/krautcomputing/bootstrap-navbar)

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

Check out the [Twitter Bootstrap docs](http://twitter.github.io/bootstrap/components.html#navbar) for how a navbar can be constructed. All components and options mentioned there should be supported by this gem, so you don't need to write any HTML by hand. If there is something missing or wrong HTML is generated, please [open an issue](https://github.com/krautcomputing/bootstrap-navbar/issues).

Let's assume you have mixed in the helper in your rendering engine and use Haml.

### Full example

```ruby
= nav_bar brand: 'My great app', brand_link: '/home', fixed: :top, responsive: true do
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
        = sub_drop_down 'Admin Stuff' do
          = menu_item "Admin Dashboard", admin_path
          = menu_item "Users", admin_users_path
  = menu_group pull: 'right' do
    - if current_user
      = menu_item "Log Out", log_out_path
    - else
      = menu_item "Log In", log_in_path
```

### Methods

#### nav_bar

This method sets up the basic structure of a navbar.

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

```haml
= nav_bar do
  Yay!
```

generates:

```html
<div class="navbar">
  <div class="navbar-inner">
    <div class="container">
      Yay!
    </div>
  </div>
</div>
```

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

**Attention: when using the `responsive` option, the brand link should not be added through the `brand_link` method but directly supplied to the `nav_bar` call.**

Don't do this:

```haml
= nav_bar responsive: true do
  = brand_link 'My great app', '/home'
```

Do this:

```haml
= nav_bar responsive: true, brand: 'My great app', brand_link: '/home'
```

Otherwise the brand link will be nested incorrectly and will disappear when resizing the window to a smaller size.

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

#### brand_link

This method generates a menu divider, to be used in a `nav_bar`.

```haml
= brand_link 'My App', '/home'
```

generates:

```html
<a href="/home" class="brand">My App</a>
```

If the path (`/home` in this case) is not specified, it defaults to `/`.

#### menu_text

This method generates some menu text, to be used in a `nav_bar`.

```haml
= menu_text 'Select a option:'
```

generates:

```html
<p class="navbar-text">
  Select a option:
</p>
```

A option can be supplied to make the text float to the right or left:

```haml
= menu_text 'Select a option:', :right
```

generates:

```html
<p class="navbar-text pull-right">
  Select a option:
</p>
```

The content can alternatively be supplied in a block:

```haml
= menu_text do
  Current country:
  = image_text 'flags/en.jpg'
```

generates:

```html
<p class="navbar-text">
  Current country:
  <img src="/images/flags/en.jpg">
</p>
```

#### menu_group

This method generates a menu group, to be used in a `nav_bar`.

```haml
= menu_group
```

generates:

```html
<ul class="nav">
</ul>
```

The content of the menu group is supplied by the blocks:

```haml
= menu_group do
  Yay!
```

generates:

```html
<ul class="nav">
  Yay!
</ul>
```

You can add a `pull` option to make the group float to the right or left, and add more classes and other attributes:

```haml
= menu_group pull: 'right', class: 'large', id: 'menu'
```

generates:

```html
<ul class="nav pull-right large" id="menu">
</ul>
```

#### menu_item

This method generates a menu item, to be used in a `menu_group`.

```haml
= menu_item 'Home', '/home'
```

generates:

```html
<li>
  <a href="/home">
    Home
  </a>
</li>
```

If the path (`/home` in this case) is not specified, it defaults to `#`.

You can also use a block (e.g., in case the link name is more than a single word):

```haml
= menu_item /home' do
  = image_tag 'home.png'
  Home
```

generates:

```html
<li>
  <a href="/home">
    <img src="/images/home.png">
    Home
  </a>
</li>
```

You can add options that will be passed on to the `li` and `a` elements:

```haml
= menu_item 'Home', '/home', { class: 'list-item' }, { id: 'home' }
```

generates:

```html
<li class="list-item">
  <a href="/home" id="home">
    Home
  </a>
</li>
```

If the specified path/URL is the [current url](#set-current_url_method-required), it will be marked as `active`. Note that it doesn't matter if you link to a full URL or just the path, or if `BootstrapNavbar.current_url_method` returns a full URL or just the path, it will work regardless.

```haml
= menu_item 'Home', '/home'
```

generates:

```html
<!-- If the current path is /home -->

<li class="active">
  <a href="/home">
    Home
  </a>
</li>
```

#### menu_divider

This method generates a menu divider, to be used in a `menu_group`.

```haml
= menu_divider
```

generates:

```html
<li class="divider-vertical"></li>
```

#### drop_down

This method generates a dropdown, to be used in a `menu_group`.

```haml
= drop_down 'Settings'
```

generates:

```html
<li class="dropdown">
  <a href="#" class="dropdown-toggle" data-toggle="dropdown">
    Settings <b class="caret"></b>
  </a>
  <ul class="dropdown-menu">
  </ul>
</li>
```

The content of the dropdown can be defined in the block using `menu_item`s:

```haml
= drop_down 'Settings' do
  = menu_item 'Basic', '/settings/basic'
  = menu_item 'Advanced', '/settings/advanced'
```

generates:

```html
<li class="dropdown">
  <a href="#" class="dropdown-toggle" data-toggle="dropdown">
    Settings <b class="caret"></b>
  </a>
  <ul class="dropdown-menu">
    <li>
      <a href="/settings/basic">
        Basic
      </a>
    </li>
    <li>
      <a href="/settings/advanced">
        Advanced
      </a>
    </li>
  </ul>
</li>
```

#### sub_drop_down

This method generates a sub dropdown, to be used in a `drop_down`.

```haml
= sub_drop_down 'Admin Settings'
```

generates:

```html
<li class="dropdown-submenu">
  <a href="#">
    Admin Settings
  </a>
  <ul class="dropdown-menu">
  </ul>
</li>
```

Just like in the `drop_down`, the content of the sub dropdown is defined in the block:

```haml
= sub_drop_down 'Admin Settings' do
  = menu_item 'Users', '/settings/admin/users'
  = menu_item 'Stats', '/settings/admin/stats'
```

generates:

```html
<li class="dropdown-submenu">
  <a href="#">
    Admin Settings
  </a>
  <ul class="dropdown-menu">
    <li>
      <a href="/settings/admin/users">
        Users
      </a>
    </li>
    <li>
      <a href="/settings/admin/stats">
        Stats
      </a>
    </li>
  </ul>
</li>
```

#### drop_down_divider

This method generates a dropdown divider, to be used in a `drop_down` or `sub_drop_down`.

```haml
= drop_down_divider
```

generates:

```html
<li class="divider"></li>
```

#### drop_down_header

This method generates a dropdown header, to be used in a `drop_down` or `sub_drop_down`.

```haml
= drop_down_header 'Important!'
```

generates:

```html
<li class="nav-header">Important!</li>
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
