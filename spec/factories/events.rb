# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :event do
    name Faker::Name.title
    leader_user_id 1
    event_at { rand(1..30).days.from_now }
    deadline_at { event_at - rand(1..30).hours }
    comment "MyText"
    max_paticipants { rand(3..30) }
    venue_id 1
    status 0
    cancel_at nil

    trait :as_invalid_deadline do
        event_at { rand(1..30).days.from_now }
        deadline_at { event_at + rand(1..30).hours }
    end
  end
end
