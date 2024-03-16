class Campaign < ApplicationRecord
  belongs_to :user
  belongs_to :receiving_wallet, class_name: 'Wallet', foreign_key: 'receiving_wallet_id'

  # Validation for title, ensure it's present or meets your criteria
  validates :title, presence: true
  validates :repo_identifier, presence: true, uniqueness: { scope: :user_id, message: 'has already been used for a campaign' }
  validates :tier_name, presence: true
  validates :tier_amount, numericality: { greater_than: 0 }

  scope :by_repo_identifier, ->(identifier) { where(repo_identifier: identifier).first }

  # Optional association indicator for UI logic or elsewhere
  def repo_centric?
    repo_identifier.present?
  end
end
