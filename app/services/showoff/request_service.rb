require 'rest-client'

module Showoff
  class RequestService
    BASE_URL = 'https://showoff-rails-react-production.herokuapp.com'.freeze

    def initialize(access_token, payload = {})
      @access_token = access_token
      @payload = payload.to_hash
    end

    private

    def credentials
      { client_id: Rails.application.credentials.showoff_client_id,
        client_secret: Rails.application.credentials.showoff_client_secret }
    end

    def headers(access_token = nil)
      headers = {}
      headers['Content-Type']  = 'application/x-www-form-urlencoded'
      headers['Authorization'] = "Bearer #{access_token}" unless access_token.blank?
      headers
    end

    def request(method, path, query_params = {})
      RestClient::Request.execute(method: method,
                                  url: BASE_URL + path + query_params.to_query,
                                  payload: @payload,
                                  headers: headers(@access_token)) do |response|
        fail_or_return_response_body(response)
      end
    rescue RestClient::ExceptionWithResponse => err
      err
    end

    def fail_or_return_response_body(response)
      return if response.code == 204
      result = JSON.parse(response.body, object_class: OpenStruct)
      response.code.between?(200, 206) && result.data ? result.data : result
    end
  end
end
