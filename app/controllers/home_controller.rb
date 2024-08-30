# frozen_string_literal: true

class HomeController < ApplicationController
  before_action :authenticate_user!

  def index
    fetch_and_prepare_github_data

    if @github_user_data
      @avatar = current_user.avatar_url
      respond_to do |format|
        format.html
        format.json { render_github_data_as_json }
      end
    else
      handle_github_data_failure
    end
  end

  private

  def fetch_and_prepare_github_data
    github_service = GithubApiService.new(current_user)
    @github_user_data = github_service.fetch_user_data

    return unless @github_user_data

    @avatar = @github_user_data['avatar_url']
  end

  def prepare_campaigns_mapping
    repo_identifiers = @repos.map do |repo|
      repo[:repo].full_name
    end
    pp "repo ident: #{repo_identifiers}"

    campaigns = Campaign.where(user: current_user, repo_identifier: repo_identifiers)
    @campaigns_by_repo_identifier = campaigns.index_by(&:repo_identifier)
    logger.debug "Campaigns by Repo Identifier: #{@campaigns_by_repo_identifier.inspect}"
  end

  def render_github_data_as_json
    render json: {
      user: @github_user_data,
      avatar: @avatar
    }
  end

  def handle_github_data_failure
    flash[:alert] = 'Failed to retrieve GitHub data. Please try again later.'
    redirect_to root_path
  end
end
