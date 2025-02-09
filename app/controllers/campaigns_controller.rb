# frozen_string_literal: true

class CampaignsController < ApplicationController
  before_action :set_repository, only: %i[new create edit]
  before_action :check_repository_ownership!, only: %i[new create edit]
  before_action :set_campaign, only: %i[edit update destroy]

  def show
    @campaign = Campaign.find(params[:id])
    @repository = @campaign.repository
    @accepted_currencies = if @campaign.accepted_currencies == 'all'
                             Campaign::ALL_CURRENCIES
                           else
                             @campaign.accepted_currencies
                           end
  end

  def new
    @campaign = @repository.build_campaign
    @wallet = find_wallet_for_repo_owner(@repository)
  end

  def create
    @campaign = @repository.build_campaign(campaign_params)
    @campaign.receiving_wallet = current_user.wallet

    respond_to do |format|
      if @campaign.save
        format.html { redirect_to user_repository_campaign_path(@repository.user, @repository, @campaign), notice: 'Campaign was successfully created.' }
        format.json { render json: @campaign, status: :created }
      else
        log_errors(@campaign)
        Rails.logger.error(@campaign.errors.full_messages.to_sentence)
        format.html { render :new, alert: @campaign.errors.full_messages.join('. ') }
        format.json { render json: { errors: @campaign.errors.full_messages }, status: :unprocessable_entity }
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
  end

  def set_repository
    @repository = 
      if action_name == 'new' || action_name == 'create' || !@campaign
        current_user.repositories.find(params[:repository_id])
      else
        @campaign.repository
      end

      Rails.logger.debug "Repository set in #{action_name} action: #{@repository.inspect}"
    @campaign = Campaign.find_by(id: params[:id])
    redirect_to root_path, alert: "Campaign not found with id: #{params[:id]}." unless @campaign
  end

  # def set_repository
  #   @repository = Repository.find(params[:repository_id])
  #   redirect_to root_path, alert: 'Repository not found.' unless @repository
  # end

  def check_repository_ownership!
    return if current_user == @repository.user

    flash[:alert] = 'You are not authorized to create a campaign for this repository'
    redirect_to root_path
  end

  def log_errors(campaign)
    Rails.logger.debug campaign.errors.full_messages.to_sentence
  end

  def campaign_params
    params.require(:campaign).permit(:title, :description, :tier_amount, :tier_name, :contribution_cadence, :repository_id, :receiving_wallet_id, accepted_currencies: [])
  end
end
