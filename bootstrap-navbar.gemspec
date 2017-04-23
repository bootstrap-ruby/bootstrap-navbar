lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require 'bootstrap-navbar/version'

Gem::Specification.new do |gem|
  gem.name          = 'bootstrap-navbar'
  gem.version       = BootstrapNavbar::VERSION
  gem.platform      = Gem::Platform::RUBY
  gem.author        = 'Manuel Meurer'
  gem.email         = 'manuel@krautcomputing.com'
  gem.summary       = 'Helpers to generate a Bootstrap style navbar'
  gem.description   = 'Helpers to generate a Bootstrap style navbar'
  gem.homepage      = 'http://bootstrap-ruby.github.io/bootstrap-navbar'
  gem.license       = 'MIT'

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r(^bin/)).map { |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r(^(test|spec|features)/))
  gem.require_paths = ['lib']

  gem.add_development_dependency 'rake', '>= 0.9'
  gem.add_development_dependency 'rspec', '~> 3.0'
  gem.add_development_dependency 'rspec-html-matchers', '~> 0.6'
  gem.add_development_dependency 'guard-rspec', '~> 4.2'
  gem.add_development_dependency 'padrino-helpers', '~> 0.13.3' # padrino-support 0.14.0 dropped the dependency on activesupport, which we need
  gem.add_development_dependency 'bootstrap-sass', '3.0.2.0'
  gem.add_development_dependency 'bootstrap', '4.0.0.alpha6'
  gem.add_runtime_dependency 'gem_config', '~> 0.3'
end
