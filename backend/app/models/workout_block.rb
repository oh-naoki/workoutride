class WorkoutBlock < ApplicationRecord
  belongs_to :workout
  
  # order_indexカラムでソートするデフォルトスコープを追加
  default_scope { order(:order_index) }
end
