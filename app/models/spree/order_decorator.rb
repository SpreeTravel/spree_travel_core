module Spree
  Order.class_eval do

    remove_checkout_step :delivery
    insert_checkout_step :pax, :after => :address

    Spree::Order.state_machine.before_transition :to => :pax, :do => :paxes_count

    def paxes_count
      count = self.line_items.first.context.adult(:temporal => false).to_i + self.line_items.first.context.child(:temporal => false).to_i
      if paxes.empty?
        count.times { paxes.new }
        # {
        #   s = Spree::Pax.new
        #   s.line_item_id = self.line_items.first.id
        #   self.line_items.first.paxes << s
        #   }
      end
    end

    def paxes
      self.line_items.first.paxes
    end

    def empty!
      line_items.each do |li|
        li.paxes.destroy_all
      end
      line_items.destroy_all
      adjustments.destroy_all
    end

    def find_line_item_by_variant(variant, context, options = {})
      line_items.detect { |line_item|
        line_item.variant_id == variant.id &&
        context.line_item_id == line_item.id &&
            line_item_options_match(line_item, options)
      }
    end

  end  
end
