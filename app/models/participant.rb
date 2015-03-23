class Participant < ActiveRecord::Base
  belongs_to :user
  belongs_to :event

  validates :event_id, presence: true, numericality: true
  validates :user_id, presence: true, numericality: true
  validates :comment, length: { maximum: 128 }, allow_blank: true
  validates :event_id, uniqueness: { scope: :user_id }
  validates_with Validators::EventParticipateValidator

  auto_html_for :comment do
    html_escape
    image
    youtube(:width => 400, :height => 250)
    link :target => "_blank", :rel => "nofollow"
    simple_format
  end

  def participate!(comment)
    self.comment = comment
    ActiveRecord::Base.transaction do
      self.save!

      if self.event.participate_count_max?
        self.event.update!(status: Event.statuses[:participants_max])
      end
    end
  end

  def cancel_participant!
    ActiveRecord::Base.transaction do
      self.destroy!

      if self.event.participants_max? && !self.event.participate_count_max?
        self.event.update!(status: Event.statuses[:normal])
      end
    end
  end
end
