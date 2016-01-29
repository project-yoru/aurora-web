class CreateOauthAccesses < ActiveRecord::Migration[5.0]
  def change
    create_table :oauth_accesses do |t|
      t.string :provider
      t.string :uid
      t.string :access_token
      t.datetime :expires_at
      t.string :refresh_token
      t.string :user_name
      t.string :profile_url
      t.string :profile_name
      t.string :avatar_url

      t.timestamps null: false

      t.references :user, index: true, foreign_key: true

      t.index [:provider, :uid], unique: true
    end
  end
end
