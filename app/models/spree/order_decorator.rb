Spree::Order.class_eval do

    remove_checkout_step :delivery
    insert_checkout_step :pax, :after => :address

    Spree::Order.state_machine.before_transition :to => :pax, :do => :paxes_count

    def paxes_count
      self.line_items.each do |line_item|
        count = line_item.context.adult(:temporal => false).to_i + line_item.context.child(:temporal => false).to_i
        if line_item.paxes.empty?
          count.times { line_item.paxes.new }
        end
      end
        # {
        #   s = Spree::Pax.new
        #   s.line_item_id = self.line_items.first.id
        #   self.line_items.first.paxes << s
        #   }
    end

    def empty!
      line_items.each do |li|
        li.paxes.destroy_all
      end
      line_items.destroy_all
      adjustments.destroy_all
    end


end
