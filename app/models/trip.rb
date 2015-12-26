class Trip < ActiveRecord::Base
    include ValidDates
    belongs_to :user
    has_many :relationships, foreign_key: "group_trip_id",
                       dependent: :destroy
    has_many :friends, through: :relationships   
    
    has_many :ideas, dependent: :destroy
    #accepts_nested_attributes_for :ideas

    validates :name, :city, :country, 
              :state_or_province, presence: true
    
    validates :name, length: { maximum: 50 }
    
    before_create :gen_trip_url

   
    def gen_trip_url 
        self.url = SecureRandom.urlsafe_base64
    end

    def get_friend_id(group)
        friend = User.find_by(email: group.email)
        group.friend_id = friend.id
    end

    def send_invite(sender, friend)
        TripMailer.trip_invite(sender, friend).deliver_now
    end
end
