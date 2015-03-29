class EventMessage < ActiveRecord::Base
  belongs_to :event
  belongs_to :user

  validates :event_id, presence: true, numericality: true
  validates :message, presence: true
  validates :user_id, presence: true, numericality: true

  auto_html_for :message do
    html_escape
    image
    youtube(:width => 400, :height => 250)
    link :target => "_blank", :rel => "nofollow"
    simple_format
  end
end
