class RemoveAttractionFromIdeaCategories < ActiveRecord::Migration
  def change
      category = IdeaCategory.find_by_name("attraction")
      category.destroy
  end
end
