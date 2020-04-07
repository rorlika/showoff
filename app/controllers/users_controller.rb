class UsersController < ApplicationController
  before_action :authorize, only: %i[show]

  def new
  end

  def create
    data = Showoff::UserService.new(session[:access_token], user_params).create
    fail_or_return_user(data)
  end

  def show
    @user = Showoff::UserService.new(session[:access_token]).show(params[:id])
  end

  def reset_password
    user = Showoff::UserService.new(nil, user_params).reset_password
    flash[:notice] = user.message
    redirect_to '/widgets'
  end

  private

  def user_params
    permitted = params.permit(user: [:first_name, :last_name, :email, :password])
    permitted.merge!(client_id: Rails.application.credentials.showoff_client_id,
                  client_secret: Rails.application.credentials.showoff_client_secret)
  end
end
