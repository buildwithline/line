# frozen_string_literal: true

class WalletsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_user

  def create
    if @user.wallet.present?
      render json: { error: 'User already has a wallet connected.' }, status: :unprocessable_entity
      return
    end

    wallet = @user.create_wallet(wallet_params)

    if wallet.persisted?
      render json: { message: 'Wallet connected successfully.' }, status: :created
    else
      render json: { errors: wallet.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    if @user.wallet&.destroy
      render json: { message: 'Wallet disconnected successfully.' }, status: :ok
    else
      render json: { error: 'Wallet not found or could not be disconnected.' }, status: :not_found
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
