class HomeController < ApplicationController
  include GithubApiHelper

  def index
    @user = current_user
    @github_user_data = GithubApiHelper.fetch_github_data(@user.nickname)
    @organizations = GithubApiHelper.organizations
    
    respond_to do |format|
      format.html
      format.json { render json: { user: @github_user_data, organizations: @organizations } }
    end
  end
end
