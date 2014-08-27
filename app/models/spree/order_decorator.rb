module Spree
  Order.class_eval do 

    def empty!
      line_items.each do |li|
        li.paxes.destroy_all
      end
      line_items.destroy_all
      adjustments.destroy_all
    end

  end  
end
