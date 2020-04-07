class SessionsController < ApplicationController
  def new
  end

  def create
    data = Showoff::AuthService.new(nil, session_params).create
    fail_or_return_user(data)
  end

  def destroy
    session.delete(:access_token)
    session.delete(:refresh_token)
    redirect_to '/widgets'
  end

  private

  def session_params
    params.merge!(client_id: Rails.application.credentials.showoff_client_id,
                  client_secret: Rails.application.credentials.showoff_client_secret,
                  grant_type: 'password')
    params.permit(:username, :password, :client_id, :client_secret, :grant_type)
  end
end
