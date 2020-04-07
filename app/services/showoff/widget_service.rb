module Showoff
  class WidgetService < Showoff::RequestService
    def all(term = nil)
      request(:get, '/api/v1/widgets/visible?', widget_params(term))
    end

    def my_widgets
      request(:get, '/api/v1/widgets?', widget_params)
    end

    def create
      request(:post, '/api/v1/widgets')
    end

    private

    def widget_params(term = nil)
      params = credentials
      params[:term] = term if term.present?
      params
    end
  end
end
