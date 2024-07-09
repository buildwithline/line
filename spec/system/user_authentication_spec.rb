# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'User Authentication', type: :system do
  before do
    OmniAuth.config.test_mode = true
    OmniAuth.config.mock_auth[:github] = OmniAuth::AuthHash.new({
                                                                  provider: 'github',
                                                                  uid: '123456',
                                                                  info: {
                                                                    email: 'test@example.com',
                                                                    nickname: 'testuser',
                                                                    image: 'http://example.com/avatar.png'
                                                                  },
                                                                  credentials: {
                                                                    token: 'mock_token'
                                                                  }
                                                                })
    # Mock GitHub API responses
    stub_request(:get, 'https://api.github.com/user')
      .to_return(status: 200, body: { login: 'testuser' }.to_json, headers: { 'Content-Type' => 'application/json' })

    stub_request(:get, 'https://api.github.com/user/repos')
      .to_return(status: 200, body: [].to_json, headers: { 'Content-Type' => 'application/json' })

    stub_request(:get, 'https://api.github.com/users/testuser/repos')
      .with(
        headers: {
          'Accept' => 'application/vnd.github.v3+json',
          'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
          'Authorization' => 'token mock_token',
          'Content-Type' => 'application/json',
          'User-Agent' => 'Octokit Ruby Gem 5.6.1'
        }
      )
      .to_return(status: 200, body: [].to_json, headers: { 'Content-Type' => 'application/json' })

    stub_request(:get, 'https://api.github.com/users/testuser/orgs')
      .with(
        headers: {
          'Accept' => 'application/vnd.github.v3+json',
          'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
          'Authorization' => 'token mock_token',
          'Content-Type' => 'application/json',
          'User-Agent' => 'Octokit Ruby Gem 5.6.1'
        }
      )
      .to_return(status: 200, body: [].to_json, headers: { 'Content-Type' => 'application/json' })
  end

  it 'allows user to sign in with GitHub' do
    visit root_path

    click_button 'Log in with GitHub'

    expect(page).to have_css('p', text: 'Hello, testuser, welcome to Line - The Developers Marketplace')
  end
end
