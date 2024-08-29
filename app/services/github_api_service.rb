# frozen_string_literal: true

require 'net/http'
require 'json'

class GithubApiService
  GITHUB_API_BASE_URL = 'https://api.github.com'

  def initialize(user)
    @access_token = user.github_access_token
    puts "user.github_access_token #{user.github_access_token}"
  end

  def fetch_user_data
    uri = URI("#{GITHUB_API_BASE_URL}/user")
    puts "uri #{uri}"
    response = make_get_request(uri)
    puts "response #{response}"

    if response.is_a?(Net::HTTPSuccess)
      puts 'is an net https success'
      parse_user_data(response.body)
    else
      puts 'nope'
      Rails.logger.error "GitHub API error: #{response.message}"
    end
  end

  private

  def make_get_request(uri)
    request = Net::HTTP::Get.new(uri)
    request['Authorization'] = "token #{@access_token}"
    request['User-Agent'] = 'RailsApp'

    Net::HTTP.start(uri.host, uri.port, use_ssl: true) do |http|
      http.request(request)
    end
  end

  def parse_user_data(response_body)
    JSON.parse(response_body).slice('login', 'avatar_url', 'html_url')
  end
end
