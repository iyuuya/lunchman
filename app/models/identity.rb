class Identity < ActiveRecord::Base
  belongs_to :user
  validates :uid, presence: true, uniqueness: { scope: :provider }
end
