class CreateLaunchKeySessions < ActiveRecord::Migration
  def change
    create_table :launch_key_sessions do |t|
      t.string :auth
      t.string :auth_request, null: false
      t.string :user_hash, index: true

      t.timestamps
    end
  end
end
