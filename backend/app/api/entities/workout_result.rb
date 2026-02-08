module Entities
  class WorkoutResult < Grape::Entity
    expose :id
    expose :workout_summary_id
    expose :started_at
    expose :finished_at
    expose :total_duration_seconds
    expose :average_power
    expose :max_power
    expose :average_cadence
    expose :status
    expose :created_at
    expose :updated_at
    expose :workout_block_results, using: Entities::WorkoutBlockResult
  end
end
