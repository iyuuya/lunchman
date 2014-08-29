class Validators::EventParticipateValidator < ActiveModel::Validator
  def validate(record)
    unless record.event.participatable?
      record.errors.add(:event_id, :unparticipatable_event)
    end

    if record.event.participants_max?
      record.errors.add(:event_id, :max_participants_event)
    end
  end
end
