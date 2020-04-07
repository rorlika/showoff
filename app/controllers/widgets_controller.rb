class WidgetsController < ApplicationController
  def index
    widgets
  end

  def search
    widgets
    respond_to do |format|
      format.js  { render partial: 'layouts/widgets' , locals: { widgets: @widgets } }
      format.html { render :index }
    end
  end

  def create
    data = Showoff::WidgetService.new(session[:access_token], widget_params).create
    flash[:error] = data.message if data.message
    respond_to do |format|
      format.html { redirect_to controller: 'user_widgets', action: 'index_me' }
    end
  end

  private

  def widgets
    @widgets ||= Showoff::WidgetService.new(session[:access_token]).all(params[:search])
  end

  def widget_params
    params.permit(widget: [:name, :description, :kind])
  end
end
