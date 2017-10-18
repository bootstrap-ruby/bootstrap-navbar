## 3.0.0

* Add support for Bootstrap 4 (for real) - big thanks to Sebastian Menhofer! (https://github.com/bootstrap-ruby/bootstrap-navbar/pull/13)

## 2.4.0

* Add support for `root_paths` configuration

## 2.3.0

* Add support for Bootstrap 4

## 2.2.4

* Never mark menu item with path "#" as active

## 2.2.3

* Allow navbar dropdown to receive list item and link parameters

## 2.2.2

* Fix marking menu items as active... again

## 2.2.1

* Fix marking menu items as active

## 2.2.0

* Make `url` the required first parameter for `navbar_form`

## 2.1.4

* Fix bug when using navbar item with 'mailto:' link

## 2.1.3

* Update test gems
* Fixed bug when using Bootstrap 3 and calling `navbar` without block

## 2.1.2

* Fixed bug when using Bootstrap 3 and `navbar_item` with block

## 2.1.1

* Fix marking sub URLs as active

## 2.1.0

* Update gem_config dependency
* Don't allow Bootstrap version configuration to be nil
* Mark sub URLs as active

## 2.0.0

* Refactor: Add navbar_header and navbar_collapse to make it possible to insert content outside of header and collapse sections.
* Refactor: remove internal list of Bootstrap versions which had to be updated every time a new Bootstrap version was released.
* Fix: make sure options that are passed into methods are not altered
