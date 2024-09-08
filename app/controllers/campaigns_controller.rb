# frozen_string_literal: true

class CampaignsController < ApplicationController
  before_action :authenticate_user!, except: %i[index show edit]
  before_action :set_campaign, only: %i[show edit update destroy]
  before_action :authorize_user!, only: %i[edit update destroy]
  before_action :set_repository, only: %i[new create show edit]
  before_action :check_repository_ownership!, only: %i[new create edit]

  def index
    # Question: Should this display ALL campaigns regardness of user or just the current_user's campaigns?
    @repositories = current_user.repositories
    @repository_ids = @repositories.pluck(:id)
    @campaigns = Campaign.where(repository_id: @repository_ids)
  end

  def show
    @accepted_currencies = if @campaign.accepted_currencies == 'all'
                             Campaign::ALL_CURRENCIES
                           else
                             @campaign.accepted_currencies.split(',')
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
        format.html { render :new, alert: @campaign.errors.full_messages.join('. ') }
        format.json { render json: { errors: @campaign.errors.full_messages }, status: :unprocessable_entity }
      end
    end
  end

  def edit; end

  def update
    if @campaign.update(campaign_params)
      redirect_to user_repository_campaign_path(@repository.user, @repository, @campaign), notice: 'Campaign was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @campaign.destroy
    redirect_to campaigns_url, notice: 'Campaign was successfully destroyed.'
  end

  private

  def set_campaign
    @campaign = Campaign.find_by(id: params[:id])
    if @campaign.nil?
      Rails.logger.error "Campaign not found with id: #{params[:id]}"
      redirect_to root_path, alert: 'Campaign not found.'
    else
      @repository = @campaign.repository
    end
  end

  def set_repository
    @repository = Repository.find(params[:repository_id])
  end

  def authorize_user!
    return if @campaign.repository.user == current_user

    Rails.logger.error "Unauthorized attempt by #{current_user.email} to modify campaign"
    redirect_to root_path, alert: 'You are not authorized to perform this action.'
  end

  def check_repository_ownership!
    @repository = current_user.repositories.find_by(id: params[:repository_id])
    return if @repository.present? && @repository.user == current_user

    redirect_to root_path, flash[:alert] = 'You are not authorized to create a campaign for this repository'
  end

  def log_errors(campaign)
    Rails.logger.debug campaign.errors.full_messages.to_sentence
  end

  def find_wallet_for_repo_owner(repository)
    owner = User.find_by(uid: repository.owner_login)
    owner&.wallet
  end

  def campaign_params
    params.require(:campaign).permit(:title, :description, :repository_id, :receiving_wallet_id, :contribution_cadence).tap do |whitelisted|
      whitelisted[:accepted_currencies] = params[:campaign][:accepted_currencies].split(',') if params[:campaign][:accepted_currencies].present?
    end
  end
end
