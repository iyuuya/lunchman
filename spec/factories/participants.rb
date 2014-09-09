FactoryGirl.define do
  factory :participant do
    event_id        { 1 }
    user_id         { 1 }
    comment         { Faker::Name.title }

    factory :participant_without_validation do
      to_create do |instance|
        instance.save validate: false
      end
    end
  end
end
