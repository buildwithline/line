module GithubApiHelper
  class << self
    attr_accessor :organizations, :repos, :user_avatar

    def fetch_github_data(github_nickname)
      @client_id = Rails.application.credentials.dig(:github, :client_id)
      @client_secret = Rails.application.credentials.dig(:github, :client_secret)

      response = RestClient.get("https://api.github.com/users/#{github_nickname}", { params: { client_id: @client_id, client_secret: @client_secret } })

      user_data = JSON.parse(response.body)
      @user_avatar = github_nickname.png

      organizations_response = RestClient.get("https://api.github.com/users/#{github_nickname}/orgs", { params: { client_id: @client_id, client_secret: @client_secret } })
      @organizations = JSON.parse(organizations_response.body)

      @repos = []

      @organizations.each do |organization|
        repos_response = RestClient.get("https://api.github.com/orgs/#{organization['login']}/repos")
        org_repos = JSON.parse(repos_response.body)
        @repos += org_repos
      end

      user_data
    end
  end
end
