class UsersController < ApplicationController
  def create
    response = Showoff::UserService.new.register(user_params)

    if response.success?
      session[:user] = response.data
      redirect_to root_path, notice: 'Account created successfully.'
    else
      flash.now[:alert] = response.message || 'Unable to create account.'
      render :new
    end
  end

  def show
    @user = current_user

    unless @user
      redirect_to '/users/login', alert: 'You need to login first.'
    end
  end

  def reset_password
    response = Showoff::UserService.new.reset_password(reset_password_params)

    if response.success?
      redirect_to '/users/login', notice: 'Password reset instructions sent.'
    else
      redirect_to '/users/login', alert: response.message || 'Unable to reset password.'
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password, :image_url)
  end

  def reset_password_params
    params.require(:user).permit(:email)
  end
end
