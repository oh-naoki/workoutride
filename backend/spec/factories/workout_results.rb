FactoryBot.define do
  factory :workout_result do
    association :workout_summary
    started_at { Time.current }
    finished_at { Time.current + 1.hour }
    total_duration_seconds { 3600 }
    average_power { 200 }
    max_power { 350 }
    average_cadence { 85 }
    status { "completed" }
  end
end
