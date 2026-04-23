require 'rails_helper'

RSpec.describe 'Users', type: :request do
  let(:user_service) { instance_double(Showoff::UserService) }

  before do
    allow(Showoff::UserService).to receive(:new).and_return(user_service)
  end

  describe 'POST /users' do
    let(:valid_params) do
      {
        user: {
          name: 'Request User',
          email: 'request@example.com',
          password: 'Password123!'
        }
      }
    end

    it 'returns created when service succeeds' do
      allow(user_service).to receive(:create).and_return(success?: true, payload: { id: 77 })

      post '/users', params: valid_params

      expect(response).to have_http_status(:created)
      expect(JSON.parse(response.body)).to eq('id' => 77)
    end

    it 'returns unprocessable_entity when service fails' do
      allow(user_service).to receive(:create).and_return(success?: false, error: 'Invalid')

      post '/users', params: valid_params

      expect(response).to have_http_status(:unprocessable_entity)
      expect(JSON.parse(response.body)).to eq('error' => 'Invalid')
    end
  end

  describe 'GET /users/:id' do
    it 'returns ok when found' do
      allow(user_service).to receive(:show).with('12').and_return(success: true, payload: { id: 12 })

      get '/users/12'

      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)).to eq('id' => 12)
    end

    it 'returns unprocessable_entity when not found' do
      allow(user_service).to receive(:show).with('999').and_return(success: false, error: 'Not found')

      get '/users/999'

      expect(response).to have_http_status(:unprocessable_entity)
      expect(JSON.parse(response.body)).to eq('error' => 'Not found')
    end
  end

  describe 'POST /users/reset_password' do
    let(:params) { { user: { email: 'request@example.com' } } }

    it 'returns ok on success' do
      allow(user_service).to receive(:reset_password).and_return(success: true, payload: { message: 'ok' })

      post '/users/reset_password', params: params

      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)).to eq('message' => 'ok')
    end

    it 'returns unprocessable_entity on failure' do
      allow(user_service).to receive(:reset_password).and_return(success: false, message: 'bad email')

      post '/users/reset_password', params: params

      expect(response).to have_http_status(:unprocessable_entity)
      expect(JSON.parse(response.body)).to eq('error' => 'bad email')
    end
  end
end
