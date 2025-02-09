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
                             @campaign.accepted_currencies
                           end
  end

  def new
    @campaign = @repository.build_campaign
  end

  def create
    # Check if accepted_currencies is a string
    if params[:campaign][:accepted_currencies].is_a?(String)
      parsed = nil
      begin
        # Try to parse it as JSON
        parsed = JSON.parse(params[:campaign][:accepted_currencies])
      rescue JSON::ParserError
        # If it’s not valid JSON, treat it as a plain CSV string
      end
  
      # If it was parsed into an array, use it
      if parsed.is_a?(Array)
        params[:campaign][:accepted_currencies] = parsed
      else
        # If it's just a comma-separated string, split it into an array
        params[:campaign][:accepted_currencies] = params[:campaign][:accepted_currencies].split(",")
      end
    end
  
    @campaign = @repository.build_campaign(campaign_params)
    @campaign.receiving_wallet = current_user.wallet
  
    Rails.logger.debug "Creating campaign for repository: #{@repository.inspect}"
    Rails.logger.debug "Campaign attributes before save: #{@campaign.inspect}"
  
    puts "Currencies before save: #{params[:campaign][:accepted_currencies]}"
    
    if @campaign.save
      puts "Currencies after save: #{params[:campaign][:accepted_currencies]}"
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
    @accepted_currencies = @campaign.accepted_currencies
  end

  def update
    params[:campaign][:accepted_currencies] = [params[:campaign][:accepted_currencies]] if params[:campaign][:accepted_currencies].is_a?(String)

    existing_currencies = @campaign.accepted_currencies || []
    params[:campaign][:accepted_currencies].each do |currency|
      existing_currencies << currency unless existing_currencies.include?(currency)
    end

    @campaign.accepted_currencies = existing_currencies

    if @campaign.update(campaign_params)
      redirect_to user_repository_campaign_path(@repository.user, @repository, @campaign), notice: 'Campaign updated successfully!'
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
