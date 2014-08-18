# cf) http://sourcey.com/rails-4-omniauth-using-devise-with-twitter-facebook-and-linkedin/
# cf) http://www.ohmyenter.com/?p=668

class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def google_oauth2

    auth = request.env["omniauth.auth"]

    if current_user.present?
      user = current_user
    else
      user = User.find_or_create_user( auth )
    end

    identity = Identity.find_or_create_identity( auth, user )

    if identity.user == user
      # サインイン成功
      flash[:notice] = "ログイン成功！"
      sign_in_and_redirect user, event: :authentication
    else
      # サインアウト
      sign_out_and_redirect identity.user
    end
  end

  def after_sign_in_path_for(resource)
    info_users_path
  end

  def after_sign_out_path_for(resource)
    login_users_path
  end

end
