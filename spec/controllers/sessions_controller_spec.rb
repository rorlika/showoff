require 'rails_helper'

RSpec.describe SessionsController, type: :controller do
  describe 'POST #create' do
    let(:service) { instance_double(Showoff::AuthService) }

    before do
      allow(Showoff::AuthService).to receive(:new).and_return(service)
    end

    context 'when login succeeds' do
      let(:user_data) { { 'id' => 1, 'token' => 'tkn' } }
      let(:response_obj) { OpenStruct.new(success?: true, data: user_data, message: nil) }

      it 'stores user in session and redirects to root with notice' do
        allow(service).to receive(:login).and_return(response_obj)

        post :create, params: { user: { email: 'test@example.com', password: 'secret' } }

        expect(session[:user]).to eq(user_data)
        expect(response).to redirect_to(root_path)
        expect(flash[:notice]).to eq('Successfully logged in.')
      end
    end

    context 'when login fails with message' do
      let(:response_obj) { OpenStruct.new(success?: false, data: nil, message: 'Bad credentials') }

      it 'renders new with alert' do
        allow(service).to receive(:login).and_return(response_obj)

        post :create, params: { user: { email: 'test@example.com', password: 'wrong' } }

        expect(response).to render_template(:new)
        expect(flash.now[:alert]).to eq('Bad credentials')
      end
    end

    context 'when login fails without message' do
      let(:response_obj) { OpenStruct.new(success?: false, data: nil, message: nil) }

      it 'renders new with fallback alert' do
        allow(service).to receive(:login).and_return(response_obj)

        post :create, params: { user: { email: 'test@example.com', password: 'wrong' } }

        expect(response).to render_template(:new)
        expect(flash.now[:alert]).to eq('Invalid email or password.')
      end
    end
  end

  describe 'GET #destroy' do
    it 'resets session and redirects to root with notice' do
      session[:user] = { 'id' => 1 }

      get :destroy

      expect(session[:user]).to be_nil
      expect(response).to redirect_to(root_path)
      expect(flash[:notice]).to eq('Successfully logged out.')
    end
  end
end
