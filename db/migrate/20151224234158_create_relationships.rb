class CreateRelationships < ActiveRecord::Migration
  def change
    create_table :relationships do |t|
      t.string :email
      t.integer :friend_id
      t.integer :group_trip_id

      t.timestamps null: false
    end

    add_index :relationships, :friend_id
    add_index :relationships, :group_trip_id
    add_index :relationships, [:friend_id, :group_trip_id], unique: true
  end
end
