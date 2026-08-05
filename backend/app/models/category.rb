class Category < ApplicationRecord
  has_many :workout_summaries, dependent: :restrict_with_exception

  validates :name, presence: true, uniqueness: true
end
