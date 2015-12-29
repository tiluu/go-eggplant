class AddTagToUsers < ActiveRecord::Migration
  def change
      add_column :users, :tag, :integer
      remove_column :users, :slug, :string
      
      add_index :users, :tag, unique: true
      add_index :trips, :url, unique: true

      User.all.each do |user|
          user.tag ||= SecureRandom.random_number(User.count*9999)
          user.save
      end
  end
end
