require 'rails_helper'

RSpec.describe 'V1::UserFtps', type: :request do
  let(:user) { User.create!(provider: 'google', uid: '12345') }
  let(:auth_token) { user.auth_tokens.create! }
  let(:headers) { { 'Authorization' => "Bearer #{auth_token.token}" } }

  describe 'GET /v1/user_ftps/current' do
    context 'when FTP exists' do
      let!(:ftp) { user.user_ftps.create!(ftp_value: 250) }

      it 'returns the current FTP' do
        get '/api/v1/user_ftps/current', headers: headers

        expect(response).to have_http_status(:ok)
        json = JSON.parse(response.body)
        expect(json['ftp_value']).to eq(250)
        expect(json['id']).to eq(ftp.id)
      end
    end

    context 'when FTP does not exist' do
      it 'returns 404' do
        get '/api/v1/user_ftps/current', headers: headers

        expect(response).to have_http_status(:not_found)
        json = JSON.parse(response.body)
        expect(json['error']).to eq('FTP not found')
      end
    end

    context 'when multiple FTPs exist' do
      let!(:old_ftp) { user.user_ftps.create!(ftp_value: 200, created_at: 2.days.ago) }
      let!(:new_ftp) { user.user_ftps.create!(ftp_value: 250, created_at: 1.day.ago) }

      it 'returns the most recent FTP' do
        get '/api/v1/user_ftps/current', headers: headers

        expect(response).to have_http_status(:ok)
        json = JSON.parse(response.body)
        expect(json['ftp_value']).to eq(250)
        expect(json['id']).to eq(new_ftp.id)
      end
    end

    context 'without authentication' do
      it 'returns 401' do
        get '/api/v1/user_ftps/current'

        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe 'POST /v1/user_ftps' do
    context 'with valid parameters' do
      it 'creates a new FTP' do
        expect {
          post '/api/v1/user_ftps', params: { ftp_value: 250 }, headers: headers
        }.to change { user.user_ftps.count }.by(1)

        expect(response).to have_http_status(:created)
        json = JSON.parse(response.body)
        expect(json['ftp_value']).to eq(250)
      end
    end

    context 'with invalid parameters' do
      it 'returns 400 for missing ftp_value' do
        post '/api/v1/user_ftps', params: {}, headers: headers

        expect(response).to have_http_status(:bad_request)
      end

      it 'returns 422 for non-positive ftp_value' do
        post '/api/v1/user_ftps', params: { ftp_value: 0 }, headers: headers

        expect(response).to have_http_status(:unprocessable_entity)
      end
    end

    context 'without authentication' do
      it 'returns 401' do
        post '/api/v1/user_ftps', params: { ftp_value: 250 }

        expect(response).to have_http_status(:unauthorized)
      end
    end
  end
end
