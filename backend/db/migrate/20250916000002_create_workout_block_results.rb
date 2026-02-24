class CreateWorkoutBlockResults < ActiveRecord::Migration[8.0]
  def change
    create_table :workout_block_results do |t|
      t.references :workout_result, null: false, foreign_key: true
      t.references :workout_block, null: false, foreign_key: true
      t.integer :average_power
      t.integer :max_power
      t.integer :average_cadence
      t.integer :duration_seconds, null: false

      t.timestamps
    end
  end
end
