module Spree
  class Image < Asset
    has_attached_file :attachment,
                      :styles => { :mini => '40x40#',
                                   :small => '94x70#',
                                   :product => '274x194#',
                                   :list => '214x159#',
                                   :large => '800x600#' },
                      :default_style => :product,
                      :url => '/spree/products/:id/:style/:basename.:extension',
                      :path => ':rails_root/public/spree/products/:id/:style/:basename.:extension',
                      :default_url => 'store/no_imagen_72x72.png'

    # save the w,h of the original image (from which others can be calculated)
    # we need to look at the write-queue for images which have not been saved yet


    def asset?
      !(asset_content_type =~ /^image.*/).nil?
    end

  end
end
