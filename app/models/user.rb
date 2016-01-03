class User < ActiveRecord::Base
    include ValidEmails
    
    has_many :invites, class_name: "Relationship",
                        foreign_key: "user_id",
                        dependent: :destroy
    has_many :trips, through: :invites

    has_many :ideas, through: :trips
  
    has_secure_password

    validates :name, :email, :password, presence: true, on: :create
    validates :name, length: { maximum: 50 }
    
    validates :password, confirmation: true, 
                         length: { in: 6..15 },
                         allow_nil: true
                       
    validates :email, :tag, uniqueness: true

    after_create :gen_user_tag

    def gen_user_tag
        num = User.count * 9999
        update_column :tag, SecureRandom.random_number(num)
        retries = 5
    rescue ActiveRecord::RecordNotUnique => e
        retries -= 1
        retry if retries > 0
        raise e, "An error has occurred, try again later"
    end
    
    def self.authenticate(email, password)
        user = User.find_by(email: email)
        if user.present? && user.authenticate(password)
            user
        end
    end

    def self.registered?(user)
        user = User.find_by(email: user.email)
        user.present?
    end

    def generate_token(column)
        begin
            self[column]= SecureRandom.urlsafe_base64
        end while User.exists?(column => self[column])
    end

    def send_password_reset
        generate_token(:password_reset_token)
        self.password_reset_sent_at = Time.zone.now
        self.save
        UserMailer.password_reset(self).deliver
    end
end
