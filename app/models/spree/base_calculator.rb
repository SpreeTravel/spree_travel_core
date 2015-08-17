module Spree
  class BaseCalculator

    def generate_all_combinations(product)
      product.rates.each do |rate|
        result = generate_combinations(rate)
      end
    end

    def generate_combinations(rate)
      product = rate.variant.product
      old_combinations  = rate.combinations.pluck(:id)
      keep_combinations = []
      new_combinations  = []
      for adults in adults_range
        for children in children_range
          price = get_rate_price(rate, adults, children)
          combination = Spree::Combinations.where(:rate_id => rate.id)
          combination = combination.where(:product_id => product.id)
          combination = combination.where(:start_date => rate.start_date.to_date)
          combination = combination.where(:end_date => rate.end_date.to_date)
          combination = combination.where(:adults => adults)
          combination = combination.where(:children => children)
	  if product.hotel?
            #TODO make shure that rooms are the first option of the variant
            combination = combination.where(:room => rate.variant.option_values.first.id) 
            combination = combination.where(:plan => rate.plan)
	  end
          combination = combination.where(:variant_id => rate.variant.id)

          the_combination = combination.first
          if the_combination
            keep_combinations << the_combination.id
          else
            the_combination = combination.first_or_create!(:price => price)
            new_combinations << the_combination.id
          end
        end
      end
      deleted_combinations = old_combinations - keep_combinations
      Spree::Combinations.where(:id => deleted_combinations).delete_all
      array = [rate.id, old_combinations.count, new_combinations.count, keep_combinations.count, deleted_combinations.count]
      Log.debug("Generating Combinations for rate %d: old=%d created=%d kept=%d delete=%d" % array)
      return {
        :original => old_combinations,
        :created => new_combinations,
        :deleted => deleted_combinations,
        :kept => keep_combinations,
      }
    rescue Exception => ex
      Log.exception(ex)
      Log.error("Couln't create combinations for rate #{rate.id}")
    end

    def destroy_combinations(rate)
      rate.combinations.delete_all
    end

  end
end
