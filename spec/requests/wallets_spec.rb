# frozen_string_literal: true

# require 'rails_helper'

# RSpec.describe 'Wallets', type: :request do
#   describe 'POST /users/:user_id/wallet' do
#     let(:user) { create(:user) }
#     let(:wallet_address) { Faker::Blockchain::Ethereum.address }
#     let(:chain_id) { Faker::Number.between(from: 1, to: 100) }

#     before do
#       sign_in user
#       # Mocking external WalletConnect call to simulate the wallet connection response
#       allow_any_instance_of(WalletConnectService)
#         .to receive(:connect)
#         .and_return({
#                       address: wallet_address,
#                       chain_id:
#                     })
#     end

#     it 'creates a wallet for the user' do
#       expect do
#         post user_wallets_path(user_id: user.id), params: { wallet: { address: wallet_address, chain_id: } }, as: :json
#       end.to change(user.wallets, :count).by(1)

#       expect(response).to have_http_status(:created)
#       wallet = Wallet.last
#       expect(wallet.user).to eq(user)
#       expect(wallet.address).to eq(wallet_address)
#       expect(wallet.chain_id).to eq(chain_id)
#     end
#   end
# end
