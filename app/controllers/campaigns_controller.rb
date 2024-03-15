# frozen_string_literal: true

class CampaignsController < ApplicationController
  before_action :authenticate_user!

  before_action :set_user, only: %i[new create]

  def new
    @campaign = @user.campaigns.build
  end

  def create
    @campaign = @user.campaigns.build(campaign_params)

    if @campaign.save
      redirect_to user_campaign_path(@user, @campaign), notice: 'Campaign was successfully created.'
    else
      render :new
    end
  end

  private

  def set_user
    @user = current_user
  end

  def campaign_params
    params.require(:campaign).permit(:title, :description, :amount, :contribution_cadence, :accepted_currency, :repo_identifier, :repo_url, :receiving_wallet_id)
  end
end
