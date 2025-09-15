module Entities
  class WorkoutSummary < Grape::Entity
    expose :id
    expose :name
    expose :total_duration
    expose :category
    expose :created_at
    expose :updated_at
  end
end
