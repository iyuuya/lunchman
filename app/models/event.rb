class Event < ActiveRecord::Base
  attr_accessor :event_at_date, :event_at_time, :deadline_at_date, :deadline_at_time
  after_initialize :set_default_value_if_nil

  enum status: { normal: 0, cancel: 1, participants_max: 2 }

  validates :name, presence: true, length: { maximum: 50 }
  validates :comment, length: { maximum: 2000 }
  validates :event_at, presence: true
  validates :leader_user_id, presence: true, numericality: true
  validates :max_participants, presence: true,  numericality: { greater_than: 1, less_than: 200 }
  validates :status, presence: true
  validate :validate_event_datetime

  belongs_to :leader_user, class_name: 'User'

  def participatable?
    normal? && event_at.future? && (deadline_at.blank? || (deadline_at.present? && deadline_at.future?))
  end

  private

  def validate_event_datetime
    return unless event_at && deadline_at

    if event_at.past?
      errors.add(:event_at, :event_at_should_be_after_now)
    end

    if deadline_at > event_at
      errors.add(:deadline_at, :deadline_at_should_be_before_event_at, event_at: Event.human_attribute_name(:event_at))
    end
  end

  def set_default_value_if_nil
    self.max_participants = 10 if self.max_participants.nil?
  end
end
