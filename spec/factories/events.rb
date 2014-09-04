FactoryGirl.define do
  factory :event do
    name                { Faker::Name.title }
    leader_user_id      { 1 }
    event_at            { rand(1..30).days.from_now }
    deadline_at         { event_at - rand(1..3).hours }
    comment             { Faker::Lorem.paragraphs(1).first }
    max_participants    { rand(3..30) }
    venue_id            { 1 }
    status              { 0 }
    cancel_at           { nil }

    factory :event_without_validation do
      to_create do |instance|
        instance.save validate: false
      end
    end
  end
end
