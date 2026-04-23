class UserWidgetsController < ApplicationController
  before_action :require_login

  def create
    response = Showoff::WidgetService.new.create(user_widget_params, current_user.token)

    if response.success?
      flash[:notice] = 'Widget was successfully created.'
      redirect_to user_widgets_index_me_path
    else
      flash[:alert] = response.message || 'Unable to create widget.'
      redirect_to user_widgets_index_me_path
    end
  end

  def index_me
    response = Showoff::WidgetService.new.user_widgets(current_user.token)

    if response.success?
      @widgets = response.data || []
    else
      @widgets = []
      flash.now[:alert] = response.message || 'Unable to load your widgets.'
    end
  end

  private

  def user_widget_params
    params.require(:widget).permit(:name, :description, :kind)
  end

  def require_login
    return if current_user.present?

    flash[:alert] = 'You need to login first.'
    redirect_to '/users/login'
  end
end
