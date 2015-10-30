class Trip < ActiveRecord::Base
    has_many :users, dependent: :destroy
    accepts_nested_attributes_for :users

    validates :name, :password, :password_confirmation, :city, 
              :country, :state_or_province, presence: true
    
    validates :name, length: { maximum: 50 }
    validates :password, confirmation: true,
                         length: { in: 6..15 }

end
