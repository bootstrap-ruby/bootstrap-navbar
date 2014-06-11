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
