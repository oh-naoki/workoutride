class CreateWorkoutSummaries < ActiveRecord::Migration[8.0]
  def change
    create_table :workout_summaries do |t|
      t.string :name
      t.integer :total_duration
      t.string :category

      t.timestamps
    end
  end
end
