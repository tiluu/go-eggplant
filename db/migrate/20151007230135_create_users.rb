class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.belongs_to  :trip, index: true
      t.string      :name
      t.string      :email
      t.integer     :phone

      t.timestamps null: false
    end
  end
end
