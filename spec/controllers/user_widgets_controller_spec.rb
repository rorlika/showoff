require "rails_helper"

RSpec.describe UserWidgetsController, type: :controller do
  describe 'GET users/widgets' do
    before do
      params = { username: 'user@showoff.ie', password: 'password' }
      params.merge!(client_id: Rails.application.credentials.showoff_client_id,
                    client_secret: Rails.application.credentials.showoff_client_secret,
                    grant_type: 'password')
      @user = Showoff::AuthService.new(nil, params).create
    end

    it 'has a 200 status code' do
      get :index_me, session: { access_token: @user.token.access_token}
      expect(response.status).to eq(200)
      expect(assigns(:widgets)).not_to be_nil
    end
  end
end
