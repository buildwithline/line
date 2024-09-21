# frozen_string_literal: true

class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable, :trackable,
         :recoverable, :rememberable, :validatable, :omniauthable, omniauth_providers: [:github]

  #  Associations
  has_one :wallet, dependent: :destroy
  has_many :repositories, dependent: :destroy
  has_many :campaigns, through: :repositories
  has_many :contributions, dependent: :destroy
  has_many :contributed_campaigns, through: :contributions, source: :campaign

  # callbacks
  after_create_commit :enqueue_repo_sync_job

  def self.from_omniauth(auth)
    user = where(provider: auth.provider, uid: auth.uid).first_or_create do |u|
      u.provider = auth.provider
      u.uid = auth.uid
      u.nickname = auth.info.nickname
      u.avatar_url = auth.info.image

      u.email = auth.info.email
      u.password = Devise.friendly_token

      u.github_access_token = auth.credentials.token
    end

    user.enqueue_repo_sync_job
    user
  end

  def sync_repositories
    SyncReposService.new(self).call
  end

  def enqueue_repo_sync_job
    SyncReposJob.perform_later(id)
  end
end
