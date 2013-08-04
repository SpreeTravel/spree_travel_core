Spree::Promotion.class_eval do

  has_attached_file :attachment,
                    :styles => { :index => '214x159#',
                                  :show => '274x200#'},
                    :url => '/spree/promo/attachment/:id/:style/:basename.:extension',
                    :path => ':rails_root/public/spree/promo/attachment/:id/:style/:basename.:extension'

  has_attached_file :small_attachment,
                    :styles => { :normal => '210x120#' },
                    :url => '/spree/promo/small_attachment/:id/:style/:basename.:extension',
                    :path => ':rails_root/public/spree/promo/small_attachment/:id/:style/:basename.:extension'


  def products
        self.rules.collect {|rule| rule.products}.flatten.uniq
    end
end
