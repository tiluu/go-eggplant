class User < ActiveRecord::Base
    has_many :trips, dependent: :destroy
    has_secure_password

    validates :name, :email, :password, presence: true, on: :create
    validates :name, length: { maximum: 50 }
    
    validates :password, confirmation: true, 
                         length: { in: 6..15 }

    validates :email, uniqueness: true, 
                      format: { with: /\A[\w+\-._]+?@[a-z\d\-.]+\.[a-z]+\z/i,
                                message: "Invalid format for email address" }
    
    validates :phone, numericality: { only_integer: true },
                      allow_blank: true
end
