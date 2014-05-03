module Spree
  OrdersHelper.class_eval do

    def full_pax_count(paxes)
      count = 0
      paxes.each do |pax|
        if !pax.first_name.nil? && !pax.last_name.nil? && !pax.sex.nil? && !pax.birth.nil?
          count += 1
        end
      end
      count
    end

  end
end

