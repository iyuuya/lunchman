# cf) http://sourcey.com/rails-4-omniauth-using-devise-with-twitter-facebook-and-linkedin/
# cf) http://www.ohmyenter.com/?p=668

class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  before_filter :redirect_info_page_if_logged_in

  def google_oauth2

    auth = request.env["omniauth.auth"]

    user = User.find_or_create_with_email( auth )

    # サインイン成功
    flash[:notice] = I18n.t "devise.sessions.signed_in"
    sign_in_and_redirect user, event: :authentication
  end

  def after_sign_in_path_for(resource)
    info_users_path
  end


  def redirect_info_page_if_logged_in
    redirect_to info_users_path if user_signed_in?
  end

end
