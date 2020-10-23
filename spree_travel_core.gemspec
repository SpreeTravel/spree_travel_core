# encoding: UTF-8

require 'yaml'
yaml = YAML.load(File.read('SPREE_TRAVEL_VERSIONS'))
versions = yaml['gems']

Gem::Specification.new do |s|
  s.platform    = Gem::Platform::RUBY
  s.name        = 'spree_travel_core'
  s.version     = versions['spree_travel']
  s.summary     = 'Spree Travel Core'
  s.description = 'Spree Travel Abstract Models, references to abstract Locations, etc.'
  s.required_ruby_version = '>= 2.6.5'

  s.authors   = ['Pedro Quintero', 'Miguel Sancho', 'Cesar Lage', 'Raul Perez-alejo']
  s.email     = 'rperezalejo@gmail.com'
  s.homepage  = 'http://github.com/openjaf/spree_travel_core'

  s.files       = `git ls-files`.split("\n")
  s.test_files  = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.require_path = 'lib'
  s.requirements << 'none'

  s.add_dependency 'spree', '~> ' + versions['spree']
end
