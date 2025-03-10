# frozen_string_literal: true

class CampaignsController < ApplicationController
  before_action :authenticate_user!, only: %i[new create edit update]
  before_action :set_repository, only: %i[new create edit update]
  before_action :check_repository_ownership!, only: %i[new create edit]
  before_action :set_campaign, only: %i[edit update]

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

    process_accepted_currencies(@campaign)

    if @campaign.save
      redirect_to user_repository_campaign_path(current_user, @repository, @campaign), notice: 'Campaign was successfully created.'
    else
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
    process_accepted_currencies(@campaign)

    if @campaign.update(campaign_params)
      redirect_to user_repository_campaign_path(@repository.user, @repository, @campaign), notice: 'Campaign updated successfully!'
    else
      flash.now[:alert] = @campaign.errors.full_messages.join('. ')
      render :edit
    end
  end

  private

  def set_campaign
    @campaign = current_user.campaigns.find(params[:id])
  end

  def set_repository
    if action_name == 'new' || action_name == 'create'
      @repository = current_user.repositories.find_by(id: params[:repository_id])

      if @repository.nil?
        redirect_to root_path, alert: 'Repository not found or does not belong to you.'
        return
      end
    else
      @campaign = Campaign.find_by(id: params[:id])
      if @campaign.nil?
        redirect_to root_path, alert: "Campaign not found with id: #{params[:id]}."
        return
      end
      @repository = @campaign.repository
    end

    Rails.logger.debug "Repository set in #{action_name} action: #{@repository.inspect}"
  end

  def find_wallet_for_repo_owner(repository)
    owner = User.find_by(uid: repository.owner_login)
    owner&.wallet
  end

  def check_repository_ownership!
    Rails.logger.debug "Current user: #{current_user.inspect}"
    Rails.logger.debug "Repository user: #{@repository.user.inspect}"
    return if current_user == @repository.user

    flash[:alert] = 'You are not authorized to create a campaign for this repository'
    redirect_to root_path
  end

  def process_accepted_currencies(campaign)
    currencies_param = params[:campaign][:accepted_currencies]

    return unless currencies_param.is_a?(String)

    logger.debug "Accepted currencies before processing: #{currencies_param}"

    processed_currencies = currencies_param.gsub(/[{}"]/, '').split(',').map(&:strip).reject(&:empty?)

    logger.debug "Accepted currencies after processing: #{processed_currencies}"

    campaign.accepted_currencies = processed_currencies
  end

  def log_errors(campaign)
    Rails.logger.debug campaign.errors.full_messages.to_sentence
  end

  def campaign_params
    params.require(:campaign).permit(:repository_id, :receiving_wallet_id, :title, :description).tap do |whitelisted|
      whitelisted[:accepted_currencies] = params[:campaign][:accepted_currencies].is_a?(String) ? params[:campaign][:accepted_currencies].split(',') : params[:campaign][:accepted_currencies]
    end
  end
end
