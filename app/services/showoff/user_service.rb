module Showoff
  class UserService < Showoff::RequestService
    def create
      request(:post, '/api/v1/users')
    end

    def show(id)
      request(:get, "/api/v1/users/#{id}").user
    end

    def show_me
      request(:get, '/api/v1/users/me').user
    end

    def reset_password
      request(:post, '/api/v1/users/reset_password')
    end

    def check_email(email)
      request(:get, '/api/v1/users/email?', user_params(email))
    end

    private

    def user_params(email)
      params = credentials
      params.merge(email)
    end
  end
end
