# frozen_string_literal: true

require 'rails_helper'

RSpec.describe WalletsController, type: :controller do
  include Devise::Test::ControllerHelpers

  let(:user) { create(:user) }
  let(:wallet_address) { Faker::Blockchain::Ethereum.address }

  before do
    sign_in user
  end

  describe 'POST #create' do
    context 'when user does not have a wallet' do
      it 'creates a wallet for the user' do
        expect do
          post :create, params: { user_id: user.id, wallet: { address: wallet_address } }, as: :json
        end.to change(Wallet, :count).by(1)

        expect(response).to have_http_status(:created)
        wallet = Wallet.last
        expect(wallet.user).to eq(user)
        expect(wallet.address).to eq(wallet_address)
      end
    end

    context 'when user already has a wallet' do
      let!(:existing_wallet) { create(:wallet, user:) }

      it 'does not create a new wallet and returns an error' do
        expect do
          post :create, params: { user_id: user.id, wallet: { address: wallet_address } }, as: :json
        end.not_to change(Wallet, :count)

        expect(response).to have_http_status(:unprocessable_entity)
        expect(JSON.parse(response.body)['error']).to eq('User already has a wallet connected.')
      end
    end
  end

  describe 'DELETE #destroy' do
    let!(:wallet) { create(:wallet, user:) }

    it 'deletes the wallet' do
      expect do
        delete :destroy, params: { user_id: user.id, id: wallet.id }
      end.to change(Wallet, :count).by(-1)

      expect(response).to have_http_status(:ok)
    end
  end
end
