class HashAuthTokens < ActiveRecord::Migration[8.0]
  def up
    add_column :auth_tokens, :token_digest, :string

    # 既存トークンをハッシュ化し、発行済みセッションを無効化せずに移行する
    select_rows('SELECT id, token FROM auth_tokens').each do |id, token|
      digest = Digest::SHA256.hexdigest(token)
      execute(
        ActiveRecord::Base.sanitize_sql(
          ['UPDATE auth_tokens SET token_digest = ? WHERE id = ?', digest, id]
        )
      )
    end

    change_column_null :auth_tokens, :token_digest, false
    add_index :auth_tokens, :token_digest, unique: true
    remove_column :auth_tokens, :token
  end

  def down
    raise ActiveRecord::IrreversibleMigration, '生トークンはダイジェストから復元できません'
  end
end
