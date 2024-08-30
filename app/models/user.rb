# frozen_string_literal: true

class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable, :trackable,
         :recoverable, :rememberable, :validatable, :omniauthable, omniauth_providers: [:github]

  has_one :wallet, dependent: :destroy
  has_many :campaigns
  has_many :contributions
  has_many :contributed_campaigns, through: :contributions, source: :campaign

  def self.from_omniauth(auth)
    where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
      user.provider = auth.provider
      user.uid = auth.uid
      user.nickname = auth.info.nickname
      user.avatar_url = auth.info.image

      user.email = auth.info.email
      user.password = Devise.friendly_token

      user.github_access_token = auth.credentials.token

      user.sync_github_user_data
      user
    end
  end

  def sync_github_user_data
    github_service = GithubApiService.new(self)
    user_data = github_service.fetch_user_data

    return unless user_data

    update(
      nickname: user_data['login'],
      avatar_url: user_data['avatar_url']
    )
  end

  def sync_github_repo_data
    github_service = GithubApiService.new(self)
    repo_data = github_service.fetch_repo_data

    return unless repo_data

    update(
      full_name: repo_data[:full_name],
      name: repo_data[:name]
    )
  end
end
