class WorkoutBlock < ApplicationRecord
  belongs_to :workout_summary
  belongs_to :block_category

  # order_indexカラムでソートするデフォルトスコープを追加
  default_scope { order(:order_index) }
end
