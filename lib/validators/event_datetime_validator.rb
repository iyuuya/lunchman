class Validators::EventDateValidator < ActiveModel::Validator
  def validate(record)
    return unless record.event_at && record.deadline_at

    if record.event_at.past?
      record.errors.add(:event_at, :event_at_should_be_after_now)
    end

    if record.deadline_at > record.event_at
      record.errors.add(:deadline_at, :deadline_at_should_be_before_event_at, event_at: Event.human_attribute_name(:event_at))
    end

    if record.deadline_at.present? && record.deadline_at.past?
      record.errors.add(:deadline_at, :event_at_should_be_after_now)
    end
  end
end
