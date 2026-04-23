require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  describe 'POST #create' do
    let(:service) { instance_double(Showoff::UserService) }

    before do
      allow(Showoff::UserService).to receive(:new).and_return(service)
    end

    context 'when registration succeeds' do
      let(:user_data) { { 'id' => 9, 'token' => 'abc' } }
      let(:response_obj) { OpenStruct.new(success?: true, data: user_data, message: nil) }

      it 'stores user in session and redirects to root with notice' do
        allow(service).to receive(:register).and_return(response_obj)

        post :create, params: { user: { name: 'Jane', email: 'jane@example.com', password: 'secret' } }

        expect(session[:user]).to eq(user_data)
        expect(response).to redirect_to(root_path)
        expect(flash[:notice]).to eq('Account created successfully.')
      end
    end

    context 'when registration fails with message' do
      let(:response_obj) { OpenStruct.new(success?: false, data: nil, message: 'Email taken') }

      it 'renders new with alert' do
        allow(service).to receive(:register).and_return(response_obj)

        post :create, params: { user: { name: 'Jane', email: 'jane@example.com', password: 'secret' } }

        expect(response).to render_template(:new)
        expect(flash.now[:alert]).to eq('Email taken')
      end
    end

    context 'when registration fails without message' do
      let(:response_obj) { OpenStruct.new(success?: false, data: nil, message: nil) }

      it 'renders new with fallback alert' do
        allow(service).to receive(:register).and_return(response_obj)

        post :create, params: { user: { name: 'Jane', email: 'jane@example.com', password: 'secret' } }

        expect(response).to render_template(:new)
        expect(flash.now[:alert]).to eq('Unable to create account.')
      end
    end

    describe 'GET #show' do
      context 'when current user exists' do
        it 'assigns current user' do
          session[:user] = { 'id' => 1, 'name' => 'Me', 'token' => 't' }

          get :show, params: { id: 1 }

          expect(assigns(:user)).to eq(session[:user])
          expect(response).to be_successful
        end
      end

      context 'when current user missing' do
        it 'redirects to login with alert' do
          get :show, params: { id: 1 }

          expect(response).to redirect_to('/users/login')
          expect(flash[:alert]).to eq('You need to login first.')
        end
      end
    end
  end
end
