class CreateRelationships < ActiveRecord::Migration
  def change
    create_table :relationships do |t|
      t.string :email
      t.boolean :rsvped?
      t.boolean :going?
      t.boolean :maybe?
      t.integer :user_tag
      t.integer :user_id
      t.integer :sender
      t.integer :trip_id

      t.timestamps null: false
    end

    add_index :relationships, [:user_id, :trip_id], unique: true
  end
end
