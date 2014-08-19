class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :omniauthable

  has_one :identity


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
