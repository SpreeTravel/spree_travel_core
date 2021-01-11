FactoryBot.define do
  factory :context_option_value, class: Spree::ContextOptionValue do
    option_value {create(:option_value)}
  end
end