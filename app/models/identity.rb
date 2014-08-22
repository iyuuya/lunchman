class Identity < ActiveRecord::Base
  belongs_to :user
  validate :uid, presence: true, uniqueness: { scope: :provider }
end
