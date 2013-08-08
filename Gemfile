CONFIG = :pqr
###########################################################################
case CONFIG
when :pqr
  GEMS_PATH = 'http://localhost/rubygems/'
  SPREE_DEVISE_PATH = 'file:///home/pqr/work/jaf/spree'
  SPREE_TRAVEL_PATH = 'file:///home/pqr/work/jaf/openjaf'
else
  GEMS_PATH = 'http://rubygems.org'
  SPREE_DEVISE_PATH = 'https://github.com/spree'
  SPREE_TRAVEL_PATH = 'https://github.com/openjaf'
end
###########################################################################

source GEMS_PATH

gem 'spree_auth_devise', 			:git => "#{SPREE_DEVISE_PATH}/spree_auth_devise", :branch => '2-0-stable'

gem 'spree_enhanced_relations', 	:git => "#{SPREE_TRAVEL_PATH}/spree_enhanced_relations"
gem 'spree_enhanced_banner', 		:git => "#{SPREE_TRAVEL_PATH}/spree_enhanced_banner"
gem 'spree_fancy_menu', 			:git => "#{SPREE_TRAVEL_PATH}/spree_fancy_menu"
gem 'spree_location', 				:git => "#{SPREE_TRAVEL_PATH}/spree_location"
gem 'spree_property_type', 			:git => "#{SPREE_TRAVEL_PATH}/spree_property_type"

gemspec
