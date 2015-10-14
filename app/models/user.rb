class User < ActiveRecord::Base
    belongs_to :trip
    validates :name, :email, presence: true
end
