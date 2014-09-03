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

  scope :participatable, -> {
    where(status: Event.statuses[:normal])
    .where('event_at > :now', { now: Time.now })
    .where('deadline_at is null OR deadline_at > :now', { now: Time.now })
  }

  before_validation do
    formatted_datetime = format_to_datetime(self.event_at_date, self.event_at_time)
    self.event_at = formatted_datetime if self.event_at.blank? && formatted_datetime

    formatted_datetime = format_to_datetime(self.deadline_at_date, self.deadline_at_time)
    self.deadline_at = formatted_datetime if self.deadline_at.blank? && formatted_datetime
  end

  def participatable?
    normal? && event_at.future? && (deadline_at.blank? || deadline_at.future?)
  end

  def leader?(user)
    user.present? && (user.id == leader_user_id)
  end

  def set_separated_datetime
    self.event_at_date = event_at.strftime(I18n.t('date.formats.long'))
    self.event_at_time = event_at.strftime(I18n.t('time.formats.short'))
    self.deadline_at_date = deadline_at.strftime(I18n.t('date.formats.long'))
    self.deadline_at_time = deadline_at.strftime(I18n.t('time.formats.short'))
  end

  private

  def set_default_value_if_nil
    self.max_participants = 10 if self.max_participants.nil?
  end

  def format_to_datetime(date_string, time_string)
    return unless date_string.present? && time_string.present?

    date_string = date_string.gsub(/([0-9]+)年([0-9]+)月([0-9]+)日/, '\1/\2/\3')
    DateTime.strptime('%s %s' % [date_string, time_string], '%Y/%m/%d %H:%M %p')
  end
end
