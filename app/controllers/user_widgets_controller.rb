class UserWidgetsController < ApplicationController
  def index_me
    @widgets ||= Showoff::WidgetService.new(session[:access_token]).my_widgets
  end
end
