# frozen_string_literal: true

class WalletsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_user

  # Captures wallet details post WalletConnect connection
  def create
    wallet = @user.wallets.create(wallet_params)
    if wallet.persisted?
      render json: { status: :ok, message: 'Wallet connected successfully.' }
    else
      render json: { status: :unprocessable_entity, errors: wallet.errors.full_messages }
    end
  end

  private

  def set_user
    @user = current_user
    # authorize! :update, @user # Example using CanCanCan for authorization? needed?
  end

  def wallet_params
    params.require(:wallet).permit(:address, :chain_id) # Include any other parameters you expect from WalletConnect
  end
end
