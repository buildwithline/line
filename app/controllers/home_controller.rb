# frozen_string_literal: true

class HomeController < ApplicationController
  before_action :authenticate_user!

  def index
    fetch_user_data_from_database
    prepare_campaigns_mapping

    if @github_user_data
      respond_to do |format|
        format.html
        format.json { render_github_data_as_json }
      end
    else
      handle_github_data_failure
    end
  end

  private

  def fetch_user_data_from_database
    @github_user_data = {
      'login' => current_user.nickname,
      'avatar_url' => current_user.avatar_url
    }
    @avatar = current_user.avatar_url
    @repositories = current_user.repositories.select(:id, :full_name, :name, :html_url, :description)
  end

  def prepare_campaigns_mapping
    repository_ids = @repositories.pluck(:id)

    campaigns = Campaign.where(repository_id: repository_ids)
    @campaigns_by_repository_id = campaigns.index_by(&:repository_id)
    logger.debug "Campaigns by Repo Identifier: #{@campaigns_by_repository_id.inspect}"
  end

  def render_github_data_as_json
    render json: {
      user: @github_user_data,
      avatar: @avatar,
      repositories: @repositories
    }
  end

  def handle_github_data_failure
    flash[:alert] = 'Failed to retrieve GitHub data. Please try again later.'
    redirect_to root_path
  end
end
