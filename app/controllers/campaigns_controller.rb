# frozen_string_literal: true

class CampaignsController < ApplicationController
  before_action :authenticate_user!, except: %i[index show]
  before_action :set_repository, only: %i[new create update edit show]
  before_action :set_campaign, only: %i[edit update]

  def show
    @campaign = Campaign.find(params[:id])
    @accepted_currencies = if @campaign.accepted_currencies == 'all'
                             Campaign::ALL_CURRENCIES
                           else
                             @campaign.accepted_currencies.split(',')
                           end
  end

  def new
    @campaign = @repository.build_campaign
  end

  def create
    params[:campaign][:accepted_currencies] = params[:campaign][:accepted_currencies].split(",") if params[:campaign][:accepted_currencies].is_a?(String)
    @campaign = @repository.build_campaign(campaign_params)
    @campaign.receiving_wallet = current_user.wallet

    Rails.logger.debug "Creating campaign for repository: #{@repository.inspect}"
    Rails.logger.debug "Campaign attributes before save: #{@campaign.inspect}"


    if @campaign.save
      redirect_to user_repository_campaign_path(current_user, @repository, @campaign), notice: 'Campaign was successfully created.'
    else
      log_errors(@campaign)
      flash.now[:alert] = @campaign.errors.full_messages.join('. ')
      Rails.logger.debug "Campaign save failed. Errors: #{@campaign.errors.full_messages}"
      render :new
    end
  end

  def edit
    @repo_name = @campaign.repository
  end

  def update
    if @campaign.update(campaign_params)
      redirect_to user_campaign_path(@repository.user, @campaign), notice: 'Campaign was successfully updated.'
    else
      render :edit
    end
  end

  private

  def set_campaign
    @campaign = current_user.campaigns.find(params[:id])
    pp @campaign
  end

  def set_repository
    @repository = 
      if action_name == 'new' || action_name == 'create' || !@campaign
        current_user.repositories.find(params[:repository_id])
      else
        @campaign.repository
      end
      pp @repository

      Rails.logger.debug "Repository set in #{action_name} action: #{@repository.inspect}"
  end

  def log_errors(campaign)
    Rails.logger.debug campaign.errors.full_messages.to_sentence
  end

  def campaign_params
    params.require(:campaign).permit(:title, :description, :tier_amount, :tier_name, :contribution_cadence, :repository_id, :receiving_wallet_id, accepted_currencies: [])
  end
end
