# frozen_string_literal: true

class WalletsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_user

  def create
    pp 'STARTING TO CREATE WALLET'
    wallet = @user.wallets.create(wallet_params)
    if wallet.persisted?
      pp 'WALLET PERSISTED'
      render json: { message: 'Wallet connected successfully.' }, status: :created
    else
      pp 'ELSE'
      render json: { errors: wallet.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def set_user
    pp 'SETTING USER'
    @user = current_user
  end

  def wallet_params
    params.require(:wallet).permit(:address, :chain_id)
  end
end
