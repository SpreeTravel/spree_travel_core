FactoryBot.define do
  factory :context, class: Spree::Context do
    after(:create) do |context|
      2.times do
        context.context_option_values << create(:context_option_value)
      end
    end
  end
end