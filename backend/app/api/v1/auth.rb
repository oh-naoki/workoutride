module V1
  class Auth < Grape::API
    helpers do
      include ::Helpers::AuthHelper
    end

    resource :auth do
      desc 'Sign in with Google'
      params do
        requires :id_token, type: String, desc: 'Google ID token'
      end
      post :google do
        user = GoogleAuthService.new(params[:id_token]).verify_and_authenticate
        auth_token = user.auth_tokens.create!

        {
          token: auth_token.token,
          expires_at: auth_token.expires_at.iso8601,
          user: {
            id: user.id,
            provider: user.provider,
            uid: user.uid
          }
        }
      end

      desc 'Sign out'
      delete :logout do
        authenticate!
        token = extract_token_from_header
        current_user.auth_tokens.find_by(token: token)&.destroy
        { message: 'Logged out successfully' }
      end

      desc 'Get current user'
      get :me do
        authenticate!
        {
          id: current_user.id,
          provider: current_user.provider,
          uid: current_user.uid
        }
      end
    end
  end
end
