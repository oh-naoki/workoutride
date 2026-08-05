require 'rails_helper'

RSpec.describe GoogleAuthService do
  describe '#verify_and_authenticate' do
    let(:id_token) { 'dummy-id-token' }
    let(:payload) { { 'sub' => 'google-sub-123' } }

    context 'when the ID token is valid' do
      before do
        allow(Google::Auth::IDTokens).to receive(:verify_oidc).and_return(payload)
      end

      context 'and the user does not exist yet' do
        it 'creates a new user from the token payload' do
          expect {
            described_class.new(id_token).verify_and_authenticate
          }.to change(User, :count).by(1)

          user = User.find_by(provider: 'google', uid: 'google-sub-123')
          expect(user).to be_present
        end
      end

      context 'and the user already exists' do
        let!(:existing_user) { User.create!(provider: 'google', uid: 'google-sub-123') }

        it 'returns the existing user without creating a duplicate' do
          expect {
            described_class.new(id_token).verify_and_authenticate
          }.not_to change(User, :count)

          expect(described_class.new(id_token).verify_and_authenticate).to eq(existing_user)
        end
      end
    end

    context 'when the ID token is invalid' do
      before do
        allow(Google::Auth::IDTokens).to receive(:verify_oidc)
          .and_raise(Google::Auth::IDTokens::VerificationError, 'bad token')
      end

      it 'raises a Grape validation error without leaking the underlying error' do
        expect {
          described_class.new(id_token).verify_and_authenticate
        }.to raise_error(Grape::Exceptions::Validation)
      end

      it 'does not create a user' do
        expect {
          begin
            described_class.new(id_token).verify_and_authenticate
          rescue Grape::Exceptions::Validation
            nil
          end
        }.not_to change(User, :count)
      end
    end
  end
end
