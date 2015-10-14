class Trip < ActiveRecord::Base
    has_many :users
    validates :name, :password, presence: true
end
