# frozen_string_literal: true

class HomeController < ApplicationController
  before_action :authenticate_user!

  def index
    fetch_and_prepare_github_data

    respond_to do |format|
      if @github_user_data
        format.html # default view
        format.json { render_github_data_as_json }
      else
        handle_github_data_failure
      end
    end
  end

  private

  def fetch_and_prepare_github_data
    @github_user_data = GithubApiHelper.fetch_github_data(current_user)
    return unless @github_user_data

    @organizations = @github_user_data[:organizations]
    @repos = @github_user_data[:repos]
    @organization_memberships = @github_user_data[:organization_memberships]
    @avatar = current_user.avatar_url

    prepare_campaigns_mapping
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
      organizations: @organizations,
      repos: @repos,
      organization_memberships: @organization_memberships
    }
  end

  def handle_github_data_failure
    flash[:alert] = 'Failed to retrieve GitHub data. Please try again later.'
    redirect_to root_path
  end
end
