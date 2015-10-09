FactoryGirl.define do
  factory :match do
    association :player1, factory: :user
    association :player2, factory: :user
    player1_score 0
    player2_score 0
    confirmed false
    
    trait :confirmed do
      confirmed true
    end
  end
end
