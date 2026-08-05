require 'rails_helper'

RSpec.describe 'V1::Auth', type: :request do
  let(:user) { User.create!(provider: 'google', uid: '12345') }
  let!(:auth_token) { user.auth_tokens.create! }
  let(:headers) { { 'Authorization' => "Bearer #{auth_token.token}" } }

  describe 'POST /v1/auth/google' do
    it 'signs in without requiring an Authorization header' do
      allow(Google::Auth::IDTokens).to receive(:verify_oidc).and_return('sub' => 'new-google-sub')

      post '/api/v1/auth/google', params: { id_token: 'dummy-token' }

      expect(response).to have_http_status(:created)
      json = JSON.parse(response.body)
      expect(json['token']).to be_present
      expect(json['user']['uid']).to eq('new-google-sub')
    end
  end

  describe 'DELETE /v1/auth/account' do
    let(:workout_summary) { create(:workout_summary) }

    before do
      user.user_ftps.create!(ftp_value: 250)
      result = user.workout_results.create!(
        workout_summary: workout_summary,
        started_at: Time.current,
        total_duration_seconds: 600,
        status: 'completed'
      )
      block = create(:workout_block, workout_summary: workout_summary)
      result.workout_block_results.create!(
        workout_block_id: block.id,
        duration_seconds: 300
      )
    end

    it 'deletes the user and all associated data' do
      expect {
        delete '/api/v1/auth/account', headers: headers
      }.to change(User, :count).by(-1)

      expect(response).to have_http_status(:ok)
      expect(AuthToken.where(user_id: user.id)).to be_empty
      expect(WorkoutResult.where(user_id: user.id)).to be_empty
      expect(UserFtp.where(user_id: user.id)).to be_empty
      expect(WorkoutBlockResult.count).to eq(0)
    end

    it 'does not delete other users or their data' do
      other_user = User.create!(provider: 'google', uid: '67890')
      other_user.user_ftps.create!(ftp_value: 200)

      delete '/api/v1/auth/account', headers: headers

      expect(User.exists?(other_user.id)).to be(true)
      expect(other_user.user_ftps.count).to eq(1)
    end

    context 'without authentication' do
      it 'returns 401' do
        delete '/api/v1/auth/account'

        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe 'DELETE /v1/auth/logout' do
    it 'destroys the auth token' do
      expect {
        delete '/api/v1/auth/logout', headers: headers
      }.to change { user.auth_tokens.count }.by(-1)

      expect(response).to have_http_status(:ok)
    end

    context 'without authentication' do
      it 'returns 401' do
        delete '/api/v1/auth/logout'

        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe 'GET /v1/auth/me' do
    it 'returns the current user' do
      get '/api/v1/auth/me', headers: headers

      expect(response).to have_http_status(:ok)
      json = JSON.parse(response.body)
      expect(json['id']).to eq(user.id)
      expect(json['provider']).to eq('google')
      expect(json['uid']).to eq('12345')
    end

    context 'with an expired token' do
      it 'returns 401' do
        auth_token.update!(expires_at: 1.hour.ago)

        get '/api/v1/auth/me', headers: headers

        expect(response).to have_http_status(:unauthorized)
      end
    end
  end
end
