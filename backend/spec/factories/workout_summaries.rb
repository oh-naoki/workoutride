FactoryBot.define do
  factory :workout_summary do
    name { Faker::Lorem.words(number: 3).join(' ') }
    total_duration { rand(1800..7200) }
    association :category
  end
end
