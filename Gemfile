MODE = 'git'  #REMOTE MODE
#MODE = 'path' #LOCAL MODE

# REMOTE CONFIGURATION (DEFAULT)
GEMS_PATH = 'http://rubygems.org'
SPREE_PATH = 'https://github.com/spree'
SPREE_TRAVEL_PATH = 'https://github.com/openjaf'

## lOCAL PQR CONFIGURATION
#GEMS_PATH = 'http://localhost/rubygems/'
#SPREE_PATH = 'file:///home/pqr/work/jaf/spree'
#SPREE_TRAVEL_PATH = '..'

##########################################################

source GEMS_PATH

gem 'rails', '3.2.13'
gem 'spree_auth_devise', 			:git => "#{SPREE_PATH}/spree_auth_devise", :branch => '2-0-stable'

gem 'spree_enhanced_relations', 	:"#{MODE}" => "#{SPREE_TRAVEL_PATH}/spree_enhanced_relations"
gem 'spree_enhanced_banner', 		:"#{MODE}" => "#{SPREE_TRAVEL_PATH}/spree_enhanced_banner"
gem 'spree_fancy_menu', 			:"#{MODE}" => "#{SPREE_TRAVEL_PATH}/spree_fancy_menu"
gem 'spree_location', 				:"#{MODE}" => "#{SPREE_TRAVEL_PATH}/spree_location"
gem 'spree_property_type', 			:"#{MODE}" => "#{SPREE_TRAVEL_PATH}/spree_property_type"

gemspec
