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

    set_repo_permissions
  end

  def set_repo_permissions
    @repos.each do |repo|
      repo[:user_permission] = GithubApiHelper.user_repo_permission(repo[:repo])
    end
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
