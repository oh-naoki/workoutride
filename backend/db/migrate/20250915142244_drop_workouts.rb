class DropWorkouts < ActiveRecord::Migration[8.0]
  def up
    # workout_summaries の外部キーは workoutride では workouts が参照元なので不要
    # すでに MoveBlocks... でworkout_blocks->workouts FKは削除済み
    drop_table :workouts
  end

  def down
    create_table :workouts do |t|
      t.references :workout_summary, null: false, foreign_key: true
      t.timestamps
    end
  end
end
