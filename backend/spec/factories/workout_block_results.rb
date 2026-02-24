FactoryBot.define do
  factory :workout_block_result do
    association :workout_result
    association :workout_block
    average_power { 200 }
    max_power { 300 }
    average_cadence { 85 }
    duration_seconds { 300 }
  end
end
