class AddUserIdToUserFtps < ActiveRecord::Migration[8.0]
  def change
    add_reference :user_ftps, :user, null: true, foreign_key: true
    add_index :user_ftps, [:user_id, :created_at]
  end
end
