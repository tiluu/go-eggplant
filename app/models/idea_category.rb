class IdeaCategory < ActiveRecord::Base
    has_many :ideas, through: :trip

 end
