module Spree::OrderDecorator
  def self.prepended(base)
    base.remove_checkout_step :delivery

    states = base.state_machine.states.map &:name
    unless states.include?(:pax)
      base.insert_checkout_step :pax, after: :address
    end

    base.state_machine.before_transition to: :pax, do: :generate_paxes
  end

    def generate_paxes
      line_items.each do |line_item|
        return if line_item.context.nil?
        count = line_item.context.adult(temporal: false).to_i
        count.times { line_item.paxes.new } if line_item.paxes.empty?
      end
    end

    def empty!
      if completed?
        raise Spree.t(:cannot_empty_completed_order)
      else
        line_items.each do |li|
          li.paxes.destroy_all
        end
        line_items.destroy_all
        updater.update_item_count
        adjustments.destroy_all
        shipments.destroy_all
        state_changes.destroy_all
        order_promotions.destroy_all

        update_totals
        persist_totals
        restart_checkout_flow
        self
      end
    end

    def find_line_item_by_variant(variant, rate=nil, context=nil,  options = {})
      line_items.detect { |line_item|
        byebug
        line_item.variant_id == variant.id &&
          line_item_options_match(line_item, options)
      }
    end
end

Spree::Order.prepend Spree::OrderDecorator