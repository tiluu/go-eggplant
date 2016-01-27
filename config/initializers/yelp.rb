if !Rails.env.test?
# 	s = Rails.application.secrets
# 	Yelp.client.configure do |config|
# 	    config.consumer_key =  s.YELP_CONSUMER_KEY
# 	    config.consumer_secret = s.YELP_CONSUMER_SECRET
# 	    config.token = s.YELP_TOKEN
# 	    config.token_secret = s.YELP_TOKEN_SECRET
# 	end

# elsif Rails.env.production? 
    Yelp.client.configure do |config|
      config.consumer_key = ENV['YELP_CONSUMER_KEY']
      config.consumer_secret = ENV['YELP_CONSUMER_SECRET']
      config.token = ENV['YELP_TOKEN']
      config.token_secret = ENV['YELP_TOKEN_SECRET']
    end
end
