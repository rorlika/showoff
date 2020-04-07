require "rails_helper"

RSpec.describe SessionsController, type: :controller do
  describe 'POST Sessions' do
    describe 'when params are valid' do
      let(:params) do
        {
          username: 'user@showoff.ie',
          password: 'password'
        }
      end

      it 'return error message' do
        post :create, params: params
        expect(response.status).to eq(302)
        expect(flash[:error]).to be_nil
      end
    end
  end
end
