class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception


  def redirect_login_page_unless_logged_in

    redirect_to login_users_path  unless user_signed_in?
  end

end
