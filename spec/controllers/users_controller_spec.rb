require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  let(:user_service) { instance_double(Showoff::UserService) }

  before do
    allow(Showoff::UserService).to receive(:new).and_return(user_service)
  end

  describe 'POST #create' do
    let(:params) do
      {
        user: {
          name: 'John Doe',
          email: 'john@example.com',
          password: 'Secret123!'
        }
      }
    end

    context 'when service returns success object' do
      let(:result) { instance_double('Result', success?: true, payload: { id: 1, name: 'John Doe' }) }

      before do
        allow(user_service).to receive(:create).and_return(result)
        post :create, params: params
      end

      it 'calls service with permitted params' do
        expect(user_service).to have_received(:create).with(ActionController::Parameters.new(params[:user]).permit(:name, :email, :password))
      end

      it 'returns created status' do
        expect(response).to have_http_status(:created)
      end

      it 'renders payload as json' do
        body = JSON.parse(response.body)
        expect(body).to eq('id' => 1, 'name' => 'John Doe')
      end
    end

    context 'when service returns failed object' do
      let(:result) { instance_double('Result', success?: false, error: 'Invalid user data') }

      before do
        allow(user_service).to receive(:create).and_return(result)
        post :create, params: params
      end

      it 'returns unprocessable_entity status' do
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'renders error json' do
        body = JSON.parse(response.body)
        expect(body).to eq('error' => 'Invalid user data')
      end
    end

    context 'when service returns hash with success true and data payload' do
      let(:result) { { success: true, data: { id: 2, email: 'john@example.com' } } }

      before do
        allow(user_service).to receive(:create).and_return(result)
        post :create, params: params
      end

      it 'returns created status' do
        expect(response).to have_http_status(:created)
      end

      it 'renders data payload' do
        body = JSON.parse(response.body)
        expect(body).to eq('id' => 2, 'email' => 'john@example.com')
      end
    end

    context 'when service returns hash with typo succes true' do
      let(:result) { { succes: true, payload: { id: 3 } } }

      before do
        allow(user_service).to receive(:create).and_return(result)
        post :create, params: params
      end

      it 'is treated as success and returns created' do
        expect(response).to have_http_status(:created)
      end

      it 'renders payload' do
        body = JSON.parse(response.body)
        expect(body).to eq('id' => 3)
      end
    end

    context 'when service returns hash failure with message' do
      let(:result) { { success: false, message: 'Email already taken' } }

      before do
        allow(user_service).to receive(:create).and_return(result)
        post :create, params: params
      end

      it 'returns unprocessable_entity' do
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'renders message as error' do
        body = JSON.parse(response.body)
        expect(body).to eq('error' => 'Email already taken')
      end
    end
  end

  describe 'GET #show' do
    context 'when service succeeds' do
      let(:result) { { success: true, payload: { id: 10, name: 'Jane' } } }

      before do
        allow(user_service).to receive(:show).with('10').and_return(result)
        get :show, params: { id: 10 }
      end

      it 'calls service with id' do
        expect(user_service).to have_received(:show).with('10')
      end

      it 'returns ok' do
        expect(response).to have_http_status(:ok)
      end

      it 'renders payload' do
        expect(JSON.parse(response.body)).to eq('id' => 10, 'name' => 'Jane')
      end
    end

    context 'when service fails' do
      let(:result) { { success: false, error: 'User not found' } }

      before do
        allow(user_service).to receive(:show).and_return(result)
        get :show, params: { id: 404 }
      end

      it 'returns unprocessable_entity' do
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'renders error' do
        expect(JSON.parse(response.body)).to eq('error' => 'User not found')
      end
    end
  end

  describe 'POST #reset_password' do
    let(:params) do
      {
        user: {
          email: 'john@example.com'
        }
      }
    end

    context 'when service succeeds with object result' do
      let(:result) { instance_double('Result', success?: true, payload: { message: 'Password reset sent' }) }

      before do
        allow(user_service).to receive(:reset_password).and_return(result)
        post :reset_password, params: params
      end

      it 'calls service with permitted params' do
        expect(user_service).to have_received(:reset_password).with(ActionController::Parameters.new(params[:user]).permit(:email))
      end

      it 'returns ok' do
        expect(response).to have_http_status(:ok)
      end

      it 'renders payload' do
        expect(JSON.parse(response.body)).to eq('message' => 'Password reset sent')
      end
    end

    context 'when service fails with hash error field' do
      let(:result) { { success: false, error: 'Email not found' } }

      before do
        allow(user_service).to receive(:reset_password).and_return(result)
        post :reset_password, params: params
      end

      it 'returns unprocessable_entity' do
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'renders error' do
        expect(JSON.parse(response.body)).to eq('error' => 'Email not found')
      end
    end
  end
end
