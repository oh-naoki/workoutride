require 'rails_helper'

RSpec.describe 'API::V1::WorkoutSummaries', type: :request do
  describe 'GET /api/v1/workout_summaries' do
    context 'when workout summaries exist' do
      let!(:workout_summaries) { create_list(:workout_summary, 3) }

      before { get '/api/v1/workout_summaries' }

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
      before { get '/api/v1/workout_summaries' }

      it 'returns HTTP status 200' do
        expect(response).to have_http_status(:ok)
      end

      it 'returns an empty array' do
        expect(JSON.parse(response.body)).to eq([])
      end
    end
  end
end
