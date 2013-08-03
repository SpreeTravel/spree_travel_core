Spree::Review.class_eval do

  def before_save
    #TODO export_openerp aqui se envía la información de los reviews
    Spree::OpenerpLoader.se_podra_hacer_esto
  end
  
  
end
