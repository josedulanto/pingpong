FactoryGirl.define do
  factory :user do
    email { Faker::Internet.email }
    password "password"
    password_confirmation "password"
    confirmed_at Date.today
    
    trait :josedulanto do
      email { "jose@dulan.to" }
    end
  end
end
