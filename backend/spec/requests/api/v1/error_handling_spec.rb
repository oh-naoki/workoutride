require 'rails_helper'

RSpec.describe 'API error handling', type: :request do
  let(:user) { User.create!(provider: 'google', uid: '12345') }
  let(:auth_token) { user.auth_tokens.create! }
  let(:headers) { { 'Authorization' => "Bearer #{auth_token.token}" } }

  describe 'ActiveRecord::RecordNotFound' do
    it 'returns a JSON 404 instead of leaking an HTML error page' do
      get '/api/v1/workout_summaries/999999', headers: headers

      expect(response).to have_http_status(:not_found)
      expect(response.content_type).to match(%r{application/json})
      expect(JSON.parse(response.body)).to eq('error' => 'Not found')
    end
  end

  describe 'ActiveRecord::RecordInvalid' do
    it 'returns a JSON 422 with the validation message' do
      post '/api/v1/user_ftps', params: { ftp_value: 0 }, headers: headers

      expect(response).to have_http_status(:unprocessable_entity)
      expect(response.content_type).to match(%r{application/json})
      expect(JSON.parse(response.body)['error']).to be_present
    end
  end

  describe 'Grape param validation errors' do
    it 'still returns 400 for missing required params (not swallowed by the catch-all)' do
      post '/api/v1/user_ftps', params: {}, headers: headers

      expect(response).to have_http_status(:bad_request)
    end
  end

  describe 'unexpected StandardError' do
    it 'returns a generic JSON 500 without leaking internals' do
      allow(WorkoutSummary).to receive(:all).and_raise(StandardError, 'boom')

      get '/api/v1/workout_summaries', headers: headers

      expect(response).to have_http_status(:internal_server_error)
      expect(response.content_type).to match(%r{application/json})
      json = JSON.parse(response.body)
      expect(json['error']).to eq('Internal server error')
      expect(response.body).not_to include('boom')
    end
  end
end
