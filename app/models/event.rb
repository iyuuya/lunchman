class Event < ActiveRecord::Base
  STATUS_NORMAL = 0

  validates :name, presence: true, length: { maximum: 50}
  validates :comment, length: { maximum: 2000}
  validates :event_at, presence: true
  validates :leader_user_id, presence: true, numericality: true
  validates :max_paticipants,  numericality: true, inclusion: { in: 2..200 }
  validates :status, presence: true, numericality: true

  validate :validate_event_datetime
  belongs_to :leader_user, class_name: 'User'


  private
  def validate_event_datetime
    return unless event_at && deadline_at

    if Time.now > event_at
      errors.add(:deadline_at, :event_at_should_be_after_now )

    elsif deadline_at > event_at
      errors.add(:deadline_at, :deadline_at_should_be_before_event_at, event_at: Event.human_attribute_name(:event_at) )

    end
  end

end
