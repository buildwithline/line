# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model do
  before do
    stub_request(:get, 'https://api.github.com/user')
      .with(
        headers: {
          'Authorization' => 'token mock_token',
          'User-Agent' => 'RailsApp',
          'Accept' => '*/*',
          'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3'
        }
      )
      .to_return(
        status: 200,
        body: {
          login: 'testuser',
          avatar_url: 'http://example.com/avatar.png',
          html_url: 'http://example.com/testuser'
        }.to_json,
        headers: { 'Content-Type' => 'application/json' }
      )
  end

  describe '.from_omniauth' do
    let(:auth_hash) do
      OmniAuth::AuthHash.new(
        provider: 'github',
        uid: '123456',
        info: {
          email: 'test@example.com',
          nickname: 'testuser'
        },
        credentials: {
          token: 'mock_token'
        }
      )
    end

    it 'is valid with valid attributes' do
      user = build(:user)
      expect(user).to be_valid
    end

    it 'is not valid without an email' do
      user = build(:user, email: nil)
      expect(user).not_to be_valid
    end

    it 'is not valid without a password' do
      user = build(:user, password: nil)
      expect(user).not_to be_valid
    end

    it 'has a unique email' do
      create(:user, email: 'test@example.com')
      user = build(:user, email: 'test@example.com')
      expect(user).not_to be_valid
    end

    it 'has a valid factory' do
      expect(build(:user)).to be_valid
    end

    it 'creates a user from omniauth data' do
      user = User.from_omniauth(auth_hash)
      expect(user).to be_persisted
      expect(user.email).to eq('test@example.com')
      expect(user.nickname).to eq('testuser')
      expect(user.avatar_url).to eq('http://example.com/avatar.png')
      expect(user.github_access_token).to eq('mock_token')
    end

    it 'finds an existing user from omniauth data' do
      existing_user = create(:user, provider: 'github', uid: '123456', email: 'test@example.com')
      user = User.from_omniauth(auth_hash)
      expect(user).to eq(existing_user)
    end
  end
end
