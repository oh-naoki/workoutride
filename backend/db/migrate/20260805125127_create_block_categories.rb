class CreateBlockCategories < ActiveRecord::Migration[8.0]
  def change
    create_table :block_categories do |t|
      t.string :name, null: false

      t.timestamps
    end
    add_index :block_categories, :name, unique: true
  end
end
