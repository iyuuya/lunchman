class Identity < ActiveRecord::Base
  belongs_to :user
  validate :uid, presence: true, uniqueness: { scope: :provider }

  def self.find_or_create_identity( auth, user )
    # authの情報から情報取得
    identity = find_or_create_by(uid: auth.uid, provider: auth.provider)

    if identity.user.blank?
      identity.user = user
      identity.save!
    end

    identity

  end
end
