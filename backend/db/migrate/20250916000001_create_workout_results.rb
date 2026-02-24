class CreateWorkoutResults < ActiveRecord::Migration[8.0]
  def change
    create_table :workout_results do |t|
      t.references :workout_summary, null: false, foreign_key: true
      t.datetime :started_at, null: false
      t.datetime :finished_at
      t.integer :total_duration_seconds, null: false
      t.integer :average_power
      t.integer :max_power
      t.integer :average_cadence
      t.string :status, null: false, default: "completed" # completed / abandoned

      t.timestamps
    end
  end
end
