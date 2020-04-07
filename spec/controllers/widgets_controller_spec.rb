require "rails_helper"

RSpec.describe WidgetsController, type: :controller do
  describe 'GET widgets' do
    it 'has a 200 status code' do
      get :index
      expect(response.status).to eq(200)
      expect(assigns(:widgets)).not_to be_nil
    end
  end

  describe 'POST widget' do
    describe 'when description is blank' do
      before do
        params = { username: 'user@showoff.ie', password: 'password' }
        params.merge!(client_id: Rails.application.credentials.showoff_client_id,
                      client_secret: Rails.application.credentials.showoff_client_secret,
                      grant_type: 'password')
        @user = Showoff::AuthService.new(nil, params).create
      end

      it 'return error' do
        post :create, params: { widget: { name: 'My Widget' } }, session: { access_token: @user.token.access_token}
        expect(response.status).to eq(302)
        expect(flash[:error]).to match(/Description can't be blank/)
      end
    end
  end

  describe 'POST widgets/search' do

    it 'return exact widget' do
      post :search, params: { search: 'widget description test purpose' }
      expect(response.status).to eq(200)
      expect(assigns(:widgets).widgets.first.name).to eq('widget test purpose')
    end
  end
end
