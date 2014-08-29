class Participant < ActiveRecord::Base
  belongs_to :user
  belongs_to :event

  validates :event_id, presence: true, numericality: true
  validates :user_id, presence: true, numericality: true
  validates :comment, length: { maximum: 128 }, allow_blank: true
  validates_with Validators::EventParticipateValidator

  def create_participant
    ActiveRecord::Base.transaction do
      save!

      if self.event.participants_max?
        self.event.update_attribute(:status, Event.statuses[:participants_max])
      end
    end
    true
    rescue
      false
  end
end
