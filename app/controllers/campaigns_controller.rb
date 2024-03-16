# frozen_string_literal: true

class CampaignsController < ApplicationController
  before_action :authenticate_user!

  # before_action :set_campaign, only: %i[show edit update destroy]
  before_action :set_user, only: %i[new create]

  # def index
  #   @campaigns = Campaign.all
  # end

  # def show; end

  def new
    @campaign = @user.campaigns.build
    @repo_name = params[:repo_name]
  end

  def create
    @campaign = @user.campaigns.build(campaign_params)
    @repo_name = params[:campaign][:repo_identifier]

    respond_to do |format|
      if @campaign.save
        format.html { redirect_to user_campaign_path(@user, @campaign), notice: 'Campaign was successfully created.' }
      else
        format.turbo_stream do
          render turbo_stream: turbo_stream.replace('campaign_form', partial: 'campaigns/form', locals: { campaign: @campaign })
        end
        format.html { redirect_to new_user_campaign_path(@user), alert: 'There were errors with your submission.' }
      end
    end
  end

  def edit
    @campaign = Campaign.find(params[:id])
    @repo_name = @campaign.repo_identifier
  end

  # def update
  #   if @campaign.update(campaign_params)
  #     redirect_to @campaign, notice: 'Campaign was successfully updated.'
  #   else
  #     render :edit
  #   end
  # end

  # def destroy
  #   @campaign.destroy
  #   redirect_to campaigns_url, notice: 'Campaign was successfully destroyed.'
  # end

  private

  def set_user
    @user = current_user
  end

  def set_campaign
    @campaign = @user.campaigns.find(params[:id])
  end

  def campaign_params
    params.require(:campaign).permit(:title, :description, :tier, :amount, :contribution_cadence, :accepted_currency, :repo_identifier, :repo_url, :receiving_wallet_id)
  end
end
