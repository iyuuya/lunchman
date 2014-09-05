class Participant < ActiveRecord::Base
  belongs_to :user
  belongs_to :event

  validates :event_id, presence: true, numericality: true
  validates :user_id, presence: true, numericality: true
  validates :comment, length: { maximum: 128 }, allow_blank: true
  validates_with Validators::EventParticipateValidator
end
