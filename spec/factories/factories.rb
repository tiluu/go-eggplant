FactoryGirl.define do
    factory :user do
        name "Buzz"
        email "buzzz@aldrin.gov"
        password "themoon"
        password_confirmation "themoon"

        after(:create) do |user|
            create_list(:trip, 2)
        end

        factory :user2 do
            id 2833
            tag 239023
            name "Mike"
            email "mike@collins.gov"
        end
    end

    factory :trip do 
        name "The Moon"
        start_date "Jan 1 2016"
        end_date "Jan 3 2016"
        city "Houston"
        state_or_province "TX"
        country "USA"
        :user
    end
end


