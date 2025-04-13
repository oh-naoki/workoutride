class WorkoutSummary < ApplicationRecord
  has_many :workouts, dependent: :destroy
  has_many :workout_blocks, dependent: :destroy, through: :workouts
end
