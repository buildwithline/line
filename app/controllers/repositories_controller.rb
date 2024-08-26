# frozen_string_literal: true

class RepositoriesController < ApplicationController
  before_action :authenticate_user!

  def sync
    github_data = GithubApiHelper.fetch_github_data(current_user)

    return unless github_data && github_data[:repos].present?

    github_data[:repos].each do |repo_data|
      repo = Repository.find_or_initialize_by(full_name: repo_data[:repo][:full_name])
      repo.update!(
        user: current_user,
        full_name: repo_data[:repo][:full_name],
        name: repo_data[:repo][:name],
        html_url: repo_data[:repo][:html_url],
        description: repo_data[:repo][:description],
        private: repo_data[:repo][:private],
        fork: repo_data[:repo][:fork],
        created_on_github_at: repo_data[:repo][:created_at],
        updated_on_github_at: repo_data[:repo][:updated_at],
        pushed_to_github_at: repo_data[:repo][:pushed_at]
      )
    end
  end
end
