FactoryBot.define do
  factory :workout_block do
    association :workout_summary
    order_index { 0 }
    target_ftp_percentage { rand(50..150) }
    duration { rand(60..600) }
    association :block_category
  end
end
