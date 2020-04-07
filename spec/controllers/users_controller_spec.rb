require "rails_helper"

RSpec.describe UsersController, type: :controller do
  describe 'POST Users' do
    describe 'when params are invalid' do
      let(:params) do
        {
          user: {
            first_name: 'first name',
            last_name: 'last name',
            password: 'password'
          }
        }
      end

      it 'return error message' do
        post :create, params: params
        expect(response.status).to eq(302)
        expect(flash[:error]).to match(/Email can't be blank/)
      end
    end
  end

  describe 'GET user' do
    before do
      params = { username: 'user@showoff.ie', password: 'password' }
      params.merge!(client_id: Rails.application.credentials.showoff_client_id,
                    client_secret: Rails.application.credentials.showoff_client_secret,
                    grant_type: 'password')
      @user = Showoff::AuthService.new(nil, params).create
    end

    it 'return user' do
      get :show, params: { id: 3960 }, session: { access_token: @user.token.access_token}
      expect(response.status).to eq(200)
      expect(assigns(:user).name).to eq('showoff user')
    end
  end

  describe 'POST users/reset_password' do
    describe 'when email is invalid' do
      it 'return exact widget' do
        post :reset_password, params: { user: { email: 'email@example.com' } }
        expect(response.status).to eq(302)
        expect(flash[:notice]).to match(/email@example.com is an invalid email address/)
      end
    end
  end
end
