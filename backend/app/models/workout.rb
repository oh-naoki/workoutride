class Workout < ApplicationRecord
  belongs_to :workout_summary
  has_many :workout_blocks, dependent: :destroy
end
