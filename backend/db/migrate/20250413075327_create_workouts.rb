class CreateWorkouts < ActiveRecord::Migration[8.0]
  def change
    create_table :workouts do |t|
      t.references :workout_summary, null: false, foreign_key: true

      t.timestamps
    end
  end
end
