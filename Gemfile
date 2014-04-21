CONFIG = :cesar
###########################################################################
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
  GEMS_PATH = 'file:///home/cesar/workspace/rails/gems/'
  SPREE_PATH = 'file:///home/cesar/workspace/github/spree'
  SPREE_TRAVEL_PATH = '/home/cesar/workspace/github/travel'
  PROTOCOL = :path
else
  GEMS_PATH = 'http://rubygems.org'
  SPREE_TRAVEL_PATH = 'file:///media/Data/jaf/spree'
end
########################################################################

source GEMS_PATH

gem 'spree_neighbors',          :git => "#{SPREE_TRAVEL_PATH}/spree_neighbors"
#gem 'spree_filters', 	         :git => "#{SPREE_TRAVEL_PATH}/spree_filters"
#gem 'spree_search_box',         :git => "#{SPREE_TRAVEL_PATH}/spree_search_box"
gem 'spree_enhanced_relations', :git => "#{SPREE_TRAVEL_PATH}/spree_enhanced_relations"
gem 'spree_enhanced_banner',    :git => "#{SPREE_TRAVEL_PATH}/spree_enhanced_banner"
gem 'spree_enhanced_checkout',  :git => "#{SPREE_TRAVEL_PATH}/spree_enhanced_checkout"
gem 'spree_fancy_menu',         :git => "#{SPREE_TRAVEL_PATH}/spree_fancy_menu"
gem 'spree_pax',                :git => "#{SPREE_TRAVEL_PATH}/spree_pax"
gem 'spree_openerp_connector',  :git => "#{SPREE_TRAVEL_PATH}/spree_openerp_connector"

gemspec
