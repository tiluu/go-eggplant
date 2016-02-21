class Trip < ActiveRecord::Base
    include ValidDates

    has_many :invites, class_name: "Relationship",
                     foreign_key: "trip_id",
                     dependent: :destroy
    has_many :users, through: :invites

    has_many :ideas, dependent: :destroy

    validates :name, :city, :country, 
              presence: true
    
    validates :name, length: { maximum: 50 }
    validates_uniqueness_of :url

    after_create :gen_trip_url

    def trip_end
        if Date.today > end_date
            self.update_attribute(:ended?, true)
        end
    end

    ## CALLBACKS ## 
    def gen_trip_url 
        update_column :url, SecureRandom.urlsafe_base64
        not_unique = Trip.where(url: self.url).length > 1
        raise ActiveRecord::RecordNotUnique if not_unique
        retries = 5
    rescue ActiveRecord::RecordNotUnique => e
        retries -= 1
        retry if retries > 0
        raise e, "An error has occurred, try again later"
    end

end
