CONFIG = :cesar

case CONFIG
when :pqr
  GEMS_PATH = 'http://localhost/rubygems/'
  SPREE_TRAVEL_PATH = 'file:///home/pqr/work/jaf/openjaf'
when :snc
  GEMS_PATH = 'file:///home/test/.rvm/gems/ruby-1.9.3-p392/bundler/gems/'
  SPREE_TRAVEL_PATH = 'file:///media/Data/jaf/spree_travel'
when :raul
  GEMS_PATH = 'http://localhost/rubygems/'
  SPREE_TRAVEL_PATH = 'file:///home/raul/RubymineProjects/openjaf'
when :cesar
  GEMS_PATH = 'file:///home/cesar/workspace/rubygems/gems/'
  SPREE_PATH = 'file:///home/cesar/workspace/github/spree'
  SPREE_TRAVEL_PATH = '/home/cesar/workspace/github/travel'
  PROTOCOL = :path
when :dustet
  GEMS_PATH = 'file:///Users/dustet/rubygems'
  SPREE_TRAVEL_PATH = 'file:///Volumes/Data/Important/spree_travel/openjaf/'
else
  GEMS_PATH = 'http://rubygems.org'
  SPREE_TRAVEL_PATH = 'file:///media/Data/jaf/spree'
end

source GEMS_PATH

gem 'spree_neighbors',  :git => "#{SPREE_TRAVEL_PATH}/spree_neighbors"
gem 'spree_fancy_menu', :git => "#{SPREE_TRAVEL_PATH}/spree_fancy_menu"

gemspec
