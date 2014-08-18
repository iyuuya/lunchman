class UsersController < ApplicationController

  def login

  end

  def logout
    sign_out
  end


  def index
    if current_user.nil?
      redirect_to action: :login
    else
      render :info
    end
  end

  def info
    if current_user.nil?
      redirect_to action: :login
    end
  end
end
