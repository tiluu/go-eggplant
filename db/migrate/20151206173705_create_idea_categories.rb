class CreateIdeaCategories < ActiveRecord::Migration
  def change
    create_table :idea_categories do |t|
      t.string :name
      t.timestamps null: false
    end  

    if IdeaCategory.all.empty?
        IdeaCategory.create(name: "food")
        IdeaCategory.create(name: "attraction")
        IdeaCategory.create(name: "event")
        IdeaCategory.create(name: "activity")
    end
  end
end
