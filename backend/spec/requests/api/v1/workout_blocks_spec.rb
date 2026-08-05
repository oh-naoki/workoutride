require 'rails_helper'

RSpec.describe 'API::V1::WorkoutBlocks', type: :request do
  let(:user) { User.create!(provider: 'google', uid: '12345') }
  let(:auth_token) { user.auth_tokens.create! }
  let(:headers) { { 'Authorization' => "Bearer #{auth_token.token}" } }

  describe 'GET /api/v1/workout_blocks/:id' do
    let(:workout_summary) { create(:workout_summary) }

    context 'when workout blocks exist for the summary' do
      let!(:workout_blocks) do
        [
          create(:workout_block, workout_summary: workout_summary, order_index: 0),
          create(:workout_block, workout_summary: workout_summary, order_index: 1),
          create(:workout_block, workout_summary: workout_summary, order_index: 2)
        ]
      end

      before { get "/api/v1/workout_blocks/#{workout_summary.id}", headers: headers }

      it 'returns HTTP status 200' do
        expect(response).to have_http_status(:ok)
      end

      it 'returns all workout blocks for the summary' do
        expect(JSON.parse(response.body).size).to eq(3)
      end

      it 'returns workout blocks in order_index order' do
        json_response = JSON.parse(response.body)

        expect(json_response[0]['order_index']).to eq(0)
        expect(json_response[1]['order_index']).to eq(1)
        expect(json_response[2]['order_index']).to eq(2)
      end

      it 'returns workout blocks with correct attributes' do
        json_response = JSON.parse(response.body)
        first_block = json_response.first

        expect(first_block).to have_key('id')
        expect(first_block).to have_key('workout_summary_id')
        expect(first_block).to have_key('order_index')
        expect(first_block).to have_key('target_ftp_percentage')
        expect(first_block).to have_key('duration')
        expect(first_block).to have_key('block_type')
        expect(first_block).to have_key('created_at')
        expect(first_block).to have_key('updated_at')
      end

      it 'returns blocks with correct workout_summary_id' do
        json_response = JSON.parse(response.body)

        json_response.each do |block|
          expect(block['workout_summary_id']).to eq(workout_summary.id)
        end
      end

      it 'exposes block_type as the block_category name' do
        json_response = JSON.parse(response.body)

        expect(json_response[0]['block_type']).to eq(workout_blocks[0].block_category.name)
      end
    end

    context 'when no workout blocks exist for the summary' do
      before { get "/api/v1/workout_blocks/#{workout_summary.id}", headers: headers }

      it 'returns HTTP status 200' do
        expect(response).to have_http_status(:ok)
      end

      it 'returns an empty array' do
        expect(JSON.parse(response.body)).to eq([])
      end
    end

    context 'when workout summary does not exist' do
      before { get '/api/v1/workout_blocks/99999', headers: headers }

      it 'returns HTTP status 200' do
        expect(response).to have_http_status(:ok)
      end

      it 'returns an empty array' do
        expect(JSON.parse(response.body)).to eq([])
      end
    end

    context 'when other workout summaries have blocks' do
      let(:other_summary) { create(:workout_summary) }
      let!(:other_blocks) do
        create_list(:workout_block, 2, workout_summary: other_summary)
      end
      let!(:target_blocks) do
        create_list(:workout_block, 3, workout_summary: workout_summary)
      end

      before { get "/api/v1/workout_blocks/#{workout_summary.id}", headers: headers }

      it 'only returns blocks for the specified summary' do
        json_response = JSON.parse(response.body)

        expect(json_response.size).to eq(3)
        json_response.each do |block|
          expect(block['workout_summary_id']).to eq(workout_summary.id)
        end
      end
    end

    context 'without authentication' do
      it 'returns 401' do
        get "/api/v1/workout_blocks/#{workout_summary.id}"
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end
end
