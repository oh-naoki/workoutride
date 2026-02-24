class WorkoutBlockResult < ApplicationRecord
  belongs_to :workout_result
  belongs_to :workout_block

  validates :duration_seconds, presence: true, numericality: { greater_than_or_equal_to: 0 }
end
