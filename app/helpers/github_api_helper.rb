module GithubApiHelper

  require 'rest-client'
  require 'json'
  class << self
    attr_accessor :organizations, :repos, :organization_memberships, :user_avatar

    def user_admin_for_organization?(user, organization)
      owner_or_admin_response = RestClient.get(
        "https://api.github.com/orgs/#{organization}/members?role=admin"
      )
      members = JSON.parse(owner_or_admin_response.body)
      # pp members

      case owner_or_admin_response.code
      when 200
        members = JSON.parse(owner_or_admin_response.body)
        return members.any? { |member| member['login'] == user.nickname }
      when 403
        # Forbidden, user doesn't have permission to access the organization members
        puts "Forbidden: User #{user.nickname} doesn't have permission to access members in #{organization}"
      else
        # Handle other response codes
        puts "GitHub API request failed: #{owner_or_admin_response.code} - #{owner_or_admin_response.body}"
      end

      return false
    end
  
    def fetch_github_data(user)
      client_id = Rails.application.credentials.dig(:github, :client_id)
      client_secret = Rails.application.credentials.dig(:github, :client_secret)
      # return unless check_token_validity(client_id, user.github_access_token)

      user_data_response = RestClient.get("https://api.github.com/users/#{user.nickname}", { params: {
        client_id: client_id,
        client_secret: client_secret
      } })

      user_data = JSON.parse(user_data_response.body)
      @user_avatar = "https://github.com/users/#{user.nickname}.png"

      organizations_data_response = RestClient.get("https://api.github.com/users/#{user.nickname}/orgs", { params: {
        client_id: client_id,
        client_secret: client_secret 
      } })

      @organizations = JSON.parse(organizations_data_response.body)

      @repos = []
      @organization_memberships = {} # To store membership information for each repository

      @organizations.each do |organization|
        admin_response = RestClient.get("https://api.github.com/orgs/#{organization['login']}/members?role=admin"
        )

        case admin_response.code
        when 200
          members = JSON.parse(admin_response.body)
          if members.any? { |member| member['login'] == user.nickname }
            # User is an admin or owner in this organization
            puts "User #{user.nickname} is an admin or owner in #{organization['login']}"
          else
            # User is not an admin or owner in this organization
            puts "User #{user.nickname} is not an admin or owner in #{organization['login']}"
          end
        when 403
          # Forbidden, user doesn't have permission to access the organization members
          puts "Forbidden: User #{user.nickname} doesn't have permission to access members in #{organization['login']}"
        else
          # Handle other response codes
          puts "GitHub API request failed: #{admin_response.code} - #{admin_response.body}"
        end
        
        repos_response = RestClient.get("https://api.github.com/orgs/#{organization['login']}/repos")
        organization_repos = JSON.parse(repos_response.body)
        pp organization_repos
        @repos += organization_repos
      end

      user_data
    end
  end


  private

  def check_token_validity(client_id, access_token)
    token_response = RestClient.get(
      "https://api.github.com/applications/#{client_id}/tokens/#{access_token}",
      headers: { 'Accept': 'application/vnd.github.v3+json' }
    )
  
    case token_response.code
    when 200
      puts 'Token is valid'
      return true
    when 404
      puts 'Token is not valid'
      return false
    else
      puts "Unexpected response: #{token_response.code}"
      return false
    end
  end
end