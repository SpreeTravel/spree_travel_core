FactoryBot.define do
  factory :context, class: Spree::Context do

    after(:build) do |context|
        context.context_option_values << build(:context_option_value)
    end
  end
end