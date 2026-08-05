FactoryBot.define do
  factory :block_category do
    sequence(:name) { |n| "block-category-#{n}" }
  end
end
