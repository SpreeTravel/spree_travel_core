module Spree
  class Calculator::RateRoom < Calculator

    def self.description
      I18n.t('rate_room')
    end

    def compute()

        dic_rate = 	{ :adults_in_base => 2,
                       :base_price => 10,
                       :extra_adult_price => 12,
                       :child_price => 10,
                       :infant_price => 12,
                       :only_with_parents => true,

                       :price_extra => {
                           :option_types => {
                               "Meal plan" => {
                                   "Continental breakfast" => 15,
                                   "Modified American plan" => 10,
                                   "American plan" => 12
                               }
                           },

                        :property => {
                            "Meal plan" => {
                                "Continental breakfast" => 15,
                                "Modified American plan" => 10,
                                "American plan" => 12
                            }
                          }
                        }
            }

        dic_context = { :adult => 3,
                        :child => 0,
                        :infant => 0,
                        :meal_plan => "Continental breakfast",
                        :only_with_two_adults => true
        }

        result = 0

        if dic_context[:adult] >= dic[adults_in_base]
          result += dic_rate[:price_base]
        end
        if dic_context[:adult] > dic[rate_in_base]
          result += (dic_context[:adult] - dic_rate[:adult_in_base]  ) * dic_rate[:price_extra_adult]
        end
        if dic_context[:child] > 0
          result += dic_rate[:price_child] * dic_context[:child]
        end
        if dic_context[:infant] > 0
          result += dic_rate[:price_infant] * dic_context[:infant]
        end
        if dic_context[:meal_plan]
          result += dic_rate[:price_extra][dic_context[:meal_plan]]
        end


        result
      end


  end
end