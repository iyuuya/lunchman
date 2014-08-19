class Event < ActiveRecord::Base
  STATUS_NORMAL = 0

  validates :name, length: { maximum: 50}, presence: true
  validates :comment, length: { maximum: 2000}
  validates :event_at, presence: true
  validates :max_paticipants,  numericality: true, inclusion: { in: 2..200 }
  validates :status, presence: true, numericality: true

  validate :deadline_at_should_be_before_event_at

  belongs_to :leader_user, class_name: 'User'


  private
  def deadline_at_should_be_before_event_at
    return unless event_at && deadline_at

    if deadline_at > event_at

      errors.add( I18n.t("errors.validate.deadline_at_should_be_before_event_at",
          deadline_at: :deadline_at, event_at: :event_at) )

    end
  end

end
