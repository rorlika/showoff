require 'rails_helper'

RSpec.describe UserWidgetsController, type: :controller do
  describe 'POST #create' do
    let(:service) { instance_double(Showoff::WidgetService) }

    before do
      allow(Showoff::WidgetService).to receive(:new).and_return(service)
    end

    context 'when not logged in' do
      it 'redirects to login and does not call service' do
        post :create, params: { widget: { name: 'A', description: 'B', kind: 'visible' } }

        expect(response).to redirect_to('/users/login')
        expect(service).not_to have_received(:create)
      end
    end

    context 'when logged in and service succeeds' do
      let(:response_obj) { OpenStruct.new(success?: true, message: nil) }

      before do
        session[:user] = { 'token' => 'token-1' }
        allow(service).to receive(:create).and_return(response_obj)
      end

      it 'calls service and redirects with notice' do
        post :create, params: { widget: { name: 'A', description: 'B', kind: 'hidden' } }

        expect(service).to have_received(:create).with(hash_including('name' => 'A', 'description' => 'B', 'kind' => 'hidden'), 'token-1')
        expect(response).to redirect_to(user_widgets_index_me_path)
        expect(flash[:notice]).to eq('Widget was successfully created.')
      end
    end

    context 'when logged in and service fails with message' do
      let(:response_obj) { OpenStruct.new(success?: false, message: 'invalid') }

      before do
        session[:user] = { 'token' => 'token-1' }
        allow(service).to receive(:create).and_return(response_obj)
      end

      it 'redirects with alert message' do
        post :create, params: { widget: { name: 'A', description: 'B', kind: 'hidden' } }

        expect(response).to redirect_to(user_widgets_index_me_path)
        expect(flash[:alert]).to eq('invalid')
      end
    end

    context 'when logged in and service fails without message' do
      let(:response_obj) { OpenStruct.new(success?: false, message: nil) }

      before do
        session[:user] = { 'token' => 'token-1' }
        allow(service).to receive(:create).and_return(response_obj)
      end

      it 'uses fallback alert message' do
        post :create, params: { widget: { name: 'A', description: 'B', kind: 'hidden' } }

        expect(response).to redirect_to(user_widgets_index_me_path)
        expect(flash[:alert]).to eq('Unable to create widget.')
      end
    end
  end
end
