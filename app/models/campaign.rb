class Campaign < ApplicationRecord
  belongs_to :user
  belongs_to :receiving_wallet, class_name: 'Wallet', foreign_key: 'receiving_wallet'

  # Validation for title, ensure it's present or meets your criteria
  validates :title, presence: true
  validates :repo_identifier, presence: true
  validates :repo_url, presence: true, format: { with: URI::DEFAULT_PARSER.make_regexp(%w[http https]) }

  scope :by_repo_identifier, ->(identifier) { where(repo_identifier: identifier).first }

  # Optional association indicator for UI logic or elsewhere
  def repo_centric?
    repo_identifier.present?
  end
end
