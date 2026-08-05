require 'rails_helper'

RSpec.describe 'API::V1::WorkoutSummaries', type: :request do
  let(:user) { User.create!(provider: 'google', uid: '12345') }
  let(:auth_token) { user.auth_tokens.create! }
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

    context 'pagination' do
      let!(:workout_summaries) { create_list(:workout_summary, 5) }

      it 'limits results to per_page and reports the total via header' do
        get '/api/v1/workout_summaries', params: { per_page: 2 }, headers: headers

        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body).size).to eq(2)
        expect(response.headers['X-Total-Count']).to eq('5')
      end

      it 'returns the second page' do
        get '/api/v1/workout_summaries', params: { page: 2, per_page: 2 }, headers: headers

        ids = JSON.parse(response.body).map { |s| s['id'] }
        expect(ids).to eq(workout_summaries[2..3].map(&:id))
      end

      it 'rejects a per_page above the max' do
        get '/api/v1/workout_summaries', params: { per_page: 201 }, headers: headers

        expect(response).to have_http_status(:bad_request)
      end
    end
  end
end
