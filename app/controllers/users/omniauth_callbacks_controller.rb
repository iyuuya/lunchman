# cf) http://sourcey.com/rails-4-omniauth-using-devise-with-twitter-facebook-and-linkedin/
# cf) http://www.ohmyenter.com/?p=668

class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def google_oauth2
    ActiveRecord::Base.transaction do
      @user = User.find_for_oauth(request.env["omniauth.auth"], current_user )

      if @user.persisted?
        flash[:notice] = I18n.t "devise.omniauth_callbacks.success", :kind => "Google"
        sign_in_and_redirect @user, :event => :authentication
      else
        session["devise.google_data"] = request.env["omniauth.auth"]
        redirect_to new_user_registration_url #to Google etc
      end
    end

  end

  def after_sign_in_path_for(resource)
    info_users_path
  end

end
