class Event < ActiveRecord::Base
  attr_accessor :event_at_date, :event_at_time, :deadline_at_date, :deadline_at_time, :participant_comment
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
  has_many :participants

  scope :participatable, -> {
    where(status: Event.statuses[:normal])
    .where('event_at > :now', { now: DateTime.now.in_time_zone })
    .where('deadline_at is null OR deadline_at > :now', { now: DateTime.now.in_time_zone })
  }

  scope :not_held, -> {
    where('event_at > :now', { now: DateTime.now.in_time_zone })
  }

  before_validation :format_event_at
  before_validation :format_deadline_at

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

  def can_participate?
    self.participatable? && !participate_count_max?
  end

  def participated?(user)
    user.participants.find_by(event_id: self.id).present?
  end

  def participate_count_max?
    self.participants.count >= self.max_participants
  end

  def update_event!(params)
    ActiveRecord::Base.transaction do
      self.update!(params)

      if self.participate_count_max?
        self.update!(status: Event.statuses[:participants_max])
      else
        self.update!(status: Event.statuses[:normal])
      end
    end
  end

  private

  def set_default_value_if_nil
    self.max_participants = 10 if self.max_participants.nil?
  end

  def format_event_at
    formatted_datetime = format_to_datetime(self.event_at_date, self.event_at_time)
    self.event_at = formatted_datetime if formatted_datetime
  end

  def format_deadline_at
    formatted_datetime = format_to_datetime(self.deadline_at_date, self.deadline_at_time)
    self.deadline_at = formatted_datetime if formatted_datetime
  end

  def format_to_datetime(date_string, time_string)
    return unless date_string.present? && time_string.present?

    date_string = date_string.gsub(/([0-9]+)年([0-9]+)月([0-9]+)日/, '\1/\2/\3')
    Time.strptime('%s %s' % [date_string, time_string], '%Y/%m/%d %H:%M').in_time_zone.to_datetime
  end
end
