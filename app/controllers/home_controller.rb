class HomeController < ApplicationController
  include GithubApiHelper

  def index
    @user = current_user
    @github_user_data = GithubApiHelper.fetch_github_data(@user)
    @organizations = GithubApiHelper.organizations
    @repos = GithubApiHelper.repos
    @organization_memberships = GithubApiHelper.organization_memberships

    @avatar = current_user.avatar_url

    respond_to do |format|
      format.html
      format.json { render json: { user: @github_user_data, organizations: @organizations, repos: @repos, organization_memberships: @organization_memberships } }
    end
  end
end
