module Helpers
  module AuthHelper
    def authenticate!
      error!('Unauthorized', 401) unless current_user
    end

    def current_user
      @current_user ||= authenticate_from_token
    end

    private

    def authenticate_from_token
      token = extract_token_from_header
      return nil unless token

      auth_token = AuthToken.includes(:user).active.find_by(token: token)
      return nil unless auth_token

      auth_token.touch_last_used!
      auth_token.user
    end

    def extract_token_from_header
      header = headers['Authorization']
      header&.gsub(/^Bearer /, '')
    end
  end
end
