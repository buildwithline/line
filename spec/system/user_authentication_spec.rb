# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'User Authentication', type: :system do
  before do
    setup_omniauth_mock
    stub_github_api_requests
  end

  it 'allows user to sign in with GitHub' do
    visit root_path

    click_button 'Log in with GitHub'

    expect(page).to have_content('Hello, testuser')
  end

  def setup_omniauth_mock
    OmniAuth.config.test_mode = true
    OmniAuth.config.mock_auth[:github] = OmniAuth::AuthHash.new(
      provider: 'github',
      uid: '123456',
      info: {
        email: 'test@example.com',
        nickname: 'testuser',
        avatar: 'http://example.com/avatar.png'
      },
      credentials: {
        token: 'mock_token'
      }
    )
  end

  def stub_github_api_requests
    user_data_response = {
      login: 'testuser',
      avatar_url: 'http://example.com/avatar.png',
      html_url: 'http://example.com/testuser'
    }.to_json

    common_headers = {
      'Accept' => 'application/vnd.github.v3+json',
      'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
      'Authorization' => 'token mock_token',
      'Content-Type' => 'application/json',
      'User-Agent' => 'Octokit Ruby Gem 5.6.1'
    }

    stub_request(:get, 'https://api.github.com/user')
      .to_return(status: 200, body: user_data_response, headers: { 'Content-Type' => 'application/json' })

    stub_request(:get, 'https://api.github.com/user/repos')
      .to_return(status: 200, body: [].to_json, headers: { 'Content-Type' => 'application/json' })

    stub_request(:get, 'https://api.github.com/users/testuser/repos')
      .with(headers: common_headers)
      .to_return(status: 200, body: [].to_json, headers: { 'Content-Type' => 'application/json' })

    stub_request(:get, 'https://api.github.com/users/testuser/orgs')
      .with(headers: common_headers)
      .to_return(status: 200, body: [].to_json, headers: { 'Content-Type' => 'application/json' })
  end
end
