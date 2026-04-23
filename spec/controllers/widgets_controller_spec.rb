require 'rails_helper'

RSpec.describe WidgetsController, type: :controller do
  describe 'GET #index' do
    let(:service) { instance_double(Showoff::WidgetService) }

    before do
      allow(Showoff::WidgetService).to receive(:new).and_return(service)
    end

    context 'when service succeeds with data' do
      let(:response_obj) { OpenStruct.new(success?: true, data: [{ 'id' => 1 }], message: nil) }

      it 'assigns widgets from response data' do
        allow(service).to receive(:visible_widgets).and_return(response_obj)

        get :index

        expect(assigns(:widgets)).to eq([{ 'id' => 1 }])
        expect(flash.now[:alert]).to be_nil
      end
    end

    context 'when service succeeds with nil data' do
      let(:response_obj) { OpenStruct.new(success?: true, data: nil, message: nil) }

      it 'assigns an empty array' do
        allow(service).to receive(:visible_widgets).and_return(response_obj)

        get :index

        expect(assigns(:widgets)).to eq([])
      end
    end

    context 'when service fails with message' do
      let(:response_obj) { OpenStruct.new(success?: false, data: nil, message: 'boom') }

      it 'assigns empty widgets and sets flash alert' do
        allow(service).to receive(:visible_widgets).and_return(response_obj)

        get :index

        expect(assigns(:widgets)).to eq([])
        expect(flash.now[:alert]).to eq('boom')
      end
    end

    context 'when service fails without message' do
      let(:response_obj) { OpenStruct.new(success?: false, data: nil, message: nil) }

      it 'uses default flash alert' do
        allow(service).to receive(:visible_widgets).and_return(response_obj)

        get :index

        expect(assigns(:widgets)).to eq([])
        expect(flash.now[:alert]).to eq('Unable to load widgets.')
      end
    end
  end

  describe 'POST #create' do
    let(:service) { instance_double(Showoff::WidgetService) }

    before do
      allow(Showoff::WidgetService).to receive(:new).and_return(service)
    end

    context 'when logged in and service succeeds' do
      let(:response_obj) { OpenStruct.new(success?: true, message: nil) }

      before do
        session[:user] = { 'token' => 'abc123' }
        allow(service).to receive(:create).and_return(response_obj)
      end

      it 'calls service with params and token, then redirects with notice' do
        post :create, params: { widget: { name: 'My Widget', description: 'desc', kind: 'visible' } }

        expect(service).to have_received(:create).with(hash_including('name' => 'My Widget', 'description' => 'desc', 'kind' => 'visible'), 'abc123')
        expect(response).to redirect_to(root_path)
        expect(flash[:notice]).to eq('Widget was successfully created.')
      end
    end

    context 'when not logged in and service fails with message' do
      let(:response_obj) { OpenStruct.new(success?: false, message: 'No token') }

      before do
        allow(service).to receive(:create).and_return(response_obj)
      end

      it 'passes nil token and redirects with alert message' do
        post :create, params: { widget: { name: 'My Widget', description: 'desc', kind: 'visible' } }

        expect(service).to have_received(:create).with(hash_including('name' => 'My Widget'), nil)
        expect(response).to redirect_to(root_path)
        expect(flash[:alert]).to eq('No token')
      end
    end

    context 'when service fails without message' do
      let(:response_obj) { OpenStruct.new(success?: false, message: nil) }

      before do
        allow(service).to receive(:create).and_return(response_obj)
      end

      it 'uses fallback alert message' do
        post :create, params: { widget: { name: 'My Widget', description: 'desc', kind: 'visible' } }

        expect(response).to redirect_to(root_path)
        expect(flash[:alert]).to eq('Unable to create widget.')
      end
    end
  end
end
