module Entities
  class WorkoutBlock < Grape::Entity
    expose :id
    expose :workout_id
    expose :order_index
    expose :target_ftp_percentage
    expose :duration
    expose :block_type
    expose :created_at
    expose :updated_at
  end
end
