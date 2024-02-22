class WalletsController < ApplicationController
  before_action :authenticate_user! # Assuming authentication is required

  def index
    @wallets = current_user.wallets
  end

  def new
    @wallet = current_user.wallets.build
  end

  def create
    @wallet = current_user.wallets.build(wallet_params)
    if @wallet.save
      redirect_to wallets_path, notice: 'Wallet created successfully.'
    else
      render :new
    end
  end

  private

  def wallet_params
    params.require(:wallet).permit(:address)
  end
end
