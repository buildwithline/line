# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model do
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

  describe '.from_omniauth' do
    let(:auth) do
      OmniAuth::AuthHash.new(
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
      )
    end

    it 'creates a user from omniauth data' do
      user = User.from_omniauth(auth)
      expect(user).to be_persisted
      expect(user.email).to eq('test@example.com')
      expect(user.nickname).to eq('testuser')
      expect(user.avatar_url).to eq('http://example.com/avatar.png')
      expect(user.github_access_token).to eq('mock_token')
    end

    it 'finds an existing user from omniauth data' do
      existing_user = create(:user, provider: 'github', uid: '123456', email: 'test@example.com')
      user = User.from_omniauth(auth)
      expect(user).to eq(existing_user)
    end
  end
end
