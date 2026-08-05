require 'rails_helper'

RSpec.describe 'V1::UserProfile', type: :request do
  let(:user) { User.create!(provider: 'google', uid: '12345') }
  let(:auth_token) { user.auth_tokens.create! }
  let(:headers) { { 'Authorization' => "Bearer #{auth_token.token}" } }

  describe 'GET /v1/user_profile' do
    context 'when weight is set' do
      before { user.update!(weight: 65.5) }

      it 'returns the current weight' do
        get '/api/v1/user_profile', headers: headers

        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body)['weight']).to eq(65.5)
      end
    end

    context 'when weight is not set' do
      it 'returns nil weight' do
        get '/api/v1/user_profile', headers: headers

        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body)['weight']).to be_nil
      end
    end

    context 'without authentication' do
      it 'returns 401' do
        get '/api/v1/user_profile'

        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe 'PUT /v1/user_profile' do
    context 'with a valid weight' do
      it 'updates the weight' do
        put '/api/v1/user_profile', params: { weight: 70.2 }, headers: headers

        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body)['weight']).to eq(70.2)
        expect(user.reload.weight).to eq(70.2)
      end
    end

    context 'boundary values' do
      it 'accepts the lower boundary just above 0' do
        put '/api/v1/user_profile', params: { weight: 0.1 }, headers: headers
        expect(response).to have_http_status(:ok)
      end

      it 'accepts the upper boundary of 300' do
        put '/api/v1/user_profile', params: { weight: 300 }, headers: headers
        expect(response).to have_http_status(:ok)
      end

      it 'rejects 0' do
        put '/api/v1/user_profile', params: { weight: 0 }, headers: headers
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'rejects a negative weight' do
        put '/api/v1/user_profile', params: { weight: -5 }, headers: headers
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'rejects weight above 300' do
        put '/api/v1/user_profile', params: { weight: 300.1 }, headers: headers
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end

    context 'without authentication' do
      it 'returns 401' do
        put '/api/v1/user_profile', params: { weight: 70 }

        expect(response).to have_http_status(:unauthorized)
      end
    end
  end
end
