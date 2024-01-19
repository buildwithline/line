module GithubApiHelper
  class << self
    attr_accessor :organizations, :repos, :organization_memberships, :user_avatar

    def fetch_github_data(user)
      client_id = Rails.application.credentials.dig(:github, :client_id)
      client_secret = Rails.application.credentials.dig(:github, :client_secret)

      response = RestClient.get("https://api.github.com/users/#{user.nickname}", { params: {
        client_id: client_id,
        client_secret: client_secret
      } })

      user_data = JSON.parse(response.body)
      @user_avatar = "https://github.com/users/#{user.nickname}.png"

      organizations_response = RestClient.get("https://api.github.com/users/#{user.nickname}/orgs", { params: {
        client_id: client_id,
        client_secret: client_secret 
      } })

      @organizations = JSON.parse(organizations_response.body)

      @repos = []
      @organization_memberships = {} # To store membership information for each repository

      org_membership_zaikio = RestClient.get("https://api.github.com/orgs/zaikio/memberships/codersquirrelbln", headers: {
        Authorization: "Bearer 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",
        'Accept': 'application/vnd.github+json',
        'X-GitHub-Api-Version': '2022-11-28'
      })

      pp org_membership_zaikio
      # @organizations.each do |organization|
      #   memberships_response = RestClient.get(
      #     "https://api.github.com/orgs/#{organization['login']}/memberships/#{user.nickname}",
      #     headers: {
      #       Authorization: "Bearer #{user.github_access_token}",
      #       'Accept': 'application/vnd.github+json',
      #       'X-GitHub-Api-Version': '2022-11-28'
      #     }
      #   )

      #   case memberships_response.code
      #   when 204
      #     # User is a member of the organization
      #     puts "User is a member of #{organization['login']}"
          
      #     # Check if the response body is not empty and is valid JSON
      #     if memberships_response.body.present?
      #       begin
      #         memberships = JSON.parse(memberships_response.body)
      #       rescue JSON::ParserError => e
      #         # Handle JSON parsing error
      #         puts "JSON parsing error: #{e.message}"
      #       end
      #     else
      #       puts "Empty response body"
      #     end
      #     # # User is a member of the organization
      #     # puts "User is a member of #{organization['login']}"
      #     # puts "Response body: #{memberships_response.body}"
      #     # memberships = JSON.parse(memberships_response.body)
      #     # role = memberships['role']
      #     # @organization_memberships[organization['login']] = { role: role }
      #   when 404
      #     # User is not a member of the organization
      #     puts "User is not a member of #{organization['login']}"
      #   else
      #     # Handle other response codes
      #     puts "GitHub API request failed: #{memberships_response.code} - #{memberships_response.body}"
      #   end

        # repos_response = RestClient.get("https://api.github.com/orgs/#{organization['login']}/repos")
        # org_repos = JSON.parse(repos_response.body)
        # @repos += org_repos
      # end

      user_data
    end
  end
end