class CreateUserFtp < ActiveRecord::Migration[8.0]
  def change
    create_table :user_ftps do |t|
      t.integer :ftp_value, null: false
      t.datetime :created_at, null: false
      t.datetime :updated_at, null: false
    end
  end
end
