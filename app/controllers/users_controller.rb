class UsersController < ApplicationController

  def login

  end

  def logout
    sign_out
  end


  def index
    unless user_signed_in?
      redirect_to action: :login
    else
      render :info
    end
  end

  def info
    unless user_signed_in?
      redirect_to action: :login
    end
  end
end
