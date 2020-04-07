module Showoff
  class AuthService < Showoff::RequestService
    def create
      request(:post, '/oauth/token')
    end
  end
end
