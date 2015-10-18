class User < ActiveRecord::Base
    belongs_to :trip
    validates :name, :email, presence: true
    validates :name, length: { maximum: 50 }
    validates :email, format: { with: /\A[\w+\-._]+?@[a-z\d\-.]+\.[a-z]+\z/i,
                                message: "Invalid format for email address" }
    validates :phone, numericality: { only_integer: true },
                      allow_blank: true
end
