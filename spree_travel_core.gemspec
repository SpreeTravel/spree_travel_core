# encoding: UTF-8
lib = File.expand_path('../lib/', __FILE__)
$LOAD_PATH.unshift lib unless $LOAD_PATH.include?(lib)

require 'yaml'
yaml = YAML.load(File.read('SPREE_TRAVEL_VERSIONS'))
versions = yaml['gems']

Gem::Specification.new do |s|
  s.platform    = Gem::Platform::RUBY
  s.name        = 'spree_travel_core'
  s.version     = versions['spree_travel']
  s.summary     = 'Spree Travel Core'
  s.description = 'Spree Travel Abstract Models, references to abstract Locations, etc.'
  s.required_ruby_version = '>= 2.5.0'

  s.authors   = ['Pedro Quintero', 'Miguel Sancho', 'Cesar Lage', 'Raul Perez-alejo']
  s.email     = 'rperezalejo@gmail.com'
  s.homepage  = 'http://github.com/openjaf/spree_travel_core'

  s.files       = `git ls-files`.split("\n")
  s.test_files  = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.require_path = 'lib'
  s.requirements << 'none'

  # spree_version = versions['spreel']
  # s.add_dependency 'spree', versions['spree']
  # s.add_dependency 'spree_extension'
  # s.add_dependency 'redis', "~> 4.0"
  s.add_dependency 'rails', '~> 6.1.4'
  s.add_dependency 'spree_core', versions['spreel']
  s.add_dependency 'spree_api'
  s.add_dependency 'spree_backend'
  s.add_dependency 'spree_extension'
  s.add_runtime_dependency 'deface', '~> 1.0'

  # s.add_development_dependency 'spree_cmd'
  s.add_development_dependency 'redis', '~> 4.0'
  s.add_development_dependency 'pg', '>= 0.18', '< 2.0'

  s.add_development_dependency 'jsonapi-rspec'
  s.add_development_dependency 'capybara'
  s.add_development_dependency 'capybara-screenshot'
  s.add_development_dependency 'coffee-rails'
  s.add_development_dependency 'database_cleaner'
  s.add_development_dependency 'factory_bot_rails'
  s.add_development_dependency 'ffaker'
  s.add_development_dependency 'byebug'
  s.add_development_dependency 'rspec-rails', '~> 4.0'
  s.add_development_dependency 'rspec-activemodel-mocks', '~> 1.0'
  s.add_development_dependency 'sass-rails'
  s.add_development_dependency 'simplecov'
  s.add_development_dependency 'sqlite3'
  s.add_development_dependency 'webdrivers', '~> 4.0.0'
  s.add_development_dependency 'shoulda'
  s.add_development_dependency 'shoulda-matchers'
  s.add_development_dependency 'rubocop'

end
