FactoryGirl.define do
  factory :participant do
    event_id        { 1 }
    user_id         { 1 }
    comment         { Faker::Name.title }
  end
end
