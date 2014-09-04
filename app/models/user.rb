class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :omniauthable

  has_one :identity
  has_many :event, foreign_key: :leader_user_id
  has_many :participants

  def self.find_or_create_with_email( auth )
    email_from_auth = get_email_from_auth( auth )

    user = nil

    transaction do
      # メルアドで検索、なければ登録
      user = User.where(email: email_from_auth).first_or_create(
          name: auth.extra.raw_info.name,
          password: Devise.friendly_token[0,20]
        )

      # identityも登録
      user.identity = Identity.find_or_create_by(uid: auth.uid, provider: auth.provider)
      user.save!
    end

    user
  end

  def cancel_event(event_id)
    event = self.event.find(event_id)
    event.update(status: Event.statuses[:cancel], cancel_at: DateTime.now)
  end

  def participated?(event)
    self.participants.find_by(event_id: event).normal?
  end

  def cancel_participant(event_id)
    ActiveRecord::Base.transaction do
      participant = self.participants.find_by!(event_id: event_id)
      participant.destroy

      if participant.event.participants_max? && !participant.event.participate_count_max?
        participant.event.update_attribute(:status, Event.statuses[:normal])
      end
    end
    true
  end

  def self.get_email_from_auth( auth )
    if auth.provider == 'google_oauth2'
      email = auth.info.email
    else
      # twitter、facebookの場合？
      # http://sourcey.com/rails-4-omniauth-using-devise-with-twitter-facebook-and-linkedin/
      email_is_verified = auth.info.email && (auth.info.verified || auth.info.verified_email)
      email = auth.info.email if email_is_verified
    end

    email
  end
end
