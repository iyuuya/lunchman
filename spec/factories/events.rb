# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :event do
    name "MyString"
    leader_user_id ""
    event_at "2014-08-19 12:57:49"
    deadline_at "2014-08-19 12:57:49"
    comment "MyText"
    max_paticipants ""
    venue_id 1
    status 1
    cancel_at "2014-08-19 12:57:49"
  end
end
