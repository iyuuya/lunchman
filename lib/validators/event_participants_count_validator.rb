class Validators::EventParticipantsCountValidator < ActiveModel::Validator
  def validate(record)
    return unless record.max_participants

    if record.participants.count > record.max_participants
      record.errors.add(:max_participants, :max_participants_less_than_participants_count)
    end
  end
end
