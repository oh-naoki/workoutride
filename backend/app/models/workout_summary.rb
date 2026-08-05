class WorkoutSummary < ApplicationRecord
  belongs_to :category

  has_many :workout_blocks, dependent: :destroy
  has_many :workout_results, dependent: :destroy
end
