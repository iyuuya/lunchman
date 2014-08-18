# cf) http://sourcey.com/rails-4-omniauth-using-devise-with-twitter-facebook-and-linkedin/
# cf) http://www.ohmyenter.com/?p=668

class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def google_oauth2

    user = User.find_for_oauth(request.env["omniauth.auth"], current_user )

    flash[:notice] = "ログイン成功！"
    sign_in_and_redirect user, event: :authentication

  end

  def after_sign_in_path_for(resource)
    info_users_path
  end

end
