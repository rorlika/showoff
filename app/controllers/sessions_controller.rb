class SessionsController < ApplicationController
  def new; end

  def create
    response = Showoff::AuthService.new.login(login_params)

    if response.success?
      session[:user] = response.data
      redirect_to root_path, notice: 'Successfully logged in.'
    else
      flash.now[:alert] = response.message || 'Invalid email or password.'
      render :new
    end
  end

  def destroy
    reset_session
    redirect_to root_path, notice: 'Successfully logged out.'
  end

  private

  def login_params
    params.require(:user).permit(:email, :password)
  end
end
