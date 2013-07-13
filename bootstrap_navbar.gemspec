# encoding: utf-8

lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require 'bootstrap_navbar/version'

Gem::Specification.new do |gem|
  gem.name          = 'bootstrap_navbar'
  gem.version       = BootstrapNavbar::VERSION
  gem.platform      = Gem::Platform::RUBY
  gem.authors       = ['Manuel Meurer']
  gem.email         = 'manuel.meurer@gmail.com'
  gem.summary       = 'Helpers to generate a Twitter Bootstrap style navbar'
  gem.description   = 'Helpers to generate a Twitter Bootstrap style navbar'
  gem.homepage      = 'https://github.com/krautcomputing/bootstrap_navbar'
  gem.license       = 'MIT'

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r(^bin/)).map { |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r(^(test|spec|features)/))
  gem.require_paths = ['lib']

  gem.add_development_dependency 'rake', '>= 10.0.0'
  gem.add_development_dependency 'rspec', '~> 2.13.0'
  gem.add_development_dependency 'rspec-html-matchers', '~> 0.4.1'
  gem.add_development_dependency 'guard-rspec', '~> 3.0'
end
