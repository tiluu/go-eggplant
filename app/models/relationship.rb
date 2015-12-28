class Relationship < ActiveRecord::Base
    include ValidEmails

    belongs_to :user
    belongs_to :trip
    
    # belongs_to :friend, class_name: "User"
    # belongs_to :group_trip, class_name: "Trip"
    # belongs_to :invite, class_name: "User"
    # belongs_to :invited_trip, class_name: "Trip"

    validates :email, presence: true
    validates_uniqueness_of :email, scope: :trip_id, 
                            message: "%{value}: This person has already been invited"

    def self.get_user_id(invite)
        user = User.find_by(email: invite.email)
        if user
            invite.user_id = user.id
            invite.user_tag = User.find(invite.user_id).tag
        else
            randnum = SecureRandom.random_number(User.count*999)
            new_user = User.create(name: "friend#{randnum}", 
                        password: "abc#{randnum}", 
                        password_confirmation: "abc#{randnum}",
                        email: invited.email)
            invite.user_id = new_user.id
        end
        invite.save
    end

    def self.send_invite(sender, friend)
        TripMailer.trip_invite(sender, friend).deliver_now
    end

end 
