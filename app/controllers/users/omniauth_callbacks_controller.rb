class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def google_oauth2
    auth = request.env["omniauth.auth"]
    user = User.find_or_create_with_email( auth )

    flash[:notice] = I18n.t "devise.sessions.signed_in"
    sign_in_and_redirect user, event: :authentication
  end

  def after_sign_in_path_for(resource)
    session['before_logged_in_path'] || info_users_path
  end
end
