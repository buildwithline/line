class HomeController < ApplicationController
  include GithubApiHelper

  before_action :authenticate_user!

  def index
    if user_signed_in?
      @user = current_user
      @github_user_data = GithubApiHelper.fetch_github_data(@user)

      if @github_user_data
        @organizations = @github_user_data[:organizations]
        @repos = @github_user_data[:repos]
        @organization_memberships = @github_user_data[:organization_memberships]
        @avatar = current_user.avatar_url
        @repos.each do |repo|
          repo[:user_permission] = GithubApiHelper.user_repo_permission(repo[:repo])
        end

        respond_to do |format|
          format.html
          format.json { render json: { user: @github_user_data, organizations: @organizations, repos: @repos, organization_memberships: @organization_memberships } }
        end
      else
        # Handle the case when GitHub data retrieval fails
        flash[:alert] = 'Failed to retrieve GitHub data. Please try again later.'
        redirect_to root_path
      end
    else
      # Handle the case when there's no signed-in user
      redirect_to new_user_session_path
    end
  end
end