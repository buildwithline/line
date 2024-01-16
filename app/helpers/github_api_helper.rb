module GithubApiHelper
  class << self
    attr_accessor :organizations

    def fetch_github_data(github_nickname)
      @client_id = Rails.application.credentials.dig(:github, :client_id)
      @client_secret = Rails.application.credentials.dig(:github, :client_secret)

      response = RestClient.get("https://api.github.com/users/#{github_nickname}", { params: { client_id: @client_id, client_secret: @client_secret } })

      user_data = JSON.parse(response.body)

      organizations_response = RestClient.get("https://api.github.com/users/#{github_nickname}/orgs", { params: { client_id: @client_id, client_secret: @client_secret } })
      @organizations = JSON.parse(organizations_response.body)

      user_data
    end
  end
end
