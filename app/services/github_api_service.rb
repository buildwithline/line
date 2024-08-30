# frozen_string_literal: true

require 'net/http'
require 'json'

class GithubApiService
  GITHUB_API_BASE_URL = 'https://api.github.com'

  def initialize(user)
    @access_token = user.github_access_token
    @nickname = user.nickname
    puts "user.github_access_token #{user.github_access_token}"
  end

  def fetch_user_data
    uri = URI("#{GITHUB_API_BASE_URL}/user")
    puts "uri #{uri}"
    puts "response #{response}"
    response = make_get_request_for_user_data(uri)

    if response.is_a?(Net::HTTPSuccess)
      puts 'is an net https success'
      parse_user_data(response.body)
    else
      puts 'nope'
      Rails.logger.error "GitHub API error: #{response.message}"
    end
  end

  def fetch_repo_data
    uri = URI("#{GITHUB_API_BASE_URL}/users/#{@nickname}/repos")

    response = make_get_request_for_repo_data(uri)

    if response.is_a?(Net::HTTPSuccess)
      parse_repo_data(response.boody)
    else
      Rails.logger.error "GitHub API error: #{response.message}"
    end
  end

  private

  def make_get_request_for_user_data(uri)
    request = Net::HTTP::Get.new(uri)
    request['Authorization'] = "token #{@access_token}"
    request['User-Agent'] = 'RailsApp'

    Net::HTTP.start(uri.host, uri.port, use_ssl: true) do |http|
      http.request(request)
    end
  end

  def make_get_request_for_repo_data(uri)
    request = Net::HTTP::Get.new(uri)
    request['Authorization'] = "token #{@access_token}"
    request['User-Agent'] = 'RailsApp'

    Net::HTTP.start(uri.host, uri.port, use_ssl: true) do |http|
      http.request(request)
    end
  end

  def parse_user_data(response_body)
    user_data = JSON.parse(response_body)
    {
      'login' => user_data['login'],
      'avatar_url' => user_data['avatar_url'],
      'html_url' => user_data['html_url']
    }
    user_data
  end

  def parse_repo_data(response_body)
    JSON.parse(response_body).slice('name', 'full_name', 'html_url', 'id')
  end
end
