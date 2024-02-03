module GithubApiHelper
  require 'octokit'

  class << self
    attr_accessor :organizations, :repos, :organization_memberships, :user_avatar

    def fetch_github_data(user)
      return unless user

      # Instantiate Octokit client with the user's GitHub access token
      client = Octokit::Client.new(access_token: user.github_access_token, scope: "read:org")

      # Fetch user information
      user_info = client.user

      # Fetch personal repositories
      personal_repos = client.repositories(user_info.login).map do |repo|
        repo_details = client.repository(repo.full_name)
        { repo: repo_details, org_avatar_url: repo_details.organization&.avatar_url }
      end

      # Fetch organizations the user is a member of
      organizations = client.organizations(user_info.login)
      @organizations = organizations
      @organizations_names = organizations.map(&:login) # Extracting login names of organizations

      # Fetch repositories from each organization
      org_repos = organizations.flat_map do |org|
        client.organization_repositories(org.login).map do |repo|
          repo_details = client.repository(repo.full_name)
          { repo: repo_details, org_avatar_url: repo_details.organization&.avatar_url }
        end
      end

      # Combine personal and organization repositories
      self.repos = personal_repos + org_repos

      # Fetch user's avatar URL
      @user_avatar = "https://github.com/users/#{user.nickname}.png"

      # Return the fetched data
      {
        user_info: user_info,
        organizations: organizations,
        repos: repos,
        organization_memberships: organization_memberships,
        user_avatar: user_avatar
      }
    rescue Octokit::Unauthorized => e
      puts "Error: Unauthorized - #{e.message}"
      nil
    rescue Octokit::NotFound => e
      puts "Error: User not found - #{e.message}"
      nil
    rescue Octokit::Error => e
      puts "Error: #{e.class} - #{e.message}"
      nil
    end 
  end

  def self.user_repo_permission(repo)
    return 'admin' if repo[:permissions][:admin]
    return 'maintainer' if repo[:permissions][:maintain]
    
    'member' # default to 'member' if neither 'admin' nor 'maintain' permissions are true
  end
end
