require 'rails_helper'

RSpec.describe 'API::V1::WorkoutSummaries', type: :request do
  let(:user) { User.create!(provider: 'google', uid: '12345') }
  let(:auth_token) { user.auth_tokens.create!(token: SecureRandom.hex(32), expires_at: 30.days.from_now) }
  let(:headers) { { 'Authorization' => "Bearer #{auth_token.token}" } }

  describe 'GET /api/v1/workout_summaries' do
    context 'when workout summaries exist' do
      let!(:workout_summaries) { create_list(:workout_summary, 3) }

      before { get '/api/v1/workout_summaries', headers: headers }

      it 'returns HTTP status 200' do
        expect(response).to have_http_status(:ok)
      end

      it 'returns all workout summaries' do
        expect(JSON.parse(response.body).size).to eq(3)
      end

      it 'returns workout summaries with correct attributes' do
        json_response = JSON.parse(response.body)
        first_summary = json_response.first

        expect(first_summary).to have_key('id')
        expect(first_summary).to have_key('name')
        expect(first_summary).to have_key('total_duration')
        expect(first_summary).to have_key('category')
        expect(first_summary).to have_key('created_at')
        expect(first_summary).to have_key('updated_at')
      end

      it 'does not expose internal attributes' do
        json_response = JSON.parse(response.body)
        first_summary = json_response.first

        expect(first_summary).not_to have_key('password')
        expect(first_summary).not_to have_key('secret')
      end
    end

    context 'when no workout summaries exist' do
      before { get '/api/v1/workout_summaries', headers: headers }

      it 'returns HTTP status 200' do
        expect(response).to have_http_status(:ok)
      end

      it 'returns an empty array' do
        expect(JSON.parse(response.body)).to eq([])
      end
    end

    context 'without authentication' do
      it 'returns 401' do
        get '/api/v1/workout_summaries'
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end
end
