class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :omniauthable


  def self.find_for_oauth(auth, signed_in_user = nil)

    identity = Identity.find_for_oauth(auth)

    # ログイン済のユーザー？
    user = signed_in_user ? signed_in_user : identity.user

    if user.nil?
      if auth.provider == 'google_oauth2'
        email = auth.info.email
      else
        # twitter、facebookの場合？
        # http://sourcey.com/rails-4-omniauth-using-devise-with-twitter-facebook-and-linkedin/
        email_is_verified = auth.info.email && (auth.info.verified || auth.info.verified_email)
        email = auth.info.email if email_is_verified
      end

      # メルアドで検索
      user = User.where(email: email).first if email


      if user.nil?
        #ユーザーが見つからないので、deviseユーザーテーブルに登録する
        user = User.new(
          name: auth.extra.raw_info.name,
          email: email,
          password: Devise.friendly_token[0,20]
        )
        # user.skip_confirmation! #確認メールは送らない
        user.save!
      end
    end

    # OAuth用テーブルに保存
    if identity.user != user
      identity.user = user
      identity.save!
    end

    user

  end



end
