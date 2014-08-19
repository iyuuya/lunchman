class Event < ActiveRecord::Base

  has_many :users, foreign_key: :leader_user_id
end
