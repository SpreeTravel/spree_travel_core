# encoding: UTF-8
Gem::Specification.new do |s|
  s.platform    = Gem::Platform::RUBY
  s.name        = 'spree_travel'
  s.version     = '2.0.3'
  s.summary     = 'Spree Travel Skeleton'
  s.description = 'Spree Travel Abstract Models, references to abstract Locations, etc.'
  s.required_ruby_version = '>= 1.9.3'

  s.author    = 'OpenJAF'
  s.email     = 'pqr@openjaf.com'
  s.homepage  = 'http://github.com/openjaf/spree_travel/spree_travel'

  #s.files       = `git ls-files`.split("\n")
  #s.test_files  = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.require_path = 'lib'
  s.requirements << 'none'

  s.add_dependency 'spree_core', '~> 2.0.3'
  #s.add_dependency 'spree_enhanced_relations'
  #s.add_dependency 'spree_enhanced_banner'
  #s.add_dependency 'spree_fancy_menu'
  #s.add_dependency 'spree_location'
  #s.add_dependency 'spree_openerp_communicator'
  #s.add_dependency 'spree_property_type'

  s.add_development_dependency 'capybara', '~> 2.0'
  s.add_development_dependency 'coffee-rails'
  s.add_development_dependency 'database_cleaner'
  s.add_development_dependency 'factory_girl', '~> 4.2'
  s.add_development_dependency 'ffaker'
  s.add_development_dependency 'rspec-rails',  '~> 2.11'
  s.add_development_dependency 'sass-rails'
  s.add_development_dependency 'selenium-webdriver'
  s.add_development_dependency 'simplecov'
  s.add_development_dependency 'sqlite3'
end
