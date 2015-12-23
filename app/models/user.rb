class User < ActiveRecord::Base
    ROLES = %i[ADMIN TRAVEL_BUDDY]
    
    has_many :trips
    has_many :travel_groups
    has_many :ideas, through: :trips
    has_secure_password

    validates :name, :email, :password, :password_confirmation, presence: true, on: :create
    validates :name, length: { maximum: 50 }
    
    validates :password, confirmation: true, 
                         length: { in: 6..15 }

    validates :email, uniqueness: true, 
                      format: { with: /\A[\w+\-._]+?@[a-z\d\-.]+\.[a-z]+\z/i,
                                message: "Invalid format for email address" }
    
    def self.authenticate(email, password)
        user = User.find_by(email: email)
        if user.present? && user.authenticate(password)
            user
        end
    end

end
