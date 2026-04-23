class UsersController < ApplicationController
  before_action :set_user, only: [:show, :destroy]

  def create
    @user = User.new(user_params)
    if @user.save
      # handle successful save
    else
      # handle failed save
    end
  end

  def show
    # existing show action implementation
  end

  def destroy
    if @user.destroy
      # handle successful deletion
    else
      # handle failed deletion
    end
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end
end
