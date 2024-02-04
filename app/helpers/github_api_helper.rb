# frozen_string_literal: true

require 'octokit'

module GithubApiHelper
  class << self
    attr_accessor :organizations, :repos, :organization_memberships, :user_avatar

    def fetch_github_data(user)
      return unless user

      client = initialize_client(user)

      # Fetch user information and repositories
      user_info = fetch_user_info(client)
      personal_repos = fetch_personal_repos(client, user_info.login)
      organizations = fetch_organizations(client, user_info.login)

      # Fetch organization repositories
      org_repos = fetch_organization_repos(client, organizations)

      # Combine personal and organization repositories
      self.repos = personal_repos + org_repos

      # Assign fetched data to accessors
      assign_fetched_data(user_info, organizations)

      # Return the fetched data
      fetched_data
    rescue Octokit::Unauthorized => e
      handle_error('Unauthorized', e.message)
    rescue Octokit::NotFound => e
      handle_error('User not found', e.message)
    rescue Octokit::Error => e
      handle_error(e.class, e.message)
    end

    private

    def initialize_client(user)
      Octokit::Client.new(access_token: user.github_access_token, scope: 'read:org')
    end

    def fetch_user_info(client)
      client.user
    end

    def fetch_personal_repos(client, login)
      client.repositories(login).map do |repo|
        repo_details = client.repository(repo.full_name)
        { repo: repo_details, org_avatar_url: repo_details.organization&.avatar_url }
      end
    end

    def fetch_organizations(client, login)
      client.organizations(login)
    end

    def fetch_organization_repos(client, organizations)
      organizations.flat_map do |org|
        client.organization_repositories(org.login).map do |repo|
          repo_details = client.repository(repo.full_name)
          { repo: repo_details, org_avatar_url: repo_details.organization&.avatar_url }
        end
      end
    end

    def assign_fetched_data(user_info, organizations)
      @organizations = organizations
      @organizations_names = organizations.map(&:login)
      @user_avatar = "https://github.com/users/#{user_info.login}.png"
    end

    def fetched_data
      {
        user_info: @user_info,
        organizations: @organizations,
        repos: @repos,
        organization_memberships: @organization_memberships,
        user_avatar: @user_avatar
      }
    end

    def handle_error(type, message)
      puts "Error: #{type} - #{message}"
      nil
    end
  end

  def self.user_repo_permission(repo)
    return 'admin' if repo[:permissions][:admin]
    return 'maintainer' if repo[:permissions][:maintain]

    'member' # default to 'member' if neither 'admin' nor 'maintain' permissions are true
  end
end
