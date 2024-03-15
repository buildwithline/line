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
    end
  end

  def github_repos
    Rails.cache.fetch("#{cache_key_with_version}/github_repos", expires_in: 12.hours) do
      GithubApiHelper.fetch_github_data(self)[:repos]
    end
  end
end
