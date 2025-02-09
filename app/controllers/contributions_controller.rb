# frozen_string_literal: true

class ContributionsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_receiving_wallet, only: %i[new create]

  def new
    pp 'new action'
    @campaign = Campaign.find(params[:campaign_id])
    pp '++++++++++++++++++++'
    pp @campaign
    pp '++++++++++++++++++++'
    @contribution = Contribution.new
    @accepted_currencies = @campaign.accepted_currencies.split(',')
  end

  def create
    pp 'create contrib'
  end

  private

  def set_receiving_wallet
    @campaign = Campaign.find(params[:campaign_id])
    pp @campaign

    @receiving_wallet = Wallet.find_by(id: @campaign.receiving_wallet_id)
    pp @receiving_wallet
    @receiving_wallet_address = @receiving_wallet&.address
  end

  def set_user
    pp 'set user in contrib'
    @user = current_user
    pp @user.wallet.address
  end

  def contributions_params
    params.require(:contribution).permit(:contribution_cadence, :repo_identifier, :receiving_wallet_id, accepted_currencies: [])
  end
end
