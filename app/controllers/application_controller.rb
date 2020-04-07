class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  def current_user
    @current_user ||= Showoff::UserService.new(session[:access_token]).show_me if session[:access_token]
  end

  helper_method :current_user

  def authorize
    redirect_to '/users/login' unless current_user
  end

  def fail_or_return_user(data)
    if data.is_a?(OpenStruct) && data.token.present?
      session[:access_token] = data.token.access_token
      session[:refresh_token] = data.token.refresh_token
      respond_to do |format|
        format.html { redirect_to controller: 'user_widgets', action: 'index_me' }
      end
    else
      flash[:error] = data.message
      redirect_to '/users/login'
    end
  end

  private

  def showoff_credentials
    { client_id: Rails.application.credentials.showoff_client_id,
      client_secret: Rails.application.credentials.showoff_client_secret }
  end
end
