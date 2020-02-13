FactoryBot.define do
  factory :context, class: Spree::Context do
    after(:create) do |context|
      2.times do
        context.option_values << [create(:context_option_values)]
      end
    end
  end
end