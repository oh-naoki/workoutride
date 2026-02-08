require 'rails_helper'

RSpec.describe 'V1::WorkoutResults', type: :request do
  let!(:workout_summary) { create(:workout_summary) }
  let!(:workout_block) { create(:workout_block, workout_summary: workout_summary) }

  describe 'GET /api/v1/workout_results' do
    let!(:workout_result) { create(:workout_result, workout_summary: workout_summary) }

    it 'returns all workout results' do
      get '/api/v1/workout_results'
      expect(response).to have_http_status(:ok)
      json = JSON.parse(response.body)
      expect(json.length).to eq(1)
      expect(json.first['workout_summary_id']).to eq(workout_summary.id)
    end

    it 'filters by workout_summary_id' do
      other_summary = create(:workout_summary)
      create(:workout_result, workout_summary: other_summary)

      get '/api/v1/workout_results', params: { workout_summary_id: workout_summary.id }
      json = JSON.parse(response.body)
      expect(json.length).to eq(1)
      expect(json.first['workout_summary_id']).to eq(workout_summary.id)
    end
  end

  describe 'GET /api/v1/workout_results/:id' do
    let!(:workout_result) { create(:workout_result, workout_summary: workout_summary) }

    it 'returns the workout result with block results' do
      create(:workout_block_result, workout_result: workout_result, workout_block: workout_block)

      get "/api/v1/workout_results/#{workout_result.id}"
      expect(response).to have_http_status(:ok)
      json = JSON.parse(response.body)
      expect(json['id']).to eq(workout_result.id)
      expect(json['workout_block_results'].length).to eq(1)
    end
  end

  describe 'POST /api/v1/workout_results' do
    it 'creates a workout result with block results' do
      params = {
        workout_summary_id: workout_summary.id,
        started_at: Time.current.iso8601,
        finished_at: (Time.current + 1.hour).iso8601,
        total_duration_seconds: 3600,
        average_power: 200,
        max_power: 350,
        average_cadence: 85,
        status: 'completed',
        workout_block_results: [
          {
            workout_block_id: workout_block.id,
            average_power: 210,
            max_power: 300,
            average_cadence: 90,
            duration_seconds: 300
          }
        ]
      }

      expect {
        post '/api/v1/workout_results', params: params
      }.to change(WorkoutResult, :count).by(1)
        .and change(WorkoutBlockResult, :count).by(1)

      expect(response).to have_http_status(:created)
      json = JSON.parse(response.body)
      expect(json['status']).to eq('completed')
      expect(json['workout_block_results'].length).to eq(1)
    end

    it 'creates an abandoned workout result' do
      params = {
        workout_summary_id: workout_summary.id,
        started_at: Time.current.iso8601,
        total_duration_seconds: 600,
        status: 'abandoned'
      }

      expect {
        post '/api/v1/workout_results', params: params
      }.to change(WorkoutResult, :count).by(1)

      expect(response).to have_http_status(:created)
      json = JSON.parse(response.body)
      expect(json['status']).to eq('abandoned')
    end
  end
end
