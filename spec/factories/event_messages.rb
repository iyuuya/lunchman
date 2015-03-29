FactoryGirl.define do
  factory :event_messages do
    event_id        { 1 }
    user_id         { 1 }
    message         { Faker::Name.title }
  end
end
