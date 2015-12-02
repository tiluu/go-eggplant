class CreateIdeas < ActiveRecord::Migration
  def change
    create_table :ideas do |t|
      t.belongs_to  :user, index: true
      t.belongs_to :trip, index: true
      t.string      :title
      t.date        :start_date
      t.date        :end_date
      t.datetime    :start_time
      t.datetime    :end_time
      t.string      :location
      t.text        :notes
      t.string      :category
      t.timestamps null: false
    end
  end
end
