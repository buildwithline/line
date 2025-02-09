# frozen_string_literal: true

require 'json'

class GithubApiService
  GITHUB_API_BASE_URL = 'https://api.github.com'

  def initialize(user)
    @access_token = user.github_access_token
    @nickname = user.nickname
  end

  def fetch_user_data
    uri = URI("#{GITHUB_API_BASE_URL}/user")
    response = make_get_request_for_user_data(uri)

    if response.success?
      parse_user_data(response.body)
    else
      Rails.logger.error "GitHub API error: #{response.message}"
      nil
    end
  end

  private

  def make_get_request_for_user_data(uri)
    HTTParty.get(
      uri.to_s,
      headers: {
        'Authorization' => "token #{@access_token}",
        'User-Agent' => 'RailsApp'
      }
    )
  end

  def parse_user_data(response_body)
    JSON.parse(response_body).slice('login', 'avatar_url', 'html_url')
  end
end
