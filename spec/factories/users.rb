FactoryGirl.define do
  factory :user do
    name                { Faker::Name.name }
    email               { Faker::Internet.slug + Faker::Internet.free_email }
    password            { Faker::Internet.password }
  end
end
