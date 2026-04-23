class WidgetsController < ApplicationController
  def index
    response = Showoff::WidgetService.new.visible_widgets

    if response.success?
      @widgets = response.data || []
    else
      @widgets = []
      flash.now[:alert] = response.message || 'Unable to load widgets.'
    end
  end

  def create
    token = current_user&.token
    response = Showoff::WidgetService.new.create(widget_params, token)

    if response.success?
      flash[:notice] = 'Widget was successfully created.'
      redirect_to widgets_path
    else
      flash[:alert] = response.message || 'Unable to create widget.'
      redirect_to widgets_path
    end
  end

  def search
    response = Showoff::WidgetService.new.search(search_params)

    if response.success?
      @widgets = response.data || []
    else
      @widgets = []
      flash.now[:alert] = response.message || 'Unable to search widgets.'
    end

    render :index
  end

  private

  def widget_params
    params.require(:widget).permit(:name, :description, :kind)
  end

  def search_params
    params.permit(:term)
  end
end
