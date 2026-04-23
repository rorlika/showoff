class UsersController < ApplicationController
  before_action :set_user_service

  def create
    result = @user_service.create(user_params)
    render_service_result(result, success_status: :created)
  end

  def show
    result = @user_service.show(params[:id])
    render_service_result(result)
  end

  def reset_password
    result = @user_service.reset_password(reset_password_params)
    render_service_result(result)
  end

  private

  def set_user_service
    @user_service = Showoff::UserService.new(session)
  end

  def user_params
    params.require(:user).permit(:name, :email, :password)
  end

  def reset_password_params
    params.require(:user).permit(:email)
  end
end
