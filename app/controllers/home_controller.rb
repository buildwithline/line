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

        # Prepare admin flags for each repo
        prepare_admin_flags

        respond_to do |format|
          format.html
          format.json { render json: { user: @github_user_data, organizations: @organizations, repos: @repos, organization_memberships: @organization_memberships } }
        end

        # render_repo_admin_status(@user, @repos)
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

  private

  def prepare_admin_flags
    @repos.each do |repo_data|
      repo_data[:admin] = GithubApiHelper.repo_admin?(repo_data[:repo])
    end
  end
end