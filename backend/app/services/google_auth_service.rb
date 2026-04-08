require 'googleauth/id_tokens/verifier'

class GoogleAuthService
  GOOGLE_CLIENT_ID = ENV.fetch('GOOGLE_CLIENT_ID')

  def initialize(id_token)
    @id_token = id_token
  end

  def verify_and_authenticate
    payload = verify_token
    find_or_create_user(payload)
  end

  private

  def verify_token
    Google::Auth::IDTokens.verify_oidc(@id_token, aud: GOOGLE_CLIENT_ID)
  rescue Google::Auth::IDTokens::VerificationError => e
    raise Grape::Exceptions::Validation.new(
      params: ['id_token'],
      message: 'Invalid Google ID token'
    )
  end

  def find_or_create_user(payload)
    User.find_or_create_by!(
      provider: 'google',
      uid: payload['sub']
    )
  end
end
