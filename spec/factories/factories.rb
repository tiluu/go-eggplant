FactoryGirl.define do
    factory :user do
        sequence(:email) {|n| "buzz#{n}@aldrin.gov"}
        name "Buzz"
        password "themoon"
        password_confirmation "themoon"

        trait :user2 do
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

        trait :trip2 do
            name "Mars"
        end
    end

    factory :relationship, aliases: [:invite] do
        email
        user_tag
        sender
        rsvped? 
        going?
        maybe? 
        trip
        user
    end
end


