# frozen_string_literal: true

class WalletsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_user

  def create
    wallet = @user.wallets.create(wallet_params)
    if wallet.persisted?
      render json: { message: 'Wallet connected successfully.' }, status: :created
    else
      render json: { errors: wallet.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def set_user
    @user = current_user
  end

  def wallet_params
    params.require(:wallet).permit(:address) # add, :chain_id later?
  end
end
