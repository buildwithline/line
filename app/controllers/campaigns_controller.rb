# frozen_string_literal: true

class CampaignsController < ApplicationController
  before_action :authenticate_user!, except: %i[index show]
  before_action :set_campaign, only: %i[show edit update destroy]
  before_action :set_user_for_modification, except: %i[index show]
  before_action :authorize_user!, only: %i[edit update destroy]
  before_action :check_campaign_existence, only: %i[new create]
  before_action :set_repository, only: %i[new create]

  def index
    @campaigns = Campaign.all
    @repo_name = params[:repo_name]
  end

  def show
    @accepted_currencies = if @campaign.accepted_currencies == 'all'
                             Campaign::ALL_CURRENCIES
                           else
                             @campaign.accepted_currencies.split(',')
                           end
  end

  def new
    @campaign = @user.campaigns.build
    @repo_name = params[:repo_name] || @campaign.repo_identifier
    @campaign.repo_identifier ||= @repo_name
    @wallet = find_wallet_for_repo_owner(@repository)
  end

  def create
    @campaign = build_campaign_from_params

    respond_to do |format|
      if @campaign.save
        format.html { redirect_to user_campaign_path(@user, @campaign), notice: 'Campaign was successfully created.' }
        format.json { render json: @campaign, status: :created }
      else
        log_errors(@campaign)
        format.html { render :new, alert: @campaign.errors.full_messages.join('. ') }
        format.json { render json: { errors: @campaign.errors.full_messages }, status: :unprocessable_entity }
      end
    end
  end

  def edit
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

  def set_user_for_modification
    @user = User.find_by(id: params[:user_id])

    return unless @user.nil? && %w[new create edit update destroy].include?(action_name)

    Rails.logger.error "User not found with id: #{params[:user_id]}"
    redirect_to root_path, alert: 'User not found.'
  end

  def set_campaign
    @campaign = Campaign.find_by(id: params[:id])
    if @campaign.nil?
      Rails.logger.error "Campaign not found with id: #{params[:id]}"
      redirect_to root_path, alert: 'Campaign not found.'
    else
      @user = @campaign.user
    end
  end

  def set_repository
    github_service = GithubService.new(current_user)
    @repositories = github_service.fetch_repositories
    @repository = @repositories.find { |repo| repo.id == params[:repository_id].to_i }
  end

  def authorize_user!
    return if @campaign.user == current_user

    redirect_to root_path, alert: 'You are not authorized to perform this action.'
  end

  def build_campaign_from_params
    campaign = @user.campaigns.build(campaign_params.except(:accepted_currencies))
    campaign.accepted_currencies = params[:campaign][:accepted_currencies].split(',')
    campaign.repo_identifier = params[:campaign][:repo_identifier]
    campaign.receiving_wallet = find_wallet_for_repo_owner(@repository)
    campaign
  end

  def log_errors(campaign)
    Rails.logger.debug campaign.errors.full_messages.to_sentence
  end

  def find_wallet_for_repo_owner(repository)
    owner = User.find_by(uid: repository.owner.id)
    owner&.wallets&.first
  end

  def check_campaign_existence
    repo_identifier = params[:campaign] ? params[:campaign][:repo_identifier] : params[:repo_identifier]
    return unless current_user.campaigns.exists?(repo_identifier:)

    redirect_to user_campaigns_path(current_user), alert: 'A campaign for this repository already exists.'
  end

  def campaign_params
    params.require(:campaign).permit(:title, :description, :tier_amount, :tier_name, :contribution_cadence, :repo_identifier, :receiving_wallet_id, accepted_currencies: [])
  end
end
