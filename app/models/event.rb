class Event < ActiveRecord::Base
  STATUS_NORMAL = 0

  validates :name, presence: true, length: { maximum: 50}
  validates :comment, length: { maximum: 2000}
  validates :event_at, presence: true
  validates :leader_user_id, presence: true, numericality: true
  validates :max_paticipants,  numericality: true, inclusion: { in: 2..200 }
  validates :status, presence: true, numericality: true

  validate :deadline_at_should_be_before_event_at

  belongs_to :leader_user, class_name: 'User'


  private
  def deadline_at_should_be_before_event_at
    return unless event_at && deadline_at

    if deadline_at > event_at

      # errors.add( I18n.t("validate_errors.deadline_at_should_be_before_event_at", { deadline_at_column_name: 'aaa', event_at_column_name: 'vvv' }).to_s )
      #    # { deadline_at: :deadline_at, event_at: :event_at }) )
      errors.add(:deadline_at, :deadline_at_should_be_before_event_at, event_at: :event_at )

    end
  end

end
