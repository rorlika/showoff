require 'rails_helper'

RSpec.describe 'Users', type: :request do
  let!(:user) { create(:user) }

  describe 'DELETE /users/:id' do
    context 'with valid id' do
      it 'deletes the user' do
        expect {
          delete user_path(user)
        }.to change(User, :count).by(-1)
      end

      it 'returns a 204 status' do
        delete user_path(user)
        expect(response).to have_http_status(:no_content)
      end
    end

    context 'with invalid id' do
      it 'does not delete any user' do
        expect {
          delete user_path(-1)
        }.not_to change(User, :count)
      end

      it 'returns a 404 status' do
        delete user_path(-1)
        expect(response).to have_http_status(:not_found)
      end
    end
  end
end