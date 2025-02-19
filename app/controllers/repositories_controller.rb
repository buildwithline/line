# frozen_string_literal: true

class RepositoriesController < ApplicationController
  before_action :authenticate_user!

  def index
    @repositories = current_user.repositories.includes(:campaigns)
    pp @repositories
    pp @repositories.first.campaign
    # prepare_campaigns_mapping
  end

  private

  def prepare_campaigns_mapping
    repository_ids = @repositories.pluck(:id)

    campaigns = Campaign.where(repository_id: repository_ids)
    @campaigns_by_repository_id = campaigns.index_by(&:repository_id)
    logger.debug "Campaigns by Repo Identifier: #{@campaigns_by_repository_id.inspect}"

    @respositories_with_campaigns = @repositories.map do |repository|
      { repository: repository, campaign: @campaigns_by_repository_id[repository.id] }
    end
  end
end
