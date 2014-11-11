class Suggestion < ActiveRecord::Base
  validates :comment, length: { maximum: 128 }, presence: true
  validates :user_id, numericality: true

  belongs_to :user

  def suggest!
    return if self.comment.blank?
    save!
  end
end
