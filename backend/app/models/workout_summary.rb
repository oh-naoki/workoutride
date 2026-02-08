class WorkoutSummary < ApplicationRecord
  has_many :workout_blocks, dependent: :destroy
  has_many :workout_results, dependent: :destroy
end
