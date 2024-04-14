# frozen_string_literal: true

class ContributionsController < ApplicationController
  before_action :authenticate_user!

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

  def set_user
    pp 'set user in contrib'
    @user = current_user
  end

  def contributions_params
    params.require(:contribution).permit(:contribution_cadence, :accepted_currencies, :repo_identifier, :receiving_wallet_id)
  end
end
