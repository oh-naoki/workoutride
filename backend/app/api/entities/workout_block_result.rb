module Entities
  class WorkoutBlockResult < Grape::Entity
    expose :id
    expose :workout_result_id
    expose :workout_block_id
    expose :average_power
    expose :max_power
    expose :average_cadence
    expose :duration_seconds
    expose :created_at
    expose :updated_at
  end
end
