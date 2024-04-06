# frozen_string_literal: true

class CampaignsController < ApplicationController
  before_action :authenticate_user!
  before_action :check_campaign_existence, only: %i[new create]

  before_action :set_campaign, only: %i[show edit update destroy]
  before_action :set_user, only: %i[new create update show]

  def index
    @campaigns = Campaign.all
    @repo_name = params[:repo_name]
  end

  def show
    @campaign = Campaign.find(params[:id])
  end

  def new
    @campaign = @user.campaigns.build
    @repo_name = params[:repo_name] || @campaign.repo_identifier
  end

  def create
    @campaign = @user.campaigns.build(campaign_params)
    @repo_name = params[:campaign][:repo_identifier]
    if params[:campaign][:wallet_address].present? && !current_user.wallet.present?
      wallet = current_user.build_wallet(address: params[:campaign][:wallet_address])
      wallet.save
      @campaign.receiving_wallet_id = wallet.id
    elsif current_user.wallet.present?
      @campaign.receiving_wallet_id = current_user.wallet.id
    end

    respond_to do |format|
      if @campaign.save
        format.html { redirect_to user_campaign_path(@user, @campaign), notice: 'Campaign was successfully created.' }
      else
        Rails.logger.debug "Errors: #{@campaign.errors.inspect}"
        format.html { redirect_to new_user_campaign_path(@user), alert: @campaign.errors.full_messages.join('. ') }
      end
    end
  end

  def edit
    @campaign = Campaign.find(params[:id])
    @repo_name = @campaign.repo_identifier
  end

  def update
    if @campaign.update(campaign_params)
      redirect_to user_campaign_path(@user, @campaign), notice: 'Campaign was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @campaign.destroy
    redirect_to campaigns_url, notice: 'Campaign was successfully destroyed.'
  end

  private

  def set_user
    @user = current_user
  end

  def set_campaign
    @campaign = current_user.campaigns.find(params[:id])
  end

  def check_campaign_existence
    repo_identifier = params[:campaign] ? params[:campaign][:repo_identifier] : params[:repo_identifier]
    return unless current_user.campaigns.exists?(repo_identifier:)

    redirect_to user_campaigns_path(current_user), alert: 'A campaign for this repository already exists.'
  end

  def campaign_params
    params.require(:campaign).permit(:title, :description, :tier_amount, :tier_name, :contribution_cadence, :accepted_currency, :repo_identifier, :receiving_wallet_id)
  end
end
