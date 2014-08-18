class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :omniauthable

  def self.find_for_oauth( auth, signed_in_user = nil)

    transaction do

      # authでidentityテーブルを検索、なければ登録
      identity = Identity.find_for_oauth( auth )

      if signed_in_user.present?
        user = signed_in_user
      else
        # ユーザーを取得、なければ登録
        user = find_or_create_user( auth )
      end

      if identity.user.blank? || identity.user != user
        identity.user = user
        identity.save!
      end

      user
    end
  end


  def self.find_or_create_user( auth )
    email_from_auth = get_email_from_auth( auth )

    # メルアドで検索、なければ登録
    User.where(email: email_from_auth).first_or_create(
        name: auth.extra.raw_info.name,
        password: Devise.friendly_token[0,20]
      )
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
