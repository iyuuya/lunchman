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
  validates_with Validators::EventDateValidator

  belongs_to :leader_user, class_name: 'User'

  def participatable?
    normal? && event_at.future? && (deadline_at.blank? || deadline_at.future?)
  end

  private

  def set_default_value_if_nil
    self.max_participants = 10 if self.max_participants.nil?
  end
end
