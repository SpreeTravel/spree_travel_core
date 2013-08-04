Spree::AppConfiguration.class_eval do

  #preference :admin_interface_logo, :string, :default => 'gs_marca.png'
  preference :logo, :string, :default => 'GS_marca.png'
  preference :products_per_page, :integer, :default => 10
  preference :admin_products_per_page, :integer, :default => 20
  preference :admin_pgroup_preview_size, :integer, :default => 5

end
