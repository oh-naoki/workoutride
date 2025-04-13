class CreateWorkoutBlocks < ActiveRecord::Migration[8.0]
  def change
    create_table :workout_blocks do |t|
      t.references :workout, null: false, foreign_key: true
      t.integer :order_index
      t.integer :target_power
      t.integer :duration
      t.string :block_type

      t.timestamps
    end
  end
end
