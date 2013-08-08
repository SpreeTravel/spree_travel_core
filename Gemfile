CONFIG = :snc
#CONFIG = :remote  # :pqr, 
###########################################################################
case CONFIG
when :pqr
  GEMS_PATH = 'http://localhost/rubygems/'
  SPREE_DEVISE_PATH = 'file:///home/pqr/work/jaf/spree'
  SPREE_TRAVEL_PATH = 'file:///home/pqr/work/jaf/openjaf'
when :snc
  GEMS_PATH = 'file:///home/test/.rvm/gems/ruby-1.9.3-p392/bundler/gems/'
  SPREE_DEVISE_PATH = 'file:///media/Data/jaf/spree'
  SPREE_TRAVEL_PATH = 'file:///media/Data/jaf/spree_travel'
when :remote
  GEMS_PATH = 'http://rubygems.org'
  SPREE_DEVISE_PATH = 'https://github.com/radar'
  SPREE_TRAVEL_PATH = 'file:///media/Data/jaf/spree'
end
########################################################################

source GEMS_PATH

gem 'spree_auth_devise', 	:git => "#{SPREE_DEVISE_PATH}/spree_auth_devise", :branch => '2-0-stable'

gemspec

source GEMS_PATH

gem 'spree_auth_devise', 			:git => "#{SPREE_DEVISE_PATH}/spree_auth_devise", :branch => '2-0-stable'

gem 'spree_enhanced_relations', 	:git => "#{SPREE_TRAVEL_PATH}/spree_enhanced_relations"
gem 'spree_enhanced_banner', 		:git => "#{SPREE_TRAVEL_PATH}/spree_enhanced_banner"
gem 'spree_fancy_menu', 			:git => "#{SPREE_TRAVEL_PATH}/spree_fancy_menu"
gem 'spree_location', 				:git => "#{SPREE_TRAVEL_PATH}/spree_location"
gem 'spree_property_type', 			:git => "#{SPREE_TRAVEL_PATH}/spree_property_type"

gemspec
