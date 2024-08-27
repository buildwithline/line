# frozen_string_literal: true

class SyncReposJob < ApplicationJob
  sidekiq_options retry: 5
  queue_as :default

  def perform(user_id)
    @user = User.find(user_id)
    return unless @user

    fetch_repositories(@user)
    sync_user_repositories
  end

  private

  def fetch_repositories(user)
    github_data = GithubApiHelper.fetch_github_data(user)

    return unless github_data && github_data[:repos].present?

    @repo_attribute_list = github_data[:repos].map do |repo_data|
      {
        user:,
        full_name: repo_data[:repo][:full_name],
        name: repo_data[:repo][:name],
        html_url: repo_data[:repo][:html_url],
        description: repo_data[:repo][:description],
        private: repo_data[:repo][:private],
        fork: repo_data[:repo][:fork],
        created_on_github_at: repo_data[:repo][:created_at],
        updated_on_github_at: repo_data[:repo][:updated_at],
        pushed_to_github_at: repo_data[:repo][:pushed_at]
      }
    end
  end

  def sync_user_repositories
    return unless @repo_attribute_list

    @repo_attribute_list.each do |repo_attributes|
      next unless repo_attributes

      repo = Repository.find_or_initialize_by(full_name: repo_attributes[:full_name])
      if repo.update(repo_attributes)
        Rails.logger.info("Successfully updated repository #{repo_attributes[:full_name]}")
      else
        Rails.logger.error("Failed to update repository #{repo_attributes[:full_name]}: #{repo.errors.full_messages.join(', ')}")
      end
    end
    @repo_attribute_list = nil
  end
end
