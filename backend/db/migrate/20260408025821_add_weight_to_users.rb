class AddWeightToUsers < ActiveRecord::Migration[8.0]
  def change
    add_column :users, :weight, :float
  end
end
