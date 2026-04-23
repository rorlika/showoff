require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  let!(:user) { create(:user) }

  describe 'DELETE #destroy' do
    context 'when the user exists' do
      it 'deletes the user' do
        expect {
          delete :destroy, params: { id: user.id }
        }.to change(User, :count).by(-1)
      end

      it 'returns a 204 status' do
        delete :destroy, params: { id: user.id }
        expect(response).to have_http_status(:no_content)
      end
    end

    context 'when the user does not exist' do
      it 'does not delete any user' do
        expect {
          delete :destroy, params: { id: -1 }
        }.not_to change(User, :count)
      end

      it 'returns a 404 status' do
        delete :destroy, params: { id: -1 }
        expect(response).to have_http_status(:not_found)
      end
    end
  end
end